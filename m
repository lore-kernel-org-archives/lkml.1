Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbXEXUuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbXEXUuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbXEXUuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:50:12 -0400
Received: from mx.laposte.net ([81.255.54.16]:17562 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbXEXUuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:50:10 -0400
Date: Thu, 24 May 2007 22:50:04 +0200
Message-Id: <JIKCJG$9CB259B32F4FFD5A69DD821D2C467660@laposte.net>
Subject: Re: [INPUT] i8042 not detecting AUX port
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: multipart/mixed; boundary="_=__=_XaM3_.1180039804.2A.495870.42.29665.52.42.007.29999"
From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
To: "dtor" <dtor@insightbb.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
X-XaM3-API-Version: 4.1 (B103)
X-SenderIP: 127.0.0.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--_=__=_XaM3_.1180039804.2A.495870.42.29665.52.42.007.29999
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

> On Wednesday 23 May 2007 16:41, Emmanuel Fust=E9 wrote:
> > Hi,
> > > Hi,
> > > 
> > > On Tuesday 22 May 2007 18:23, Emmanuel Fust=E9 wrote:
> > > > Hello,
> > > > 
> > > > Just to let you know that since I jumped from 2.6.16 to
> > > > 2.6.20.7 and 2.6.21, I need the i8042.noloop option to
get the
> > > > AUX port detected.
> > > > Without this option, the kernel silently omit the AUX
port,
> > > > only the KBD port is detected.
> > > > 
> > > > If Dmitry is interested by a debug log, I will recompile a
> > > > kernel with i8042.debug support.
> > > 
> > > You do not need to recompile anymore, just boot with
> > i8042.debug. 
> > > 
> > Ok loglevel=3D8 and i8042.debug do the trick.
> > 
> 
> Hmm, it looks like your box does not want to generate
interrupts for
> loop command. Oh, well... I think the best solution would be to 
> automatically set i8042_noloop on your box. Can I please get
dmidecode
> output?
> 
I attached the dmidecode output.
DMI is somewhat broken with this old BIOS.
I checked the config space of the 82371SB(PII3). It seems that
my bios did not get the XCBS register right(4Eh): IRQ12/M
Mouse  function Enable is set to 0.
This bios is full of bugs, a real plague. Will try to quirk
this register at boot time.

Best regards,
Emmanuel.
=0A=0ACr=E9ez votre adresse =E9lectronique prenom.nom@laposte.net 
1 Go d'espace de stockage, anti-spam et anti-virus int=E9gr=E9s.

--_=__=_XaM3_.1180039804.2A.495870.42.29665.52.42.007.29999
Content-Type: text/plain;
	name="=?iso-8859-1?Q?dmidecode.txt?="
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="=?iso-8859-1?Q?dmidecode.txt?="

# dmidecode 2.9=0ALegacy DMI 2.0 present.=0A36 structures occupying 1123 =
bytes.=0ATable at 0x000F556A.=0A=0AHandle 0x0000, DMI type 0, 18 bytes=0A=
BIOS Information=0A	Vendor: Award Software, Inc.=0A	Version: #401A0-0201 =
                        =0A	Release Date: 08/04/97=0A	Address: 0xF0000=0A=
	Runtime Size: 64 kB=0A	ROM Size: 128 kB=0A	Characteristics:=0A		ISA is s=
upported=0A		PCI is supported=0A		PNP is supported=0A		APM is supported=0A=
		BIOS is upgradeable=0A		BIOS shadowing is allowed=0A		ESCD support is a=
vailable=0A		Boot from CD is supported=0A		Selectable boot is supported=0A=
		BIOS ROM is socketed=0A		EDD is supported=0A		Japanese floppy for NEC 9=
800 1.2 MB is supported (int 13h)=0A		5.25"/360 KB floppy services are su=
pported (int 13h)=0A		5.25"/1.2 MB floppy services are supported (int 13h=
)=0A		3.5"/720 KB floppy services are supported (int 13h)=0A		3.5"/2.88 M=
B floppy services are supported (int 13h)=0A		Print screen service is sup=
ported (int 5h)=0A		8042 keyboard services are supported (int 9h)=0A		Ser=
ial services are supported (int 14h)=0A		Printer services are supported (=
int 17h)=0A		CGA/mono video services are supported (int 10h)=0A=0AHandle =
0x0001, DMI type 1, 8 bytes=0ASystem Information=0A	Manufacturer: System =
Manufacturer=0A	Product Name: System Name=0A	Version: System Version=0A	S=
erial Number: SYS-1234567890=0A=0AHandle 0x0002, DMI type 2, 8 bytes=0ABa=
se Board Information=0A	Manufacturer: ASUSTeK Computer INC.=0A	Product Na=
me: P/I-P65UP5=0A	Version: REV 2.X=0A	Serial Number: MB-1234567890=0A=0AH=
andle 0x0003, DMI type 3, 9 bytes=0AChassis Information=0A	Manufacturer: =
Chassis Manufacture=0A	Type: Unknown=0A	Lock: Not Present=0A	Version: Cha=
ssis Version=0A	Serial Number: Chassis Serial Number=0A	Asset Tag: Asset-=
1234567890=0A=0AHandle 0x0004, DMI type 4, 26 bytes=0AProcessor Informati=
on=0A	Socket Designation: SOCKET 7=0A	Type: Central Processor=0A	Family: =
Pentium=0A	Manufacturer: Intel Corporation=0A	ID: 43 05 00 00 BF 03 80 00=
=0A	Signature: Type 0, Family 5, Model 4, Stepping 3=0A	Flags:=0A		FPU (F=
loating-point unit on-chip)=0A		VME (Virtual mode extension)=0A		DE (Debu=
gging extension)=0A		PSE (Page size extension)=0A		TSC (Time stamp counte=
r)=0A		MSR (Model specific registers)=0A		MCE (Machine check exception)=0A=
		CX8 (CMPXCHG8 instruction supported)=0A		APIC (On-chip APIC hardware su=
pported)=0A		MMX (MMX technology supported)=0A	Version: Intel Pentium Pro=
cessor=0A	Voltage: 3.3 V=0A	External Clock: 66 MHz=0A	Max Speed: 200 MHz=0A=
	Current Speed: 233 MHz=0A	Status: Populated, Enabled=0A	Upgrade: ZIF Soc=
