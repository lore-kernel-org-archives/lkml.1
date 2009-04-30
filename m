Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbZD3IwH (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 30 Apr 2009 04:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZD3Ivw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:51:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:55816 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751329AbZD3Ivt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:51:49 -0400
X-Authenticated: #8143315
X-Provags-ID: V01U2FsdGVkX19QLYAYHm1QuSRw3t8qJw8VYWmNp2aC691vo4uxVE
	CnDnGuUqYhwWN8
Content-Type: text/plain; charset=utf-8
To: linux-kernel@vger.kernel.org
Date: Thu, 30 Apr 2009 10:51:47 +0200
Subject: PROBLEM: 2.6.29.2 - AGP doesn't work anymore on my nforce2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
FROM: Karsten Mehrhoff <kawime@gmx.de>
Message-ID: <op.us6ywl2jgp7xae@127.0.0.1>
User-Agent: Opera Mail/10.00 (Linux)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.]
PROBLEM: No more agp card functionality with the patch 2.6.29.2 of 'a/drivers/char/agp/generic.c'

[2.]
I compiled the kernel 2.6.29.2 with my .config of 2.6.29.1 and run into problems with the speed of my ATI RADEON 9600 (rv350)



The following output was generated with my reverted patch of 'a/drivers/char/agp/generic.c':

[4.]
# cat /proc/version
Linux version 2.6.29.2-kmt-1 (root@DEBLIN) (gcc version 4.3.3 (Debian 4.3.3-8) ) #4 Thu Apr 30 02:19:59 CEST 2009

---

[7.1.]
# ./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux DEBLIN 2.6.29.2-kmt-1 #4 Thu Apr 30 02:19:59 CEST 2009 i686 GNU/Linux
 
Gnu C                  4.3.3
Gnu make               3.81
binutils               2.19.51.20090419
util-linux             2.14-rc2
mount                  support
module-init-tools      3.7-pre9
e2fsprogs              1.41.5
jfsutils               1.1.12
xfsprogs               2.10.2
Linux C Library        2.9
Dynamic linker (ldd)   2.9
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               7.2
Modules Loaded         binfmt_misc ppdev lp microcode nls_utf8 nls_cp437 vfat fat fuse w83l785ts asb100 hwmon_vid loop snd_wavefront snd_cs4232 snd_wss_lib snd_opl3_lib snd_seq_dummy snd_hwdep snd_intel8x0 snd_ac97_codec snd_seq_oss snd_mpu401 snd_mpu401_uart ac97_bus snd_pcm_oss snd_mixer_oss snd_seq_midi snd_seq_midi_event snd_rawmidi snd_pcm snd_seq snd_seq_device shpchp pci_hotplug pcspkr usblp psmouse snd_timer snd_page_alloc forcedeth snd ns558 evdev serio_raw gameport soundcore parport_pc parport button ide_cd_mod cdrom ide_gd_mod thermal processor fan thermal_sys ata_generic libata scsi_mod ide_pci_generic amd74xx

---

[7.2.]
# cat /proc/cpuinfo
processor		: 0
vendor_id		: AuthenticAMD
cpu family	     : 6
model			: 8
model name    : AMD Athlon(tm) XP 2600+
stepping	: 1
cpu MHz		: 2138.367
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow
bogomips	: 4276.73
clflush size	: 32
power management: ts

---

