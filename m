Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbXDMLbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbXDMLbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 07:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXDMLbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 07:31:25 -0400
Received: from alpha.retecivica.milano.it ([212.239.120.182]:37123 "EHLO
	alpha.retecivica.milano.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541AbXDMLbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 07:31:23 -0400
X-Greylist: delayed 3628 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2007 07:31:22 EDT
Message-id: <fc.000f4a4a07756028000f4a4a07756028.7756a2e@rcm.inet.it>
Date: Fri, 13 Apr 2007 12:30:44 +0200
Subject: PROBLEM: kernel BUG at mm/rmap.c:522!
X-FC-Form-ID: 141
X-FC-SERVER-TZ: 181272840
To: linux-kernel@vger.kernel.org
From: "Francesco Ricci" <francesco.ricci@rcm.inet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

      First run the ver_linux script included as scripts/ver_linux, which
reports the version of some important subsystems.  Run this script with
the command "sh scripts/ver_linux".

-> umh... I cannot find this script

Use that information to fill in all fields of the bug report form, and
post it to the mailing list with a subject of "PROBLEM: " for easy
identification by the developers    

[1.] One line summary of the problem:    
kernel BUG at mm/rmap.c:522!

[2.] Full description of the problem/report:
alert message repeated on every terminal, Iceape (browser) crashed when
closing a tab (multitab browsing).

[3.] Keywords (i.e., modules, networking, kernel):
kernel bug

[4.] Kernel version (from /proc/version):
Linux version 2.6.18-4-686 (Debian 2.6.18.dfsg.1-12) (waldi@debian.org)
(gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Mon Mar
26 17:17:36 UTC 2007

[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)
no oops

[6.] A small shell script or example program which triggers the
     problem (if possible)
n/a

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
script not found

[7.2.] Processor information (from /proc/cpuinfo):
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 2.00GHz
stepping	: 4
cpu MHz		: 1996.778
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm up
bogomips	: 3998.39

[7.3.] Module information (from /proc/modules):
ext3 119240 1 - Live 0xf0e33000
jbd 52456 1 ext3, Live 0xf0e01000
mbcache 8356 1 ext3, Live 0xf0cea000
mga 58176 2 - Live 0xf0cce000
drm 61332 3 mga, Live 0xf0c7c000
ppdev 8676 0 - Live 0xf0c64000
lp 11012 0 - Live 0xf0c60000
button 6672 0 - Live 0xf0c5d000
ac 5188 0 - Live 0xf0c5a000
battery 9636 0 - Live 0xf0c56000
ipv6 226016 23 - Live 0xf0c95000
fuse 39828 1 - Live 0xf0b95000
dm_snapshot 15552 0 - Live 0xf0b90000
dm_mirror 19152 0 - Live 0xf0a8a000
dm_mod 50232 2 dm_snapshot,dm_mirror, Live 0xf0ba0000
loop 15048 0 - Live 0xf0aba000
snd_via82xx 26008 0 - Live 0xf0ac3000
gameport 14632 1 snd_via82xx, Live 0xf0ab5000
snd_ac97_codec 83104 1 snd_via82xx, Live 0xf0ad1000
snd_ac97_bus 2400 1 snd_ac97_codec, Live 0xf09e0000
tsdev 7520 0 - Live 0xf0ab2000
snd_pcm_oss 38368 0 - Live 0xf0a95000
snd_mixer_oss 15200 1 snd_pcm_oss, Live 0xf0a90000
snd_pcm 68676 3 snd_via82xx,snd_ac97_codec,snd_pcm_oss, Live 0xf0aa0000
snd_page_alloc 9640 2 snd_via82xx,snd_pcm, Live 0xf09e2000
snd_mpu401_uart 8064 1 snd_via82xx, Live 0xf0a5d000
snd_seq_dummy 3844 0 - Live 0xf09b9000
snd_seq_oss 28768 0 - Live 0xf0a47000
snd_seq_midi 8192 0 - Live 0xf09fb000
snd_seq_midi_event 7008 2 snd_seq_oss,snd_seq_midi, Live 0xf09ea000
i2c_viapro 8244 0 - Live 0xf09e6000
i2c_core 19680 1 i2c_viapro, Live 0xf0a41000
snd_seq 45680 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event,
Live 0xf0a50000
via_ircc 23188 0 - Live 0xf0a2b000
snd_timer 20996 2 snd_pcm,snd_seq, Live 0xf0a3a000
snd_rawmidi 22560 2 snd_mpu401_uart,snd_seq_midi, Live 0xf0a33000
snd_seq_device 7820 5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq,snd_rawmidi, Live 0xf09db000
irda 162588 1 via_ircc, Live 0xf0a61000
pcspkr 3072 0 - Live 0xf09de000
parport_pc 32132 1 - Live 0xf09bb000
parport 33256 3 ppdev,lp,parport_pc, Live 0xf0a21000
floppy 53156 0 - Live 0xf09ed000
via_agp 9664 1 - Live 0xf09b5000
psmouse 35016 0 - Live 0xf09d1000
serio_raw 6660 0 - Live 0xf0851000
snd 47012 11
snd_via82xx,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_mpu401_uart,snd_seq_oss,snd_seq,snd_timer,snd_rawmidi,snd_seq_device,
Live 0xf09c4000
soundcore 9248 1 snd, Live 0xf08e0000
rtc 12372 0 - Live 0xf08db000
crc_ccitt 2240 1 irda, Live 0xf08ba000
shpchp 33024 0 - Live 0xf09ab000
pci_hotplug 28704 1 shpchp, Live 0xf08c2000
agpgart 29896 2 drm,via_agp, Live 0xf08cc000
evdev 9088 1 - Live 0xf08be000
reiserfs 212640 2 - Live 0xf08e5000
ide_cd 36064 0 - Live 0xf0894000
cdrom 32544 1 ide_cd, Live 0xf089f000
ide_disk 14848 6 - Live 0xf084c000
generic 5476 0 [permanent], Live 0xf0840000
via_rhine 22664 0 - Live 0xf088d000
mii 5344 1 via_rhine, Live 0xf0843000
ehci_hcd 28136 0 - Live 0xf0831000
uhci_hcd 21164 0 - Live 0xf0839000
via82cxxx 8388 0 [permanent], Live 0xf081d000
ide_core 110504 4 ide_cd,ide_disk,generic,via82cxxx, Live 0xf0871000
usbcore 112644 3 ehci_hcd,uhci_hcd, Live 0xf0854000
thermal 13608 0 - Live 0xf082c000
processor 28840 1 thermal, Live 0xf0823000
fan 4804 0 - Live 0xf0805000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
cat /proc/ioports 
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide1
01f0-01f7 : ide0
0376-0376 : ide1
0378-037a : parport0
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : ide0
03f7-03f7 : floppy DIR
03f8-03ff : serial
0400-047f : 0000:00:11.0
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0420-0423 : ACPI GPE0_BLK
0500-050f : 0000:00:11.0
  0500-0507 : vt596_smbus
0778-077a : parport0
0cf8-0cff : PCI conf1
d000-d01f : 0000:00:10.0
  d000-d01f : uhci_hcd
d400-d41f : 0000:00:10.1
  d400-d41f : uhci_hcd
d800-d81f : 0000:00:10.2
  d800-d81f : uhci_hcd
dc00-dc0f : 0000:00:11.1
  dc00-dc07 : ide0
  dc08-dc0f : ide1
e000-e0ff : 0000:00:11.5
  e000-e0ff : VIA8233
e800-e8ff : 0000:00:12.0
  e800-e8ff : via-rhine

cat /proc/iomem 
00000000-0009fbff : System RAM
  00000000-00000000 : Crash kernel
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c87ff : Video ROM
000f0000-000fffff : System ROM
00100000-2ffeffff : System RAM
  00100000-0028205d : Kernel code
  0028205e-003127b3 : Kernel data
2fff0000-2fff2fff : ACPI Non-volatile Storage
2fff3000-2fffffff : ACPI Tables
d0000000-d7ffffff : 0000:00:00.0
d8000000-d9ffffff : PCI Bus #01
  d8000000-d9ffffff : 0000:01:00.0
da000000-dcffffff : PCI Bus #01
  da000000-da003fff : 0000:01:00.0
  da020000-da03ffff : 0000:01:00.0
  db000000-db7fffff : 0000:01:00.0
dd000000-dd0000ff : 0000:00:10.3
  dd000000-dd0000ff : ehci_hcd
dd001000-dd0010ff : 0000:00:12.0
  dd001000-dd0010ff : via-rhine
ffff0000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: VIA Technologies, Inc. VT8374 P4X400 Host
Controller/AGP Bridge (rev 03)
Apr 13 1Subsystem: Elitegroup Computer Systems Unknown device
0a82donly:/var/lib
/gconf/dControl: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
la lettuStatus: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
Apr 13 1Latency: 8calhost gconfd (root-3599): L'indirizzo
"xml:readonly:/var/lib
/gconf/dRegion 0: Memory at d0000000 (32-bit, prefetchable)
[size=128M]sola lett
ura in pCapabilities: [a0] AGP version 2.0
Apr 13 11:47:24 Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
 arresto	Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x1
Apr 13 1Capabilities: [c0] Power Management version 2
Apr 13 11:50:19 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
Apr 13 12:04:27 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
Apr 13 12:09:01 localhost /USR/SBIN/CRON[5202]: (root) CMD (  [ -d
/var/lib/php5
00:01.0 PCI bridge: VIA Technologies, Inc. VT8235 PCI Bridge (prog-if 00
[Normal decode])
xargs -rControl: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
torre:/hStatus: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR+
torre:/hLatency: 0ess /var/log/kern.log
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: da000000-dcffffff
	Prefetchable memory behind bridge: d8000000-d9ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: Elitegroup Computer Systems Unknown device 0a82
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 4: I/O ports at d000 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: Elitegroup Computer Systems Unknown device 0a82
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 3
	Region 4: I/O ports at d400 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: Elitegroup Computer Systems Unknown device 0a82
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 10
	Region 4: I/O ports at d800 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82) (prog-if
20 [EHCI])
	Subsystem: Elitegroup Computer Systems Unknown device 0a82
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 32, Cache Line Size: 128 bytes
	Interrupt: pin D routed to IRQ 5
	Region 0: Memory at dd000000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
	Subsystem: Elitegroup Computer Systems Unknown device 0a82
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping+ SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if
8a [Master SecP PriP])	Subsystem: Elitegroup Computer Systems Unknown
device 0a82
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 32
	Interrupt: pin A routed to IRQ 11
	Region 4: I/O ports at dc00 [size=16]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 50)
	Subsystem: Elitegroup Computer Systems Unknown device 0a82
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Interrupt: pin C routed to IRQ 10
	Region 0: I/O ports at e000 [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev
74)
	Subsystem: VIA Technologies, Inc. VT6102 [Rhine II] Embeded Ethernet
Controller on VT8235
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 32 (750ns min, 2000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at e800 [size=256]
	Region 1: Memory at dd001000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G400/G450
(rev 82) (prog-if 00 [VGA])
	Subsystem: Matrox Graphics, Inc. Millennium G450 32Mb SDRAM Dual Head
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=32M]
	Region 1: Memory at da000000 (32-bit, non-prefetchable) [size=16K]
	Region 2: Memory at db000000 (32-bit, non-prefetchable) [size=8M]
	[virtual] Expansion ROM at da020000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW-
AGP3- Rate=x1,x2,x4
		Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x1

[7.6.] SCSI information (from /proc/scsi/scsi)
no scsi

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

from dmesg:
Apr 13 11:31:35 localhost kernel: Bad pte = 461b43d4, process = ???,
vm_flags = 75, vaddr = b7868000
Apr 13 11:31:35 localhost kernel:  [<c014b0ea>] vm_normal_page+0x3e/0x53
Apr 13 11:31:35 localhost kernel:  [<c014b6fa>] unmap_vmas+0x183/0x4af
Apr 13 11:31:35 localhost kernel:  [<c014de31>] exit_mmap+0x6a/0xd7
Apr 13 11:31:35 localhost kernel:  [<c011b217>] mmput+0x20/0x76
Apr 13 11:31:35 localhost kernel:  [<c011fa05>] do_exit+0x193/0x71b
Apr 13 11:31:35 localhost kernel:  [<c0120003>] sys_exit_group+0x0/0xd
Apr 13 11:31:35 localhost kernel:  [<c0127a6d>]
get_signal_to_deliver+0x395/0x3bc
Apr 13 11:31:35 localhost kernel:  [<c01023a6>] do_notify_resume+0x71/0x5d7
Apr 13 11:31:35 localhost kernel:  [<c0117778>]
default_wake_function+0x0/0xc
Apr 13 11:31:35 localhost kernel:  [<c0124657>] do_gettimeofday+0x31/0xce
Apr 13 11:31:35 localhost kernel:  [<c0131ffc>] sys_futex+0xdc/0xf1
Apr 13 11:31:35 localhost kernel:  [<c0102d0a>] work_notifysig+0x13/0x19
Apr 13 11:31:35 localhost kernel: ------------[ cut here ]------------
Apr 13 11:31:35 localhost kernel: kernel BUG at mm/rmap.c:522!
Apr 13 11:31:35 localhost kernel: invalid opcode: 0000 [#1]
Apr 13 11:31:35 localhost kernel: SMP 
Apr 13 11:31:35 localhost kernel: Modules linked in: smbfs ext3 jbd
mbcache mga drm ppdev lp button ac battery ipv6 fuse dm_snapshot dm_mirror
dm_mod loop tsdev snd_via82xx gameport snd_ac97_codec snd_ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_mpu401_uart
snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq
i2c_viapro i2c_core snd_timer snd_rawmidi snd_seq_device via_agp
parport_pc parport via_ircc psmouse serio_raw floppy snd soundcore pcspkr
rtc agpgart shpchp pci_hotplug irda crc_ccitt evdev reiserfs ide_cd cdrom
ide_disk generic via_rhine mii ehci_hcd uhci_hcd via82cxxx ide_core
usbcore thermal processor fan
Apr 13 11:31:35 localhost kernel: CPU:    0
Apr 13 11:31:35 localhost kernel: EIP:    0060:[<c01506c9>]    Not tainted
VLI
Apr 13 11:31:35 localhost kernel: EFLAGS: 00210286   (2.6.18-4-686 #1) 
Apr 13 11:31:35 localhost kernel: EIP is at page_remove_rmap+0x14/0x2d
Apr 13 11:31:35 localhost kernel: eax: ffffffff   ebx: c1000000   ecx:
c1000000   edx: 00000000
Apr 13 11:31:35 localhost kernel: esi: b7869000   edi: 00000000   ebp:
d08011a4   esp: c9be9e14
Apr 13 11:31:35 localhost kernel: ds: 007b   es: 007b   ss: 0068
Apr 13 11:31:35 localhost kernel: Process iceape-bin (pid: 20500,
ti=c9be8000 task=c2128aa0 task.ti=c9be8000)
Apr 13 11:31:35 localhost kernel: Stack: c014b7d5 00000000 df10d278
c9be9e7c 00000000 00000001 b7884000 c4bc7b78 
Apr 13 11:31:35 localhost kernel:        e80fbe40 c16058a0 00000000
ffffffe2 c121002c c4bc7b78 0011ed07 b7884000 
Apr 13 11:31:35 localhost kernel:        00000000 c9be9e7c df4c7710
e80fbe40 c9be9eb8 c014de31 ffffffff c9be9e78 
Apr 13 11:31:35 localhost kernel: Call Trace:
Apr 13 11:31:35 localhost kernel:  [<c014b7d5>] unmap_vmas+0x25e/0x4af
Apr 13 11:31:35 localhost kernel:  [<c014de31>] exit_mmap+0x6a/0xd7
Apr 13 11:31:35 localhost kernel:  [<c011b217>] mmput+0x20/0x76
Apr 13 11:31:35 localhost kernel:  [<c011fa05>] do_exit+0x193/0x71b
Apr 13 11:31:35 localhost kernel:  [<c0120003>] sys_exit_group+0x0/0xd
Apr 13 11:31:35 localhost kernel:  [<c0127a6d>]
get_signal_to_deliver+0x395/0x3bc
Apr 13 11:31:35 localhost kernel:  [<c01023a6>] do_notify_resume+0x71/0x5d7
Apr 13 11:31:35 localhost kernel:  [<c0117778>]
default_wake_function+0x0/0xc
Apr 13 11:31:35 localhost kernel:  [<c0124657>] do_gettimeofday+0x31/0xce
Apr 13 11:31:35 localhost kernel:  [<c0131ffc>] sys_futex+0xdc/0xf1
Apr 13 11:31:35 localhost kernel:  [<c0102d0a>] work_notifysig+0x13/0x19
Apr 13 11:31:35 localhost kernel: Code: ff ff 85 c0 89 c6 75 c9 b0 01 86
43 28 83 c4 20 89 e8 5b 5e 5f 5d c3 89 c1 90 83 40 08 ff 0f 98 c0 84 c0 74
1e 8b 41 08 40 79 08 <0f> 0b 0a 02 40 ab 29 c0 8b 51 10 89 c8 83 f2 01 83
e2 01 e9 97 
Apr 13 11:31:35 localhost kernel: EIP: [<c01506c9>]
page_remove_rmap+0x14/0x2d SS:ESP 0068:c9be9e14
Apr 13 11:31:35 localhost kernel:  <1>Fixing recursive fault but reboot is
needed!