ket=0A=0AHandle 0x0005, DMI type 5, 31 bytes=0AMemory Controller Informat=
ion=0A	Error Detecting Method: None=0A	Error Correcting Capabilities:=0A	=
	None=0A	Supported Interleave: One-way Interleave=0A	Current Interleave: =
One-way Interleave=0A	Maximum Memory Module Size: 64 MB=0A	Maximum Total =
Memory Size: 512 MB=0A	Supported Speeds:=0A		70 ns=0A		60 ns=0A		50 ns=0A=
	Supported Memory Types:=0A		FPM=0A		EDO=0A		Parity=0A		SIMM=0A	Memory Mo=
dule Voltage: 5.0 V=0A	Associated Memory Slots: 8=0A		0x0006=0A		0x0007=0A=
		0x0008=0A		0x0009=0A		0x000A=0A		0x000B=0A		0x000C=0A		0x000D=0A=0AHand=
le 0x0007, DMI type 6, 12 bytes=0AMemory Module Information=0A	Socket Des=
ignation: SIMM1&2-2=0A	Bank Connections: 0 1=0A	Current Speed: Unknown=0A=
	Type: FPM SIMM=0A	Installed Size: Not Installed=0A	Enabled Size: Not Ins=
talled=0A	Error Status: OK=0A=0AHandle 0x0008, DMI type 6, 12 bytes=0AMem=
ory Module Information=0A	Socket Designation: SIMM3&4-1=0A	Bank Connectio=
ns: 2 3=0A	Current Speed: Unknown=0A	Type: EDO SIMM=0A	Installed Size: 12=
8 MB (Single-bank Connection)=0A	Enabled Size: 128 MB (Single-bank Connec=
tion)=0A	Error Status: OK=0A=0AHandle 0x0009, DMI type 6, 12 bytes=0AMemo=
ry Module Information=0A	Socket Designation: SIMM3&4-2=0A	Bank Connection=
s: 2 3=0A	Current Speed: Unknown=0A	Type: FPM SIMM=0A	Installed Size: Not=
 Installed=0A	Enabled Size: Not Installed=0A	Error Status: OK=0A=0AHandle=
 0x000A, DMI type 6, 12 bytes=0AMemory Module Information=0A	Socket Desig=