[7.3.]
# cat /proc/modules
binfmt_misc 6604 1 - Live 0xf868d000
ppdev 6048 0 - Live 0xf8a0a000
lp 7604 0 - Live 0xf88bf000
microcode 6532 0 - Live 0xf8897000
nls_utf8 1416 8 - Live 0xf887a000
nls_cp437 5244 8 - Live 0xf8830000
vfat 8716 8 - Live 0xf87e0000
fat 40888 1 vfat, Live 0xf8864000
fuse 45820 1 - Live 0xf881f000
w83l785ts 4840 0 - Live 0xf87d6000
asb100 14080 0 - Live 0xf87b1000
hwmon_vid 2284 1 asb100, Live 0xf879d000
loop 12472 0 - Live 0xf876e000
snd_wavefront 47024 0 - Live 0xf8781000
snd_cs4232 11428 0 - Live 0xf86de000
snd_wss_lib 21512 2 snd_wavefront,snd_cs4232, Live 0xf86eb000
snd_opl3_lib 8604 2 snd_wavefront,snd_cs4232, Live 0xf8688000
snd_seq_dummy 2304 0 - Live 0xf8072000
snd_hwdep 5908 2 snd_wavefront,snd_opl3_lib, Live 0xf803d000
snd_intel8x0 25272 5 - Live 0xf88ef000
snd_ac97_codec 90796 1 snd_intel8x0, Live 0xf88c7000
snd_seq_oss 23628 0 - Live 0xf889f000
snd_mpu401 5840 0 - Live 0xf8870000
snd_mpu401_uart 5640 3 snd_wavefront,snd_cs4232,snd_mpu401, Live 0xf8817000
ac97_bus 1388 1 snd_ac97_codec, Live 0xf8806000
snd_pcm_oss 32132 0 - Live 0xf87f8000
snd_mixer_oss 11936 2 snd_pcm_oss, Live 0xf87ec000
snd_seq_midi 5380 0 - Live 0xf87c2000
snd_seq_midi_event 5868 2 snd_seq_oss,snd_seq_midi, Live 0xf87b6000
snd_rawmidi 17868 3 snd_wavefront,snd_mpu401_uart,snd_seq_midi, Live 0xf8773000
snd_pcm 59580 4 snd_wss_lib,snd_intel8x0,snd_ac97_codec,snd_pcm_oss, Live 0xf8833000
snd_seq 38400 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 0xf875c000
snd_seq_device 6040 6 snd_opl3_lib,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf8736000
shpchp 26480 0 - Live 0xf8727000
pci_hotplug 24404 1 shpchp, Live 0xf86e3000
pcspkr 1912 0 - Live 0xf86d1000
usblp 9696 0 - Live 0xf86a4000
psmouse 36356 0 - Live 0xf8690000
snd_timer 16336 4 snd_wss_lib,snd_opl3_lib,snd_pcm,snd_seq, Live 0xf8077000
snd_page_alloc 7724 3 snd_wss_lib,snd_intel8x0,snd_pcm, Live 0xf8039000
forcedeth 44288 0 - Live 0xf8885000
snd 47396 25 snd_wavefront,snd_cs4232,snd_wss_lib,snd_opl3_lib,snd_hwdep,snd_intel8x0,snd_ac97_codec,snd_seq_oss,snd_mpu401,snd_mpu401_uart,snd_pcm_oss,snd_mixer_oss,snd_rawmidi,snd_pcm,snd_seq,snd_seq_device,snd_timer, Live 0xf8845000
ns558 3964 0 - Live 0xf882d000
evdev 7776 8 - Live 0xf881b000
serio_raw 4352 0 - Live 0xf880e000
gameport 9408 2 ns558, Live 0xf8801000
soundcore 5700 2 snd, Live 0xf87f4000
parport_pc 21792 1 - Live 0xf87e4000
parport 29764 3 ppdev,lp,parport_pc, Live 0xf87cc000
button 5584 0 - Live 0xf87b9000
ide_cd_mod 25180 0 - Live 0xf87a8000
cdrom 30124 1 ide_cd_mod, Live 0xf8790000
ide_gd_mod 18856 13 - Live 0xf877a000
thermal 15200 0 - Live 0xf8768000
processor 34692 1 thermal, Live 0xf8751000
fan 4056 0 - Live 0xf873d000
thermal_sys 10188 3 thermal,processor,fan, Live 0xf8731000
ata_generic 4248 0 - Live 0xf807d000
libata 147208 1 ata_generic, Live 0xf8701000
scsi_mod 129232 1 libata, Live 0xf86af000
ide_pci_generic 3336 0 - Live 0xf806b000
amd74xx 5344 11 - Live 0xf8063000

---

[7.4.]
# cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:09.0
  0170-0177 : amd74xx
