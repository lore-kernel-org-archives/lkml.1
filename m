Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYE3UY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYE3UY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYE3UYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:24:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:29330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbYE3UYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:24:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,568,1204531200"; 
   d="scan'208";a="334261036"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: How many contributors are we losing
Date: Fri, 30 May 2008 13:23:44 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC017405EB@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080529022632.GB5180@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: How many contributors are we losing
Thread-Index: AcjBM78OAmcBN+H4TbqoYP62FLv9xgBWuSXQ
References: <20080528225136.GA29014@kroah.com> <1FE6DD409037234FAB833C420AA843EC016FFF69@orsmsx424.amr.corp.intel.com> <20080529003657.GA17505@kroah.com> <20080529010055.GA31952@redhat.com> <20080529022632.GB5180@kroah.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Greg KH" <greg@kroah.com>, "Dave Jones" <davej@redhat.com>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       <ksummit-2008-discuss@lists.linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 May 2008 20:23:45.0933 (UTC) FILETIME=[0FB17BD0:01C8C293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg wrote:
> I also have "cleaned up" versions of the kernel log files for just the
> reason you say above.  You would not believe the number of times some
> people mispell their own name in a single kernel release...  That makes
> it easier to do this kind of mapping.  The cleaned up logs are in that
> directory as well.