nation: SIMM5&6-1=0A	Bank Connections: 4 5=0A	Current Speed: Unknown=0A	T=
ype: EDO SIMM=0A	Installed Size: 128 MB (Single-bank Connection)=0A	Enabl=
ed Size: 128 MB (Single-bank Connection)=0A	Error Status: OK=0A=0AHandle =
0x000B, DMI type 6, 12 bytes=0AMemory Module Information=0A	Socket Design=
ation: SIMM5&6-2=0A	Bank Connections: 4 5=0A	Current Speed: Unknown=0A	Ty=
pe: FPM SIMM=0A	Installed Size: Not Installed=0A	Enabled Size: Not Instal=
led=0A	Error Status: OK=0A=0AHandle 0x000C, DMI type 6, 12 bytes=0AMemory=
 Module Information=0A	Socket Designation: SIMM7&8-1=0A	Bank Connections:=
 6 7=0A	Current Speed: Unknown=0A	Type: EDO SIMM=0A	Installed Size: 128 M=
B (Single-bank Connection)=0A	Enabled Size: 128 MB (Single-bank Connectio=
n)=0A	Error Status: OK=0A=0AHandle 0x000D, DMI type 6, 12 bytes=0AMemory =
Module Information=0A	Socket Designation: SIMM7&8-2=0A	Bank Connections: =
6 7=0A	Current Speed: Unknown=0A	Type: FPM SIMM=0A	Installed Size: Not In=
stalled=0A	Enabled Size: Not Installed=0A	Error Status: OK=0A=0AHandle 0x=
000E, DMI type 7, 15 bytes=0ACache Information=0A	Socket Designation: L1 =
Cache=0A	Configuration: Enabled, Not Socketed, Level 1=0A	Operational Mod=
e: Write Back=0A	Location: Internal=0A	Installed Size: 32 KB=0A	Maximum S=
ize: 32 KB=0A	Supported SRAM Types: None=0A	Installed SRAM Type: None=0A=0A=
Handle 0x000F, DMI type 7, 15 bytes=0ACache Information=0A	Socket Designa=
tion: L2 Cache=0A	Configuration: Enabled, Not Socketed, Level 2=0A	Operat=
ional Mode: Write Back=0A	Location: External=0A	Installed Size: 512 KB=0A=
	Maximum Size: 512 KB=0A	Supported SRAM Types:=0A		Pipeline Burst=0A	Inst=
alled SRAM Type: Pipeline Burst=0A=0AHandle 0x0010, DMI type 8, 9 bytes=0A=
Port Connector Information=0A	Internal Reference Designator: COM1=0A	Inte=
rnal Connector Type: 9 Pin Dual Inline (pin 10 cut)=0A	External Reference=
 Designator: COM A=0A	External Connector Type: DB-9 male=0A	Port Type: Se=
rial Port 16550A Compatible=0A=0AHandle 0x0011, DMI type 8, 9 bytes=0APor=
t Connector Information=0A	Internal Reference Designator: COM2=0A	Interna=
l Connector Type: 9 Pin Dual Inline (pin 10 cut)=0A	External Reference De=
signator: COM B=0A	External Connector Type: DB-25 male=0A	Port Type: Seri=
al Port 16550A Compatible=0A=0AHandle 0x0012, DMI type 8, 9 bytes=0APort =
Connector Information=0A	Internal Reference Designator: PRINTER=0A	Intern=
al Connector Type: 25 Pin Dual Inline (pin 26 cut)=0A	External Reference =
Designator: LPT=0A	External Connector Type: DB-25 female=0A	Port Type: Pa=
rallel Port ECP/EPP=0A=0AHandle 0x0013, DMI type 8, 9 bytes=0APort Connec=
tor Information=0A	Internal Reference Designator: KEY=0A	Internal Connect=
or Type: None=0A	External Reference Designator: KEYBOARD=0A	External Conn=
ector Type: Micro DIN=0A	Port Type: Keyboard Port=0A=0AHandle 0x0014, DMI=
 type 8, 9 bytes=0APort Connector Information=0A	Internal Reference Desig=
nator: PS2MOUSE=0A	Internal Connector Type: Proprietary=0A	External Refer=
ence Designator: PS/2 Mouse=0A	External Connector Type: Micro DIN=0A	Port=
 Type: Mouse Port=0A=0AHandle 0x0015, DMI type 8, 9 bytes=0APort Connecto=