01f0-01f7 : 0000:00:09.0
  01f0-01f7 : amd74xx
0201-0201 : ns558-pnp
02f8-02ff : serial
0330-0331 : MPU401 UART
0376-0376 : 0000:00:09.0
  0376-0376 : amd74xx
0378-037a : parport0
03c0-03df : vesafb
03f6-03f6 : 0000:00:09.0
  03f6-03f6 : amd74xx
03f8-03ff : serial
04d0-04d1 : pnp 00:04
0cf8-0cff : PCI conf1
4000-407f : pnp 00:00
  4000-4003 : ACPI PM1a_EVT_BLK
  4004-4005 : ACPI PM1a_CNT_BLK
  4008-400b : ACPI PM_TMR
  4020-4027 : ACPI GPE0_BLK
4080-40ff : pnp 00:00
4200-427f : pnp 00:00
4280-42ff : pnp 00:00
4400-447f : pnp 00:00
4480-44ff : pnp 00:00
  44a0-44af : ACPI GPE1_BLK
5000-503f : pnp 00:01
  5000-503f : nForce2_smbus
5500-553f : pnp 00:01
  5500-553f : nForce2_smbus
c000-cfff : PCI Bus 0000:02
  c000-c0ff : 0000:02:00.0
d000-d007 : 0000:00:04.0
  d000-d007 : forcedeth
d400-d4ff : 0000:00:06.0
  d400-d4ff : NVidia nForce2
d800-d87f : 0000:00:06.0
  d800-d87f : NVidia nForce2
e400-e41f : 0000:00:01.1
f000-f00f : 0000:00:09.0
  f000-f00f : amd74xx

---

[7.4.]
# cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ccfff : Video ROM
000d0000-000d17ff : Adapter ROM
000d1800-000d3fff : pnp 00:02
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3ffeffff : System RAM
  00100000-0032621a : Kernel code
  0032621b-0042752f : Kernel data
  0046f000-004f0c67 : Kernel bss
3fff0000-3fff2fff : ACPI Non-volatile Storage
3fff3000-3fffffff : ACPI Tables
d0000000-dfffffff : PCI Bus 0000:02
  d0000000-d7ffffff : 0000:02:00.0
    d0000000-d0ffffff : vesafb
  d8000000-dfffffff : 0000:02:00.1
e0000000-e3ffffff : 0000:00:00.0
e4000000-e5ffffff : PCI Bus 0000:02
  e4000000-e401ffff : 0000:02:00.0
  e5000000-e500ffff : 0000:02:00.0
  e5010000-e501ffff : 0000:02:00.1
e6000000-e60000ff : 0000:00:02.2
  e6000000-e60000ff : ehci_hcd
e6001000-e6001fff : 0000:00:04.0
  e6001000-e6001fff : forcedeth
e6002000-e6002fff : 0000:00:06.0
  e6002000-e6002fff : NVidia nForce2
e6004000-e6004fff : 0000:00:02.0
  e6004000-e6004fff : ohci_hcd
e6005000-e6005fff : 0000:00:02.1
  e6005000-e6005fff : ohci_hcd
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : reserved
    fec00000-fec00fff : pnp 00:02
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:02
ffff0000-ffffffff : reserved
  ffff0000-ffffffff : pnp 00:02

---