I took those cleaned up log files (which run from 2.6.11 to 2.6.22) and
created some new ones (raw, I didn't try to clean them) for 2.6.23, 2.6.24,
2.6.25 and 2.6.26-sofar.  Then I skimmed through looking for drive-by
contributors (defined as someone who contributes to just one release and
is then never heard from again).

The summary looks like this:
63 in version 2.6.11 never seen again
148 in version 2.6.12 never seen again
128 in version 2.6.13 never seen again
92 in version 2.6.14 never seen again
96 in version 2.6.15 never seen again
122 in version 2.6.16 never seen again
137 in version 2.6.17 never seen again
140 in version 2.6.18 never seen again
135 in version 2.6.19 never seen again
95 in version 2.6.20 never seen again
136 in version 2.6.21 never seen again
153 in version 2.6.22 never seen again
179 in version 2.6.23 never seen again
179 in version 2.6.24 never seen again
304 in version 2.6.25 never seen again

These numbers are somewhat exaggerated by typos (the "cleaned up" files
still have some problems in the "Author:" entry (which is the only one
I looked at).  People add or drop middle initials, or sometimes switch
between "Firstname Lastname" and "Lastname, Firstname", and there are
plenty of obviously garbled entries.

The numbers for the more recent releases may also include
people who are still in the community, but just don't contribute to
every release.

My script didn't look for people that contributed for two or more
releases and then disappeared.

You can skim through the full list at the bottom of this message
and make your own guesses at how much of this data is garbage.
Even if 3/4 of the names here can be discounted, that still leaves
over 500 people who came to us at one point with a patch that was
good enough to be applied and then they left.

-Tony

==== Scanning 2.6.11
Margit Schubert-While
Peter Maydell
Matthias-Christian Ott
Daniel E. Markle
Arkadiusz Miskiewicz
Jarno Paananen
Jonas Munsin
Tvrtko A. Ursulin
Ron Murray
Ulrich Weigand
Martins Krikis
Edwin Olson
Rafael Avila de Espindola
Per Hedblom
Kamezawa Hiroyuki
Tom L. Nguyen
Kazunori Miyazawa
Jim Hague
J. A. Magallon
Prakash Cheemplavam
Stone Wang
Georgi Guninski
Nathan Bryant
Suresh B Siddha
Mat Loikkanen
Bill Rugolsky
Haroldo Gamal
Josh Green
Ian Pratt
Nicolas Bouliane
Esben Nielsen
Thayne Harbaugh
Herbert Potzl
Jan Kasprzak
Hanna V. Linder
Josh Aas
Martin Kogler
Theodore Y. Ts'o
Werner Almesberger
Gary N. Spiess
Olsimar
Maksim Krasnyanskiy
Juergen Quade
Pawel Sikora
Philipp Gortan
Oskar Senft
Samuel Jean
Alex Yustasov
Milton D. Miller II
Fanny Wakizaka
Andris Pavenis
Rogier Wolff
Artem Bityuckiy
Tom Coughlan
Vasia Pupkin
Thomas Spatzier
Franz Pletz
Justin Thiessen
Darrick Wong
Stefan Knoblich
Andrew Theurer
Gabor Egry
David Marlin
63 in version 11 never seen again

==== Scanning 2.6.12
Dave Neuer
johnpol@2ka.mipt.ru
Stefan Ott
dgoeddel@trustedcs.com
ecashin@coraid.com
Daniel Andersen
maartendeprez@scarlet.be
wendyx@us.ibm.com
pingc@wacom.com
hfvogt@gmx.net
Seth Rohit
jkacur@rogers.com
Tim Bird
Cosmin Nicolaescu
Kai M√§kisara
takata@org.rmk.(none)
Kenn Humborg
blaisorblade@yahoo.it
lucasvr@gobolinux.org
Jeff Lackey
Asim Shankar
Daniel Dickman
Rafael √Åvila de Esp√≠ndola
cbrake@com.rmk.(none)
jason@rightthere.net
Pravin B. Shelar
Eric Brower
Fran√ßois Romieu
hong.liu@intel.com
hwelte@hmw-consulting.de
Chris Elston
Frederic CAND
rene.scharfe@lsrfire.ath.cx
hal@realmsys.com
Emanuele Giaquinta
Wensong Zhang
lucasvr@org.rmk.(none)
vandrove@cz.rmk.(none)
Bharath Ramesh
J. Simonetti
NAKAMURA Kenta
bram.verweij@wanadoo.nl
Mark F. Haigh
mbrancaleoni@tiscali.it
perchrh@pvv.org
carlos.pardo@siliconimage.com
Michael Werner
Ben Greear
kianusch@sk-tech.net
Giovambattista Pulcini
pavel@cz.rmk.(none)
Niu YaWei
richtera@us.ibm.com
Viktor A. Danilov
Bob Montgomery
jan.kiszka@web.de
rene@exactcode.de
Vinay K Nallamothu
McMullan, Jason
svrmgrl@gmx.net
Oliver Korpilla
Jakub Jel√≠nek
n1gp@hotmail.com
kay.sievers@vrfy.org
Mickey Stein
Larry Battraw
Thomas Hood
Brian Waite
gam3@gam3.net
jbj1@ultraemail.net
ken@mvista.com
Jack F Vogel
Sven Anderson
kimball.murray@stratus.com
incent Sanders
Christopher Li
James Harper
relf@os2.ru
Richard Drummond
andi@cosy.sbg.ac.at
aquynh@gmail.com
pj@engr.sgi.com
shaharf@voltaire.com
aaw@rincewind.tv
tero_niemela@yahoo.com
Peter Lundkvist
Albrecht Dreﬂ
jix@bugmachine.ca
dick@com.rmk.(none)
Herbert P√∂tzl
steven@brudenell.name
Gabor Fekete
Gordon Jin
domen@coderock.org
Kianusch Sayah Karadji
Dely Sy
gijoe@poczta.onet.pl
cl81@gmx.net
ariel@blueslice.com
a.llano@usyscom.com
Hideaki YOSHIFUJI
akropel@rochester.rr.com
David T. Hollis
mlafon@arkoon.net
Jason Davis
Daniel Moore
elueck@de.ibm.com
Liu Tao
liml@rtr.ca
Arthur Huillet
Lars Marowsky-Bree
RÈmi Denis-Courmont
afong@org.rmk.(none)
venza@brownhat.org
Marcello Maggioni
Alex Zarochentsev
Goffredo Baroncelli
Vivian Bregier
Jerome Forissier
Stephen Tweedie
matthias.kunze@gmx-topmail.de
mstjohns@mindspring.com
bstroesser@fijitsu-siemens.com
Andree Leidenfrost
minyard@acm.org
ssant@in.ibm.com
Patrick vd Lageweg
Andre Tomt
Frank Beesley
simon@thekelleys.org.uk
duraid@octopus.com.au
Dan Malek
Arjan Bunk
Shawn Starr
Pete Jewell
Francisco Javier
felix@derklecks.de
lkml@einar-lueck.de
tzachar@cs.bgu.ac.il
christian@leber.de
Rich Walker
craig@microtron.org.uk
050035w@acadiau.ca
Darren Williams
Georges Toth
grant_nospam@dodo.com.au
gmenguez@usuarios.retecal.es
Jeroen Vreeken
148 in version 12 never seen again

==== Scanning 2.6.13
Dietmar Eggemann
Lorenzo Hern·ndez GarcÌa-Hierro
Allan Stirling
Daniele Lacamera
Stefan Sorensen
Masahito Omote
Natalie.Protasevich@unisys.com
Herbert
Simon Derr
Hans-Juergen Tappe
Hien Nguyen
Stephane VOLTZ
Martin Schitter
suzuki
Luca Falavigna
David A. Marlin
David Ranson
Zaur Kambarov
rajesh.shah@intel.com
Jonas Holmberg
Janet Morgan
Loic Le Loarer
Lorenzo Hernandez GarcÌa-Hierro
david-b@pacbell.net
Michael Paxton
Andrew Hodgson
Michael Iatrou
Philip Pokorny
Vincent Vanackere
Jesse Millan
Gavin Hamill
brian@murphy.dk
Matt
Keith Moore
mochel@digitalimplant.org
Simone Zinanni
Darren Hart
Thomas Charbonnel
Felipe
Hariprasad Nellitheertha
Peter Skipworth
Greg Felix
Jurriaan
Wolfgang Wander
bobl
Dmitry Yusupov
Kurt Wall
Ivan Casado Ruiz
Keiichiro Tokunaga
SÈbastien Dugu
Conger, Chris A
long
mike.miller@hp.com
Alexander Schulz
Ian Dall
Michael Gernoth
Jeremy White
Mikael Starvik
Richard Dawe
Nico Pitre
Stanislaw W. Gruszka
Sebastian Witt
Brad Campbell
David Meybohm
Hideki Yamane
Kiril Jovchev
C. Adam Oldham
Olivier Blin
Mike Strosaker
Sean Lee
Steffen Motzer
Sergey Ulanov
Utz Bacher
Gleb Natapov
Wen-chien Jesse Sung
Jurriaan on adsl-gate
Michael Prokop
Nico Golde
Rob Punkunus
BGardner@Wabtec.com
Hifumi Hisashi
Roger Mach
Matt Gillette
Yoav Zach
Chen Shang
Matthew Chapman
JT
John Levon
jayalk@intworks.biz
Bhavesh P. Davda
V. ANANDA KRISHNAN
Dinakar Guniguntala
Mathieu
pavel@ucw.cz
Nicolas S. Dade
Guillaume Autran
Abhijit Karmarkar
Reuben Farrelly
Marian-Nicolae V. Ion
Daniele Gaffuri
Dag Arne Osvik
TINNES Julien
Olivier Croquette
Jakub Bogusz
stephane.eranian@hp.com
Martin Loschwitz
Estelle Hammache
bgardner@wabtec.com
Christoph Schulz
David Chau
Blaisorblade
Sylvain Meyer
Gregory B Frost
Downing, Thomas
Manuel Capinha
Ben Colline
Emmanuel Colbus
Anton Wˆllert
Dan Brown
Luca T
Peter Zubaj
Nickolai Zeldovich
Rusty Lynch
Yani Ioannou
Bernhard Fischer
bob.picco
Sven Luther
Joachim Nilsson
128 in version 13 never seen again

==== Scanning 2.6.14
Mark J Cox
Kevin Vigor
Karl Herz
Guy German
Jon Wetzel
Karl Magnus Kolstoe
Dariusz M
Bryan Sutula
Jim Paradis
Erik Waling
Rumen Ivanov Zarev
Brandon Enochs
Renaud Lienhart
Stephane Kardas
Pavol Kurina
Martin Whitaker
Randall Nortman
Iacopo Spalletti
Andrew McDonald
Adam Szalkowski
Mitsuru KANDA
Jean-Denis Boyer
Yann Droneaud
Stephane Doyon
Daniel Horchner
Jason R. Martin
Timothy Thelin
Mauricio Lin
Eric Lemoine
Chris Sykes
Vincent Pelletier
Max Kellermann
Sven Hartge
Pieter Dejaeghere
Avery, Brian
Kenneth Chen
Christian Krause
Denis Lukianov
Philipp Matthias Hahn
Michael Haboustak
Gary Wayne Smith
Paul Schulz
P Draig Brady
Daniel Burcaw
Borislav Deianov
Thomas Maguin
David Johnson
Nakul Saraiya
Tsuneo Yoshioka
Peter Wainwright
Philip Prindeville
J. Suter
Alok N Kataria
Brian Schau
Naveen Gupta
John Kingman
Svante Olofsson
Karl Hegbloom
Scott Talbert
Vincent Sanders
Bagalkote, Sreenivas
Tziporet Koren
Barry Scott
Stephan Brodkorb
Yoshifumi Nishida
Chaskiel Grundman
Dominique Dumont
Christopher Zimmermann
Ion Badulescu
Oliver Dawid
Bernd Petrovitsch
Kostik Belousov
Stephen Evanchik
Mihnea-Costin Grigore
Jose Miguel Goncalves
Wim Coekaerts
Stephen Hemmigner
Zhigang Huo
Stuart McLaren
Krzysztof Benedyczak
KUROSAWA Takahiro
Michael Veeck
Joel Schopp
Ye Jianjun (Joey)
Otto Meier
Martin Wilck
Kolli, Neela Syam
Timothy Baldwin
thomas schorpp
Alexander Krizhanovsky
Baris Cicek
Brett M Russ
92 in version 14 never seen again

==== Scanning 2.6.15
John Linville
David Eriksson
Martin Zwickel
Reimar Doeffinger
Pavel Mihaylov
Elad Lahav
Hiroki Kaminaga
Wei Ni
Chris Elmquist
Toni Mueller
Ray Cole
Richard Hitt
Tom Hughes
Peter Keilty
Vinod G
Hideki Iwamoto
James R. Webb
Alex Aizman
Peter 'p2' De Schrijver
Krzysztof Piotr Oledzki
Krishnakumar R
Jon Ringle
Carlo Comin
Glen Gray
Bernhard Rosenkraenzer
Thomas Riewe
Liu Hong
Konstantin Baidarov
Suzanne Wood
Charles R. Anderson
Ed Kear
Constantine Gavrilov
Antti Andreimann
Hareesh Nagarajan
Kurt Huwig
Scott MacKenzie
Bryan Ford
Mateusz Berezecki
David Engel
Jeff Raubitschek
Luis Miguel Garcia
Ole Reinhardt
Ralph Metzler
Kamble, Nitin A
Igor Popik
Bill Pechter
Simeon Simeonov
Kenth Andersson
Ken-ichirou MATSUZAWA
Guillaume GOURAT
Andrew Isaacson
Tim
Andrey Volkov
Kirk Lapray
Will Dyson
Hiroyuki YAMAMORI
Catalin Climov
Dag-Erling Smorgrav
Damian Wrobel
Paul T Zalac
Mark Weaver
Mark Adams
Laurent riffard
David Shirley
Honza Maly
NooneImportant
Robert W. Boone
Thorsten Maerz
Carlos Silva
Jan Pieter
Paul Vriens
Josef Balatka
Roger While
Denny Priebe
Lubomir Bulej
Martin Hagelin
Edson Seabra
Khalid Aziz
Yuri Vasilevski
Jeff Hansen
Mike Stroyan
Rik Van Riel
Zach Smith
Lars Kotthoff
Hubert WS Lin
Mao, Bibo
Peter Jones
Torsten Seeboth
Stig Telfer
Alexandra Kossovsky
Karoly Lorentey
Alexander Wold
Nikola Valerjev
Mirco Macrelli
James Cleverdon
Mathias Kretschmer
96 in version 15 never seen again

==== Scanning 2.6.16
Juergen E. Fischer
Kevin VanMaren
Tong Li
Joerg Schummer
Takis
Shaun Tancheff
d binderman
Deti Fliegl
Julian Calaby
Keck, David
Fengwei Yin
Rocky Craig
Kaj-Michael Lang
Zinx Verituse
Adam D. Moss
Janosch Machowinski
Damien Douxchamps
Wolfram Joost
Joe Kappus
Oren Laadan
Hugo Santos
Franck
Joshua Giles
Denis MONTERRAT
Thomas Schaefer
Steve Langasek
Christopher Pascoe
Noone Important
Steve Toth
Kurt J. Bosch
Graham Gower
Luis F. Ortiz
Regis Prevot
Andre McCurdy
Andrew Fuller
Eric Van Buggenhaut
Albrecht Dress
John Kacur
Yusuf Iskenderoglu
Suresh Bhogavilli
SAN People
Daniele Gozzi
Avishay Traeger
Jun'ichi "Nick" Nomura
David Kubicek
Marc Koschewski
Christian Lindner
Gregor Maier
Taneli Vahakangas
Alex Woods
A.YOSHIYAMA
Thomas Rosner
Joe
Evgeniy
Michael Richardson
David Binderman
Gergely Tamas
Vitaly Fertman
Joshua Kwan
Samir Bellabes
fabien COSSE
Ryan Hankins
Simon Vogl
Loren M. Lang
Martin Murray
Trent Jaeger
Dirk Mueller
Chris McDermott
Michal Janusz Miroslaw
Matej Kupljen
Jesse Allen
Felix Oxley
Wouter Paesen
Alex Shepard
Ville Skytta
Francois Wellenrieter
Jordan, William P
Carlo Perassi
Tore Anderson
Rene Scharfe
Hendrik Schweppe
Mike Lavender
Richard Mortimer
Ulrich Mueller
Alexandre Duret-Lutz
George Gazurkoff
Martin Gingras
Panagiotis Christeas
Javier Achirica
V. Ananda Krishnan
Ravikiran Thirumalai
Jens-Michael Hoffmann
Richard Lucassen
Albert D. Cahalan
David Elliott
Jenx Axboe
Timothy Charles McGrath
JANAK DESAI
Oliver Weihe
Christoph Dworzak
Michael Matz
Andreas Deresch
Marten Wikstrom
Janak Desai
Martin Drab
Xu, Anthony
Jorn Dreyer
Marko Kohtala
ODonnell, Michael
Lukasz Stemach
Manenti Marco
Gareth Howlett
Tetsuo Takata
Brian Strand
Paul Janzen
Stephen Williams
Robb, Sam
Mishala Pytasz
Nicolas DICHTEL
David Shaw
Ustyugov Roman
Daniel Mueller
122 in version 16 never seen again

==== Scanning 2.6.17
Micon, David
Yotam Medini
Charl Coetzee
Seiji Munetoh
Stefan Schweizer
Doug McLain
Bauke Jan Douma
Ananiev, Leonid I
Rytchkov Alexey
Florian Schlichting
Steve Yang
Marc-Andre Hebert
Rodolfo Quesada
Matheus Izvekov
Weidong
A. Maitland Bottoms
Olivier Blondeau
Magnus Kessler
Lin Feng Shen
Craig Brind
Martin Andersson
Malcom Parsons
Satoshi Oshima
Ron Yorston
Laurent Meyer
Giampiero Giancipoli
Curt Meyers
John Reed Riley
Kevin Winchester
Masc
Klaus Wacker
Jeffrey Vandenbroucke
Bastien Roucaries
Catalin(ux aka Dino) BOIE
Markus Gutschke
David chosrova
Janos Farkas
Rickard Osser
Jamie Lokier
Paul Smith
Alan Modra
Glen Overby
S P
Ken Brush
Tolentino, Matthew E
Mikhail Gusarov
Soyoung Park
Joel H Schopp
Brian Rogan
Mark Salazar
Lorenzo Hernaindez Garci-Hierro
David Basden
Bryan Holty
J.O. Aho
Nathan Bronson
Peter Gruber
Victor V. Vengerov
Tamuki Shoichi
Anders Larsen
Hakon Lovdal
Steven Finney
Julian Bradfield
Arnaud MAZIN
Aras Vaichas
Kirk True
Monty
Thilo Berger
Goldwyn Rodrigues
Jamie Wellnitz
KAI.HSU
Jochen Hein
Brent Cook
Andrew Burri
Razvan Gavril
Petri T. Koistinen
Kalin KOZHUHAROV
Jordi Caubet
Carlos Aguiar
BoyZonder
Ingo Schneider
Peter Teichmann
Bernhard R Link
Philip Gladstone
Jordan Hargrave
Harry Fearnhamm
Dale Sedivec
Chad Reese
Alberto Mardegan
Navin Boppuri
Peter Hartshorn
Alexander Zarochentzev
Michael Owen
Alpt
Ilia Sotnikov
Ashley Clark
Jon Anders Haugum
Ryan Wilson
Charis Kouzinopoulos
Richard Thrippleton
Thibault LE MEUR
Maximilian Rehkopf
Pallipadi, Venkatesh
Hideo AOKI
Olivier Hochreutiner
Dirk Herrendoerfer
Ken Arromdee
Aaron Brooks
Nico Schottelius
James Ring
Ami Perlmutter
Rune Torgersen
Aki M Nyrhinen
shin, jacob
Wang Jun
Horst Kronstorfer
Thayumanavar Sachithanantham
Brian Uhrain says
Erling A. Jacobsen
Artur Skawina
C.Y.M
Ben Woodard
Bart Samwel
John Z. Bohach
Ryan S. Arnold
Bunk
Rudo Thomas
Malte Doersam
Robert Hentosh
Levent Serinol
Tobias Powalowski
Grzegorz Janoszka
Michael Ryan
Matthias Gehre
Kenrik Kretzschmar
Robin H. Johnson
Tomasz Koprowski
Andreas Happe
137 in version 17 never seen again

==== Scanning 2.6.18
Navaho Gunleg
Cameron Hutchinson
Henk Vergonet
Daikichi Osuga
Dustin McIntire
Zoran Marceta
Rich Townsend
Kai Lindhom
olecom
Starikovskiy, Alexey Y
Bartlomiej Swiercz
Muthu Kumar
Olaf Weber
Daniel Kobras
Malcolm Valentine
Hartmut Rick
ravikiran thirumalai
Val Henson
Andy Walker
Shankar Anand
Vladislav Bolkhovitin
Kenneth Lee
Michael LeMay
Christian Lupien
Thomas Horsley
Axel Dyks
Takashi YOSHI
Edwin Huffstutler
Jorge Matias
Thago Galesi
Yingchao Zhou
Kim Oldfield
Piotr Kaczuba
Renzo Davoli
Jonathan Davies
Pavel Mironchik
Peter Milne
Justin Piszcz
Ganapathi CH
Daniel Alomar
Angelo Marconi
Nickolay
Irwan Djajadi
Lothar Englisch
Bart Massey
Michael Rash
Tyler
Jae-hyeon Park
Michael De Backer
Jan "Yenya" Kasprzak
bjdouma
Ernis
Kenneth Crudup
Ralph Siemsen
Frank de Lange
Paul Drynoff
bibo, mao
Lars Jacob
Leubner, Achim
Joerg Ahrens
Przemek Iskra
Peter Ujfalusi
Mark.Zhan
Aukasz Stelmach
D. Peter Siddons
Frode Isaksen
Lv Liangying
Zac Bowling
William Morrrow
George C. Wilson
Raimonds Cicans
Dan Bastone
Saqeb Akhter
Juergen Mell
Ira Weiny
David Wang
Thomas Andrews
Nick Fedchik
Ville Herva
Havasi Ferenc
Remi Denis-Courmont
Christophe Mariac
Aubrey Lee
Linda Knippers
Dmitry Bazhenov
Porpoise
Timothy Sipples
Zang Roy
Rachita Kothiyal
Raymond Burns
Ramachandra K
Daniel R Thompson
Unicorn Chang
Tim Kaiser
Paul Serice
Shailabh Nagar
Orjan Friberg
Shuya MAEDA
Bryan Scott
Nick Martin
Eduard Warkentin
James E Wilson
Joseph Jezak
Constantine Sapuntzakis
Ralf Schlatterbeck
Roberto Castagnola
Marko Macek
Sylvain Pasche
Michal Feix
David Kuehling
Peter Moulder
Matthew Meno
Jani Alinikula
Luca De Cicco
Davide Perini
bert hubert
Philipe De Muyter
Markus Schoder
Yuri Gushin
Fredrik Roubert
Per Dalaon
Chris Lund
Bill Huey
lamikr
Yoav Steinberg
Hiro Yoshioka
Marc Sowen
Michal Ruzicka
Philippe Retornaz
Bin Zhou
Handle X
Pedro Alejandro Lalpez-Valencia
Ralf Hildebrandt
Russ Ross
Willson Callan
Christian Praehauser
Christopher Neufeld
Tushar Gohad
Fredrik Tolf
Thomas Glanzmann
140 in version 18 never seen again

==== Scanning 2.6.19
Manasi Deval
Soos Peter
Jan Luebbe
Dave McCracken
Al Stone
Doug Ledford
George Hansper
Tilman Sauerbeck
Shaun Jackman
Werner Lemberg
Alistair Buxton
Padraig Brady
Joachim Fritschi
Prasanna S.P
dave wysochanski
Troy Heber
Om Narasimhan
Dan Cyr
keios
Mark Assad
Guillaume Munch
Auke-Jan H Kok
Bas Bloemsaat
Simon Tatham
Luke Zhang
Jules Villard
Kaustav Majumdar
Vladimir Avdonin
Thiago Galesi
Sergei Haller
Dave Liu
Bryn Reeves
jens m. noedler
Eran Tromer
Bjorn Schneider
Dmitriy Zavin
Bradley Kite
Mathieu Avila
Lars Gjesse Kjellberg
Noguchi, Masato
Dwayne Grant Mcconnell
Allan Third
Denis M. Sadykov
Raghavendra Biligiri
Brian Walsh
Kenzo Iwami
Yvan Seth
Christian Merkle
Reiner Herrmann
Sam Vilain
Eric Thomas
Jim Lewis
Francisco Larramendi
Diego Beltrami
Erich Chen
Eric Eric Sesterhenn
Dennis Stosberg
Metathronius Galabant
Alexandre Ratchov
Jan Mate
HyeonSeung Jang
Steven Haigh
Nicholas Nunley
Lijun Chen
Ian S. Nelson
David Weinehall
Patrick Jefferson
Eugeny S. Mints
Francesco Fondelli
Marek W
Peter Naulls
Jan-Frode Myklebust
Ira W. Snyder
Marcus Junker
Toshinobu Sugioka
Unai Uribarri
Andrey Liakhovets
keith mannthey
David Bussenschutt
Eric Biederman
Dan Fandrich
Fernando Vazquez
David M. Grimes
Michael Grundy
Alex Sanks
Magnus Sandin
Luke Ross
Sam Hocevar
Fernando J. Pereda
Johannes Steingraeber
Frank Sievertsen
Igor M. Liplianin
Dominic Cerquetti
Adam Henley
Sharyathi Nagesh
Amy Fong
Craig Hughes
Richard Sandiford
Thomas Chou
Joel & Rebecca VanderZee
Richard Fish
Robert S Peterson
Roger Gammans
Rick Koch
Karl-Johan Karlsson
jamal
Justin Carlson
Cory Olmo
Andy Gay
Lebedev, Vladimir P
Jochen Issing
Richard Curnow
Alexander Tuschen
Christian Steineck
Jian Gui
Klaus Frahm
Stphane Witzmann
Shem Multinymous
Mark Howell
Adam Radford
Manuel Francisco Naranjo
Cjacker Huang
Jamie Painter
Adam Tlalka
Kjell Myksvoll
Michal Majchrowicz
Sujoy Gupta
Paul Bonser
Eiichiro Oiwa
Wesley PA4WDH
Ph. Marek
Dave Arlie
Bryce Harrington
Ray Lehtiniemi
Skip Hansen
135 in version 19 never seen again

==== Scanning 2.6.20
Andy Ryan
Manuel Osdoba
Chris Caputo
David Erb
Miguel Angel Alvarez
George Sapountzis
Eagle Jones
Jeet Chaudhuri
Stefan Traby
Davy Chan
Matthijs van Otterdijk
Daniel
stanley cai
Ang Way Chuang
Takamasa Ohtake
Eric Smith
Mikhail Fedotov
James Bursa
Michael Riepe
Martin Williges
Thomas Genty
Nagendra Singh Tomar
Hiroshi Miura
Michael Broughton
Craig Schlenter
Li Yewang
Jose Carlos Garcia Sogo
Derek Fults
Luca Pedrielli
Wojtek Kaniewski
Jeff Chua
Ethan Hsiao
Raz Ben-Jehuda(caro)
Phillip Lougher
Luke Deller
Ricard Wanderlof
Holden Karau
Ryan Underwood
Lars Ellenberg
Andrea A Odetti
Justin Clacherty
Adrian Friedli
Takada
Jesse Huang
Hynek Petrak
Lew Glendenning
Florian Festi
Christian Hesse
Fabrice Knevez
Torsten Ertbjerg Rasmussen
Dave Olsen
Adam Megacz
Frederic Riss
BP, Praveen
Erik Jacobson
Tomi Koivulahti
Rik Bobbaers
Chen, Justin
Artiom Myaskouvskey
Aaron Salter
Rutger Nijlunsing
Guillem Jover
Vijay Kumar
Marton Nemeth
Timo Lindhorst
Yoshimi Ichiyanagi
Matthew McClintock
Nicolas Bellido
Thomas Tuttle
David Clare
Ashwin Chaugule
Henning Schroeer
Henry Nestler
Chris Frey
Dwayne Grant McConnell
Shantanu Goel
Ard van Breemen
Jan Capek
Thomas Hamm
Jason Parekh
Ryan Jackson
Garrett Damore
Kristian Kielhofner
Jun Chen
Filipe Lautert
Lars Immisch
Andrew Beekhof
Christoph Haubrich
Greg Chandler
Simon Bennett
Sven Anders & Marcus Junker
Josef "Jeff" Sipek
Mark Glaisher
Timofei V. Bondarenko
Martin Willi
95 in version 20 never seen again

==== Scanning 2.6.21
Robert Marquardt
Tomasz Kvarsin
Jean-Paul Saman
Taku Izumi
Nigel Williams
Clement Guedez
Rainer Weikusat
Chris Rankin
Mikhail Kouzmich
Valery Podrezov
Jakub Schmidtke
s situert
Joerg Dorchain
Ole Andre Vadla Ravnas
Ozzy
Marcel Siegert
Thomas Bachler
Jeff Morrow
Sanjoy Mahajan
Micke Prag
Carl Love
Matthew C Campbell
Fiodor Suietov
Vassili Karpov
Shinta Sugimoto
Thomas Schleusener
Manfred Gruber
Benjamin Li
Pantelis Koukousoulas
TAKADA Yoshihito
eric wollesen
Brian Pomerantz
Ken Witherow
Jakub W. Jozwicki J
Bruce Fields
Zheng XiaoJun
Kevin Jamieson
Mariusz Domanski
Giuliano Procida
Sergei Organov
Joerg Sommer
Shane Shrybman
Andrea Guzzo
Heiko Baums
Aji Srinivas
Karsten Weiss
Bill Helfinstine
Ruben Vandeginste
Kai Engert
Carl Lundqvist
Matthew Percival
Benjamin Romer
Max Dmitrichenko
Joseph S. Myers
Roland Kletzing
Adhiraj Joshi
Vincent Penne
Zilvinas Valinskas
Corentin Labbe
Rolf Stefan Wilke
Toshimune Konno
Thomas Hoehn
Tommi Kyntola
Antti Seppala
peter fuerst
Luciano Rocha
Hubert Kahlert
Hans-Peter Nilsson
Rui Zhang
Andre Spahlinger
Marcel van Nies
Mike Chan
Frithiof Jensen
Timo Savola
Shlomi Fish
Simon Vallet
Jack Lee
Andrew Johnson
Chris Lesiak
Ken L Johnson
Eric D. Mudama
Martin Stoilov
Andreas Block
Chuck Meade
Martin Schiller
Julius Volz
Evgeny Kravtsunov
Andrew Nayenko
Mikael Nilsson
John Daiker
Michael Leun
Andrew L. Neporada
Simon Depiets
Gard Spreemann
Andrew Donofrio
Vijay Sampath
Jon Dowland
Thomas De Schampheleire
Jan Yenya Kasprzak
Johannes Schlumberger
Antti Palosaari
Richard Fearn
Bjoern Fay
Richard Woodruff
Jin-Bong lee
Thomas Bittermann
Dan Wolstenholme
Lalit Chandivade
Akiyama, Nobuyuki
Peter Eriksen
Alan Tyson
Michael Olberg
Teru KAMOGASHIRA
Raol Sainchez Siles
Michal Wrobel
Jerome Demange
Maciej Zenczykowski
Anthony Godshall
Randy Cushman
Wu, Gilbert
Emil Larsson
Thomas Viehweger
Jamie Clark
Ishimatsu Yasuaki
Juan Pablo Sormani
Paul Rolland
Dylan Taft
Kristian Hogsberg
Valery A. Podrezov
Jan Nijs
Philipp Reisner
Hennerich, Michael
Alexandre Bounine
Phil Blundell
Gerhard Dirschl
Jon K Hellan
136 in version 21 never seen again

==== Scanning 2.6.22
matze
Pat Erley
Danny Budik
Sylvain FORET
Sergey Kiselev
Kevin Welton
Morten Banzon
John Utz
Len Sorensen
Egmont Koblinger
Marko Vrh
Stephen Cameron
Dragos Carp
Sandeep Sanjay Patil
Peter Stokes
vignesh
Marton Nameth
Domenico Andreoli
Leon Leong
Tom Alsberg
Matthew Davidson
Stephen M. Cameron
Witold Filipczyk
Ronny Peine
Uwe Kleine-Kanig
Ratnadeep Joshi
Sami Farin
Jon Paul Maloy
Luis Carlos
Ed Vipas
Thierry Merle
Andre Renaud
Jrgen Schindele
Guido Scholz
Peter P. Waskiewicz Jr.
Patrick McHarrdy
Avuton Olrich
Srinivas Aji
Alex Villacis Lasso
Ludwig Nussel
Alexandra N. Kossovsky
Julian Stecklina
James Puthukattukaran
Christian Rothlaender
Matej Kenda
Servaas Vandenberghe
Alexander Gattin
William Cohen
Aeschbacher, Fabrice
Dave Gilbert
Yehuda Sadeh Weinraub
Christophe Cattelain
Stefan Lucke
Nicu Ioan Petru
Karl Pickett
Alberto Bertogli
Rask Ingemann Lambertsen
Davide Brini
Ronni Nielsen
Kouta Ooizumi
Fabrice Aeschbacher
Stephen Mollett
Eric Rannaud
Scott Wiersdorf
Torsten Kaiser
Hans Engelen
Tian Kevin
Vignesh Babu BM
Simon Richter
Ruslan V. Sushko
Bernhard Kauer
Orczykowski, Juergen
Loic Prylli
Florian Attenberger
Pierre Willenbrock
Charles Pillar
James Carter
Takao Shinohara
Lasse Collin
Abhijit Bhopatkar
Joshua Wise
Dwaine P. Garden
Damian Minkov
Daniel P. Engel
Kenichi Nagai
Holger Magnussen
johan henriksson
Dennis Ranke
James T Klaas
Michael Milner
Corey Mutter
Syed Khasim
John Johansen
Sam Liddicott
Brian Braunstein
Janusz Krzysztofik
Jeffrey Layton
Markus Dahms
Robin H\. Johnson
Hendrik Borghorst
Edward Goggin
Mark Huth
Knobloch, Thomas
Julian Cable
takada
Daniel Wolstenholme
John Feeney
Joshua N. Pritikin
kalash nainwal
Marco Costalba
Jean-Christian de Rivaz
Ragner Magalhaes
Luis Carlos Cobo Rus
Yosef Etigin
James Yang
Mike Accetta
Peter Kovar
Thomas Reitmayr
Paul Zaremba
Eberhard Fahle
Lee Trager
Chris Clayton
Brandon Craig Rhodes
Yaozu Dong
Hans-Juergen Koch
Christian Volkmann
Surya Prabhakar
Marc Butler
Neil \"Superna\" ARMSTRONG
Morrison, Tom
Douglas Landgraf
Joey Goncalves
Holger Smolinski
Shan Lu
Michael Reiss
Jay Lubomirski
wendy xiong
Zach Carter
Utako Kusaka
Roman Moravcik
Myron Stowe
Klaus Kudielka
Richard Lary
Marvin Raaijmakers
MOKUNO Masakazu
Emil Georgiev
Michael Loehr
Noel Kothe
Shashi Rao
Thomas Knobloch
Marco Roeland
Shahrom Sharif
Carlos E. Ugarte
153 in version 22 never seen again

==== Scanning 2.6.23
Oliver McFadden
Tomas Janousek
Marisuz Kozlowski
Nicola Fagnani
Lucas Nussbaum
P·draig Brady
Songmao Tian
Wyatt Banks
Neil Muller
Ranganathan Desikan
Adit Ranadive
Joan Eslinger
Eric
Wade Berrier
Joshua Hoblitt
Rafael Bilski
Rainer Birkenmaier
Timo Jantunen
Maxim Uvarov
James Le Cuirot
Lucy McCoy
Steve G
Benjamin Gilbert
Mijo Safradin
S√∏ren Hauberg
Kapil Juneja
Dustin Marquess
Patrice Vilchez
tao.ma@oracle.com
young dave
Tim Harvey
henry su
Leandro Dorileo
Alexander Shmelev
Daniel Exner
Clifford Wolf
James Jarvis
Pierre Castella
david m. richter
Andrew Burgess
Kirill Kuvaldin
Niels de Vos
Anderson Briglia
Thomas Dahlmann
Usha Ketineni
Karl Olsen
Stepan Moskovchenko
Edward Hsu
Maarten Bressers
Roger So
Eric Wollesen
George Shapovalov
Dajie Tan
Ville Tervo
Kent Yoder
Jonathan Phenix
Changli Gao
Ranko Zivojnovic
Kazunori Asayama
Herbert van den Bergh
izumi
Michal Marek
Balazs Scheidler
Eduard-Gabriel Munteanu
Erik Johansson
Bruce Ashfield
Elvis Pranskevichus
Brijesh Singh
Toshiyuki Okajima
Milinevsky Dmitry
Vladimir Shebordaev
Thibault Le Meur
jing xiang
samson yeung
C. Scott Ananian
Mike Crash
Yasuaki Ishimatsu
Charlie Shepherd
frederic RODO
Luis Lloret
Kawai, Hidehiro
Nick Bowler
Nathael Pajani
Alessio Igor Bogani
Vovan888@gmail
Romain Goyet
Giuseppe Sacco
IKEDA, Munehiro
Quinn Jensen
TripleX
Ritesh Raj Sarraf
Mark Grondona
Tear
Ting Yang
Douglas Thompson
Klaus Weidner
Rui Sousa
Samuel
Raghava Kondapalli
Reiner Sailer
Thomas Viehmann
geoffrey.levand@am.sony.com
Ryo Dairiki
Jonathan Lim
Kalpak Shah
Suresh Jayaraman
Attila Kinali
Stuart_Hayes@Dell.com
Christian Schmidt
Mike Miller (OS Dev
Imre Kaloz
t.sefzick
Jesper Bengtsson
aherrman@arcor.de
Massimiliano Ghilardi
Milko Krachounov
Thomas Hommel
Fuxin Zhang
David Warman
Ethan Solomita
Serge Belyshev
Jeff Norden
gw.kernel@tnode.com
corentin.labbe
Ricardo Barberis
Meelap Shah
Jaroslav Kysela perex@suse.cz
Nitin Gupta
Ryan Power
Mike Cruse
Rene van Paassen
Nelson, Shannon
Martin Szulecki
Christian Kandeler
Mark Vytlacil
Diogo Kastrup
Dmitry Butskoy
Vinit Agnihotri
nickcheng(È"≠ÂÆ^Ë¨(tm)
Joakim Koskela
Danny ter Haar
Minchan Kim
Wolfgang Walter
Stephan Wolf
M4rkusXXL
Andreas Arens
Tony Wan
Jorge Juan Chico
Nicolas George
Juan Lang
Terry Loftin
Christian Heim
John Donoghue
Veena Parat
su henry
Andrey Arapov
Murillo Fernandes Bernardes
Edgar Pisani
Kees Lemmens
Jan Frey
Matt Colyer
Ilpo J√f¬§rvinen
Julien Eyries
sebastian@breakpoint.cc
jacmet@sunsite.dk
Jean-Christophe DUBOIS
Ivan N. Zlatev
Matthew Gregan
Jan L√ºbbe
Carlos Olalla Martinez
Carlo Beccaria
Vikram Pandita
Eddy L O Jansson
YOSHIFUJI Hideaki / Âê?Ë-§Ë<±Ê~Z
Nate
Eric W. Biderman
Sven-Thorsten Dietrich
Priyanka Gupta
Micah Cowan
179 in version 23 never seen again

==== Scanning 2.6.24
Martti Huttunen
Charles Hardin
Juha Laiho
ben.nizette@iinet.net.au
Dave Wysochanski
Mike Crowe
Pedro
Chris David
Bjˆrn Steinbrink
Yann Dirson
Steve Cameron
Thomas Backlund
Andrew McNabb
Jonas Danielsson
Sam Jansen
Alfred E. Heggestad
Veljkovic Srdjan
tonyj@suse.de
Michael J. Evans
Pekka Seppanen
Peter Lund
Dr. David Alan Gilbert
Matt Doran
de Dinechin, Christophe (Integrity VM)
Khelben Blackstaff
Aaron Carroll
Elias Oltmanns
Gregory CLEMENT
Mark Hills
Alon Ziv
Hans J Koch
Mark Nelson
Ilya Frolov
Christian Hohnstaedt
Ed Swarthout
Richard Sharpe
Pekka Sepp√§nen
Mark Ryden
Alex Villac√≠s Lasso
vbarshak@ru.mvista.com
Bryn M. Reeves
Martin Kusserow
Kevin Pedretti
Joe Carnuccio
jidong xiao
saeed bishara
Joshua J Bowman
Daniel Roesen
Philipp Marek
Micah Parrish
sebdeg@ngi.it
chaohong guo
Dirk Hohndel
Danny Baumann
Tobias Poschwatta
Andrew Dyer
Sheela
Ryousei Takano
Edouard Lafargue
Nico Erfurth
John Muir
Yann Chachkoff
J√∂rn Engel
Dave Dillow
John Traill
Alex Unleashed
Ryan Reading
Adam Jackson
Adel Gadllah
Wolfgang Denk
Nathanael Nerode
Hye-Shik Chang
sonic zhang
minchan kim
Ilya Yanok
Anton Ekblad
Yang, Sheng
Akos Maroy
Hinko Kocevar
Saleem Abdulrasool
Matej Laitl
Chris Paulson-Ellis
William Pettersson
Mirko Lindner
Bryan Kadzban
Tony Li
Philippe Elie
Barry Kasindorf
Matthias Mueller
Francis Moreau
Ludovico Cavedon
ashish kalra
Jonathan Bastien-Filiatrault
Mike Westerhof
Denys
Alex
Keita Maehara
warmcat
Wagner Ferenc
David Smith
Tomoya Adachi
Milan Plzik
Benoit Istin
Keiichi Kii
Aoi Shinkai
Adrian Knoth
Radu Rendec
Brett Warden
Li, Xin B
Damian Jurd
Anton Salikhmetov
Ivo Manca
Andrew Gallatin
agilmore@wirelessbeehive.com
Andrew M. Bishop
barrios
FD Cami
Jerrold Jones
Iustin Pop
Gilles Gigan
Jan Rinze
Signed-off-by@vergenet.net":Simon
James Pearson
George Kibardin
Anton Arapov
trem
\"Talpey, Thomas\
zhejiang
bugme-daemon@bugzilla.kernel.org
Jesper Dangaard Brouer
Rini van Zetten
Matias Zabaljauregui
Lepton Wu
Subbaiah Venkata
Matteo Vit
Kevin R Page
Tom "spot" Callaway
Jeff Bailey
Sellout Bessie
Joachim Steiger
Kazuhiko Kawakami
Jeff Long
Edgar Simo
Surya Prabhakar N
Murali Iyer
Massimo Cirillo
Steven A. Falco
David Daney
Xianghua Xiao
Kuan Luo
Stefan Lippers-Hollmann
Andreas Loibl
Jonas Stare
Philippe R√©tornaz
Michael Brunner
Ilpo J‰rvinen
Andy Lowe
Cyril Gorcunov
Matthias M. Dellweg
Heiko Schocher
Dawid Wrobel
Benedikt Spranger
Michael Mauch
Stuart Swales
Marek Va≈°ut
Mike Miller (OS Dev)
Matthias Goebl
Eugene Konev
Olaf Hartmann
Scott James Remnant
Aleksandar Radovanovic
Chris Poon
Tao Mao
Frank A Kingswood
James Bowes
Vladimir Davydov
Udo A. Steinberg
Carmelo Amoroso
Chaogui Zhang
179 in version 24 never seen again

==== Scanning 2.6.25
Syed Mohammed, Khasim
Ross Burton
Ed Beroset
Brett T. Warden
Assaf Hoffman
Patrick Marchand Latifi
Chidambar 'ilLogict' Zinnoury
K.Tanaka
Hirokazu Takahashi
nickcheng
Min Zhang
Jonathan Lynch
mboton@gmail.com
Prasad P
Rizzo Davide
travis@sgi.com
Jim Paris
Carlo Marcelo Arenas Belon
Joel Soete
Troy Kisky
Veli-Matti Valtonen
Robie Basak
Paul Jimenez
Signed-off by Yi Yang
goda.yusuke
Kim Sandberg
Shan Wei
√?ric Piel
clameter@sgi.com
Milan plzik
Franco Lanza
Kevin Lo
Carlos R. Mafra
Jiang Zhe
Maciej Sosnowski
Marin Mitov
sergeh@us.ibm.com
Thomas Horsten
Robert Bragg
Thomas Mingarelli
Bryan Boatright
Nicholas Beck
Tan Swee Heng
Clark Rawlins
Christian Pellegrin
Paul Knowles
Riki Oktarianto
Nikanth Karthikesan
Jack Stone
yakui.zhao@intel.com
Michel Lespinasse
Sebastian Ott
Miguel Boton
Sergio Luis
Kieran Bingham
Ned Forrester
Michael E Brown
Bastien Nocera
Jessica L. Blank
Jan Evert van Grootheest
Drew Fisher
Remy Bohmer
David P. Quigley
Dave Miller
I√±aky P√©rez-Gonz√°lez
Dan Muntz
tang kai
Steve Welch
Patrick Caulfeld
Johnson Leung
Andrew Burton
Bruno Redondi
Adrian Pardini
Daniel Hokka Zakrisson
Tom Talpey
Kim B. Heino
Silvester Erdeg
Thadeu Lima de Souza Cascardo
Timofei Bondarenko
Mike Snitzer
Gadiyar, Anand
Alexey Zaytsev
Dmitri Monakhov
Christian Glindkamp
Keld Simonsen
Trevor Highland
Andreas Herrmann3
Roy Hashimoto
Markus Metzger
serue@us.ibm.com
Christine Caulfield
Ming Lin
Liam R. Howlett
Lei Ming
Eduardo Habkost
Dmitry Shapin
Rainer Jochem
Keiichi KII
Gaston, Jason D
Anand Gadiyar
Yuri Funduryan
Martin Strubel
Thomas Sujith
Itaru Kitayama
Arjan van dev Ven
Bryan Rosenburg
Marcin ≈slusarz
Zhang Xiantao
frederic Rodo
Jean Noel Cordenner
janboe
Bradley Smith
joe@perches.com
Michel Ludwig
len.brown@intel.com
Martin Stava
Marc Boucher
Alex Deucher
Laszlo Attila Toth
Nate Carlson
Greg KH
Daniel Koz√°k
Klaus Heinrich Kiwi
Vladimir Berezniker
T. H. Huth
Sven Andersen
Dmitry Antipov
Hans Rosenfeld
Krauth.Julien
Pravin M. Bathija
Alex Bounine
Nathaniel Filardo
Pavel Troller
Adrian Bassett
Paul Chavent
Andrew Patterson
Warren Turkal
Stephan Diestelhorst
Alejandro Riveira Fern√°ndez
Nicolas Mailhot
Valdis.Kletnieks@vt.edu
SDiZ
Zhang Yanmin
Lu√≠s P Mendes
Jan Slupski
Sven Wegener
Jean-Samuel Chenard
Aegis Lin
Michal Sojka
John Reiser
Ulisses Furquim
Laszlo Kajan
Vasily Khoruzhick
Peter Stark
Yang Shi
Jay Schulist
Zhang Le
Jaroslav Barton
Corentin CHARY
TripleX Chung
Michael Abd-El-Malek
Dan Kenigsberg
Tomohiro Kusumi
Stefan Bauer
Bob Wilson
Anatolij Gustschin
fangxiaozhi
Tim Ansell
Nick Warne
Andrew Smith
root
Thomas Betker
Tim Taubert
Mikko Herranen
Gregory Greenman
Aidan Williams
Piotr Roszatycki
Andrey J. Melnikoff (TEMHOTA)
John Lacombe
Surjit Reang
Rabin Vincent
Akira Tsukamoto
Hermann Lauer
Maarten Lankhorst
Lai Jiangshan
bjorn.helgaas@hp.com
Andrew Murray
Brian Wood
Sten Wang
Eamon Walsh
Maciej Cencora
Kevin Vance
Justin Treon
Soeren Moch
Sheng Yongjie (Sam
Yutaro Ebihara
devzero@web.de
Wolfgang Ocker
Priit Laes
Laim Girdwood
Maciej Soltysiak
Bill Hayes
Eduardo Pereira Habkost
Oliver Schuster
Marcus Barrow
Misha Zhilin
Daniel Wagner
EGRY Gabor
Mart Raudsepp
Hideo Aoki
Andre Noll
Mirko
Bruce Duncan
Ren√© B√ºrgel
Neil Turton
David Acker
Bron Gondwana
Stephan Boettcher
Abhishek Sagar
Anton Salnikov
Manish Katiyar
Emil Tantilov
Damien Stuart
Jody Belka
Steve Hardy
Pradeep Satyanarayana
Miguel Bot√≥n
Fred L. Templin
Arve Hj√∏nnev√•g
Brad Sawatzky
Uwe Kleine-Koenig
Walter T Gruczka
Girish Shilamkar
Yuri Tikhonov
Constantin Baranov
dominik
Bjorn Mork
Carol Hebert
Girish
Giel de Nijs
Shin-ya Okada
Karol Swietlicki
Markus Gaugusch
Thomas Pfaff
Alain Degreffe
Jesse Ahrens
Konstantin Kletschke
Ivo Couckuyt
Marc Gauthier
Dave Anderson
Richard MUSIL
Ronen Shitrit
Ke Wei
Alexey Demin
Rick Farrington
Yousef Lamlum
Petr Cvek
Coleman Kane
arvidjaar@mail.ru
Albert Graham
Dmitry Krivoschekov
Enrik Berkhan
Robert Spitzenpfeil
Josef Jeff Sipek
Alexandre Rusev
npiggin@suse.de
Michael Loeffler
Vitaliy Gusev
Gerald Stralko
Alex Riesen
Marc Dionne
Zhang, Xiantao
Anantha Subramanyam
David Scidmore
Mirko Bordignon
David Ludlow
Mike Day
Stuart Bennett
Peter Teoh
Ian Schram
Fabio Checconi
Lon Hohberger
Libor Pechacek
Dominique Quatravaux
Chaoyu Chen
Eric Dujardin
Leonid Evdokimov
Quentin Barnes
Max Arnold
Serge A. Suchkov
Dirk DeSchepper
Roland Stoll
Minoru Usui
Douglas Kosovic
Andreas Degert
Crane Cai
Heinz-Ado Arnolds
Ihar Hrachyshka
Ctirad Fertr
Stephen Ware
R√©mi Denis-Courmont
David Newall
David Cohen
Rafael Ignacio Zurita
304 in version 25 never seen again