r Information=0A	Internal Reference Designator: PRIMARY IDE=0A	Internal C=
onnector Type: On Board IDE=0A	External Reference Designator: IDE-1=0A	Ex=
ternal Connector Type: None=0A	Port Type: None=0A=0AHandle 0x0016, DMI ty=
pe 8, 9 bytes=0APort Connector Information=0A	Internal Reference Designat=
or: SECONDARY IDE=0A	Internal Connector Type: On Board IDE=0A	External Re=
ference Designator: IDE-2=0A	External Connector Type: None=0A	Port Type: =
None=0A=0AHandle 0x0017, DMI type 8, 9 bytes=0APort Connector Information=
=0A	Internal Reference Designator: FLOPPY=0A	Internal Connector Type: On =
Board Floppy=0A	External Reference Designator: FLOPPY=0A	External Connect=
or Type: None=0A	Port Type: None=0A=0AHandle 0x0018, DMI type 9, 12 bytes=
=0ASystem Slot Information=0A	Designation: PCI Slot1=0A	Type: 32-bit PCI=0A=
	Current Usage: In Use=0A	Length: Long=0A	ID: 12=0A	Characteristics:=0A		=
5.0 V is provided=0A=0AHandle 0x0019, DMI type 9, 12 bytes=0ASystem Slot =
Information=0A	Designation: PCI Slot2=0A	Type: 32-bit PCI=0A	Current Usag=
e: In Use=0A	Length: Short=0A	ID: 11=0A	Characteristics:=0A		5.0 V is pro=
vided=0A=0AHandle 0x001A, DMI type 9, 12 bytes=0ASystem Slot Information=0A=
	Designation: PCI Slot3=0A	Type: 32-bit PCI=0A	Current Usage: In Use=0A	L=
ength: Short=0A	ID: 10=0A	Characteristics:=0A		5.0 V is provided=0A=0AHan=
dle 0x001B, DMI type 9, 12 bytes=0ASystem Slot Information=0A	Designation=
: PCI Slot4=0A	Type: 32-bit PCI=0A	Current Usage: Available=0A	Length: Lo=
ng=0A	ID: 9=0A	Characteristics:=0A		5.0 V is provided=0A=0AHandle 0x001C,=
 DMI type 9, 12 bytes=0ASystem Slot Information=0A	Designation: PCI Slot5=
=0A	Type: 32-bit PCI=0A	Current Usage: In Use=0A	Length: Long=0A	ID: 13=0A=
	Characteristics:=0A		5.0 V is provided=0A		Opening is shared=0A=0AHandle=
 0x001D, DMI type 9, 12 bytes=0ASystem Slot Information=0A	Designation: I=
SA Slot1=0A	Type: 16-bit ISA=0A	Current Usage: Unknown=0A	Length: Long=0A=
	Characteristics:=0A		5.0 V is provided=0A		Opening is shared=0A=0AHandle=
 0x001E, DMI type 9, 12 bytes=0ASystem Slot Information=0A	Designation: I=
SA Slot2=0A	Type: 16-bit ISA=0A	Current Usage: Unknown=0A	Length: Long=0A=
	Characteristics:=0A		5.0 V is provided=0A=0AHandle 0x001F, DMI type 9, 1=
2 bytes=0ASystem Slot Information=0A	Designation: ISA Slot3=0A	Type: 16-b=
it ISA=0A	Current Usage: Unknown=0A	Length: Long=0A	Characteristics:=0A		=
5.0 V is provided=0A=0AHandle 0x0020, DMI type 11, 5 bytes=0AOEM Strings=0A=
	String 1: OEM String=0A=0AHandle 0x0021, DMI type 12, 5 bytes=0ASystem C=
onfiguration Options=0A	Option 1: System String=0A=0AHandle 0x0022, DMI t=
ype 13, 22 bytes=0ABIOS Language Information=0A	Installable Languages: 1=0A=
		ENGLISH=0A	Currently Installed Language: ENGLISH=0A=0AHandle 0x0023, DM=
I type 15, 20 bytes=0ASystem Event Log=0A	Area Length: 4096 bytes=0A	Head=
er Start Offset: 0x0000=0A	Header Length: 16 bytes=0A	Data Start Offset: =
0x0010=0A	Access Method: Memory-mapped physical 32-bit address=0A	Access =
Address: 0xFFFE8000=0A	Status: Invalid, Not Full=0A	Change Token: 0x00000=
000=0A=0AWrong DMI structures count: 36 announced, only 35 decoded.=0AWro=
ng DMI structures length: 1123 bytes announced, structures occupy 1122 by=
tes.=0A

--_=__=_XaM3_.1180039804.2A.495870.42.29665.52.42.007.29999--