[7.5.]
# lspci -vvv
00:00.0 Host bridge: nVidia Corporation nForce2 IGP2 (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 80ac
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [40] AGP version 3.0
		Status: RQ=32 Iso- ArqSz=2 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3+ Rate=x4,x8
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x8
	Capabilities: [60] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
		Revision ID: 0.16
	Kernel driver in use: agpgart-nvidia

00:00.1 RAM memory: nVidia Corporation nForce2 Memory Controller 1 (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 80ac
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.2 RAM memory: nVidia Corporation nForce2 Memory Controller 4 (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 80ac
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.3 RAM memory: nVidia Corporation nForce2 Memory Controller 3 (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 80ac
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.4 RAM memory: nVidia Corporation nForce2 Memory Controller 2 (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 80ac
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.5 RAM memory: nVidia Corporation nForce2 Memory Controller 5 (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 80ac
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:01.0 ISA bridge: nVidia Corporation nForce2 ISA Bridge (rev a3)
	Subsystem: ASUSTeK Computer Inc. A7N8X Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [48] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=1 UnitCnt=15 MastHost- DefDir-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC+ TXO- <CRCErr=0
		Link Config 0: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
		Link Control 1: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO+ <CRCErr=0
		Link Config 1: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
		Revision ID: 0.00

00:01.1 SMBus: nVidia Corporation nForce2 SMBus (MCP) (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 0c11
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at e400 [size=32]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: nForce2_smbus

00:02.0 USB Controller: nVidia Corporation nForce2 USB Controller (rev a3) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. A7N8X Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at e6004000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd

00:02.1 USB Controller: nVidia Corporation nForce2 USB Controller (rev a3) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. A7N8X Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 20
	Region 0: Memory at e6005000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd

00:02.2 USB Controller: nVidia Corporation nForce2 USB Controller (rev a3) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. A7N8X Mainboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin C routed to IRQ 22
	Region 0: Memory at e6000000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=0080
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ehci_hcd

00:04.0 Ethernet controller: nVidia Corporation nForce2 Ethernet Controller (rev a1)
	Subsystem: ASUSTeK Computer Inc. A7N8X Mainboard onboard nForce2 Ethernet
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at e6001000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at d000 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
	Kernel driver in use: forcedeth

00:06.0 Multimedia audio controller: nVidia Corporation nForce2 AC97 Audio Controler (MCP) (rev a1)
	Subsystem: ASUSTeK Computer Inc. nForce2 AC97 Audio Controler (MCP)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at d400 [size=256]
	Region 1: I/O ports at d800 [size=128]
	Region 2: Memory at e6002000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: Intel ICH

00:08.0 PCI bridge: nVidia Corporation nForce2 External PCI Bridge (rev a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-

00:09.0 IDE interface: nVidia Corporation nForce2 IDE (rev a2) (prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. Device 0c11
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at f000 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: AMD_IDE

00:1e.0 PCI bridge: nVidia Corporation nForce2 AGP (rev a2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: e4000000-e5ffffff
	Prefetchable memory behind bridge: d0000000-dfffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

02:00.0 VGA compatible controller: ATI Technologies Inc RV350 AR [Radeon 9600] (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. A9600XT/TD
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at c000 [size=256]
	Region 2: Memory at e5000000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at e4000000 [disabled] [size=128K]
	Capabilities: [58] AGP version 3.0
		Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3+ Rate=x4,x8
		Command: RQ=32 ArqSz=2 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x8
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.1 Display controller: ATI Technologies Inc RV350 AR [Radeon 9600] (Secondary)
	Subsystem: ASUSTeK Computer Inc. A9600XT/TD (Secondary)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at d8000000 (32-bit, prefetchable) [disabled] [size=128M]
	Region 1: Memory at e5010000 (32-bit, non-prefetchable) [disabled] [size=64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-


---


Problematic patch:
//---
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1226,7 +1226,7 @@ int agp_generic_alloc_pages(struct agp_bridge_data *bridge, struct agp_memory *m
         int i, ret = -ENOMEM;
 
         for (i = 0; i < num_pages; i++) {
-                page = alloc_page(GFP_KERNEL | GFP_DMA32);
+                page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
                 /* agp_free_memory() needs gart address */
                 if (page == NULL)
                         goto out;
@@ -1257,7 +1257,7 @@ void *agp_generic_alloc_page(struct agp_bridge_data *bridge)
 {
         struct page * page;
 
-        page = alloc_page(GFP_KERNEL | GFP_DMA32);
+        page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
         if (page == NULL)
                 return NULL;
---//

I reverted the patch back to 2.6.29.1, compiled and the kernel agian and agp works ok.



Please cc mailto:kawime@gmx.de on the answers/comments posted to the list in response to this posting.


Thanks 

Karsten Mehrhoff
