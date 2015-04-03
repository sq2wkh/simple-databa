#!/usr/bin/ksh
#autor: Adam Lipiński MZ01P01
# pokazuje menu oraz przekierowuje do odpowiedniej akcji
menu(){
	echo "================================="
	echo "|	1. Dodaj wpis		|"
	echo "|	2. Usun wpis		|"
	echo "|	3. Edytuj wpis		|"
	echo "|	4. Szukaj		|"
	echo "|	5. Wyswietl baze	|"
	echo "|	6. Wyjscie		|"
	echo "================================="
	echo ""
	echo "Wybierz opcje:"
	read option
	case $option in
		1) add;;
		2) remove;;
		3) edit;;
		4) search;;
		5) print;;
		6) exit;;
		*) clear; echo "Zla opcja wybierz poprawnie!"; menu;;
	esac	
}

#dodaje wpis do ksiażki telefonicznej wymagane pola: imię, nazwisko, telefon
add(){
	echo "Podaj imię"
	read name
	echo "Podaj nazwisko"
	read lastName
	echo "Podaj pseudo"
	read pseudo
	echo "Podaj numer telefonu"
	read tel
	echo "Podaj kod pocztowy"
	read postalCode
	echo "Podaj miasto"
	read city
	echo "Podaj ulice"
	read street
	echo "Podaj numer budynku"
	read flatNumber
	echo "Podaj numer lokalu"
	read roomNumber
	counter=$(sed -n "$=" db.cl)
	let counter=$counter+1
	`echo "$counter|$name|$lastName|$pseudo|$tel|$postalCode|$city|$street|$flatNumber|$roomNumber|" >> db.cl`
	return
}

#usuwa wpis z ksiązki telefonicznej
remove(){
	echo "Podaj numer porządkowy do usuniecia"
	read line
	touch temp
	chmod +r+w+x temp
	sed "/^${line}|/d" $DBFILE > temp && mv temp $DBFILE
	
}

#edytuje wpis w ksiażce telefonicznej
edit(){
	echo "Podaj numer osoby do edycji"
	read line
	echo "chcesz edytować osobe o parametrach:"
	sed -n "${line}p" $DBFILE
	echo "Edytuj 1-numer porzadkowy 2-imie 3-nazwisko 4-pseudo 5-telefon"
	echo "6-kod pocztowy 7-miasto 8-ulice 9-numer domu 10-numer lokalu"
	read option
	echo "Podaj artosc na którą chcesz zmienic"
	read value
	awk -v o=$option -v l=$line -v v=$value -F '|' 'FNR == l {$o=v}1' OFS='|' $DBFILE > temp && mv temp $DBFILE
}

# wyszukuje wpis w ksiązce telefonicznej
search(){
	echo "Podaj fraze do wyszukania"
	read phrase
	result=`cat db.cl | grep "$phrase"`
	echo $result
	return result
}
print(){
	more $DBFILE
}

DBFILE="db.cl";

if [[ -e "$DBFILE" ]]; then
	echo "Wczytuje bazę z pliku $DBFILE"
else
	`touch db.cl`
	`chmod +r+w db.cl`
fi
if [[ $# -eq 0 ]]; then
   menu
else
   print "ww"
fi

