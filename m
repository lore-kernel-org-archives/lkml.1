Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXA1XDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXA1XDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932960AbXA1XDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:03:55 -0500
Received: from smtp19.orange.fr ([80.12.242.17]:11218 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957AbXA1XDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:03:54 -0500
X-ME-UUID: 20070128230351513.7D6AA1C0009D@mwinf1911.orange.fr
From: Julien RF <julien.rf@no-log.org>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Crash on device_shutdown
Date: Mon, 29 Jan 2007 00:03:49 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701290003.50918.julien.rf@no-log.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One line summary of the problem:
Crash on device_shutdown


Full description of the problem/report:
When I shut down the system, I get a crash on the device_shutdown function 
(called by kernel_shutdown_prepare).
Since the bug happens when the system is almost shutted down, I can't get the 
log...
I partially copied it by hand, ask me if you need further details :
Will now halt.
BUG: unable to handle kernel NULL pointer dereference at virtual adress 
00000128
...
EIP is at device_shutdown + 0x49/0x6c
...
Process halt
...
/etc/rc0.d/S90halt: line 21: 11198 Segmentation fault halt -d -f $shutdown 
$poweroff $hddown

Julien Richard-Foy


Keywords (i.e., modules, networking, kernel):
base, power


Kernel version (from /proc/version):
Linux version 2.6.19.2 (root@sasume) (gcc version 4.1.2 20061115 (prerelease) 
(Debian 4.1.1-21)) #1 SMP Sun Jan 28 18:49:29 CET 2007


Software :
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux sasume 2.6.19.2 #1 SMP Sun Jan 28 18:49:29 CET 2007 i686 GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
reiserfsprogs          3.6.19
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   103
Modules Loaded         n_hdlc ppdev lp ipv6 ntfs nls_iso8859_1 nls_cp437 vfat 
fat dm_snapshot dm_mirror dm_mod apm ide_generic tsdev mousedev snd_ens1370 
gameport floppy snd_rawmidi snd_seq_device snd_pcm_oss snd_mixer_oss rtc 
8250_pnp pcilynx psmouse serio_raw i2c_viapro snd_pcm snd_timer 
snd_ak4531_codec pcspkr snd soundcore snd_page_alloc via686a shpchp 
pci_hotplug ieee1394 i2c_algo_bit i2c_isa i2c_core parport_pc parport via_agp 
agpgart evdev reiserfs ide_cd cdrom ide_disk generic 3c59x mii via82cxxx 
ide_core uhci_hcd usbcore processor


Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 6
model name      : AMD Athlon(tm) XP 1800+
stepping        : 2
cpu MHz         : 1461.000
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow up ts
bogomips        : 2924.64


Module information (from /proc/modules):
n_hdlc 9476 0 - Live 0xd0f3b000
ppdev 9092 0 - Live 0xd0f02000
lp 11364 0 - Live 0xd0efe000
ipv6 227872 19 - Live 0xd0f7f000
ntfs 203220 1 - Live 0xd0f08000
nls_iso8859_1 4544 3 - Live 0xd0dfa000
nls_cp437 6208 2 - Live 0xd0d94000
vfat 12608 2 - Live 0xd0eaf000
fat 49052 1 vfat, Live 0xd0ebf000
dm_snapshot 16996 0 - Live 0xd0df4000
dm_mirror 20624 0 - Live 0xd0ded000
dm_mod 52568 2 dm_snapshot,dm_mirror, Live 0xd0dfe000
apm 20640 1 - Live 0xd0de6000
ide_generic 1728 0 [permanent], Live 0xd0d17000
tsdev 7872 0 - Live 0xd0d8a000
mousedev 11236 1 - Live 0xd0d34000
snd_ens1370 19296 0 - Live 0xd0d67000
gameport 15048 1 snd_ens1370, Live 0xd0d6d000
floppy 54564 0 - Live 0xd0d99000
snd_rawmidi 23136 1 snd_ens1370, Live 0xd0d7f000
snd_seq_device 8076 1 snd_rawmidi, Live 0xd0d38000
snd_pcm_oss 39520 0 - Live 0xd0d74000
snd_mixer_oss 15872 1 snd_pcm_oss, Live 0xd0d62000
rtc 12788 0 - Live 0xd0d5d000
8250_pnp 9600 0 - Live 0xd0d59000
pcilynx 18824 0 - Live 0xd0cda000
psmouse 35144 0 - Live 0xd0d3c000
serio_raw 7044 0 - Live 0xd0d14000
i2c_viapro 8724 0 - Live 0xd0d10000
snd_pcm 71940 2 snd_ens1370,snd_pcm_oss, Live 0xd0d46000
snd_timer 21124 1 snd_pcm, Live 0xd0d29000
snd_ak4531_codec 9088 1 snd_ens1370, Live 0xd0d0c000
pcspkr 3456 0 - Live 0xd0837000
snd 48932 8 
snd_ens1370,snd_rawmidi,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer,snd_ak4531_codec, 
Live 0xd0d1c000
soundcore 8032 1 snd, Live 0xd0d09000
snd_page_alloc 10056 2 snd_ens1370,snd_pcm, Live 0xd0d05000
via686a 15432 0 - Live 0xd0d00000
shpchp 35040 0 - Live 0xd0ccd000
pci_hotplug 30080 1 shpchp, Live 0xd0cf7000
ieee1394 88568 1 pcilynx, Live 0xd0ce0000
i2c_algo_bit 8072 1 pcilynx, Live 0xd0bcc000
i2c_isa 5696 1 via686a, Live 0xd0bc9000
i2c_core 21056 5 pcilynx,i2c_viapro,via686a,i2c_algo_bit,i2c_isa, Live 
0xd0bb5000
parport_pc 33124 1 - Live 0xd0cbb000
parport 34056 3 ppdev,lp,parport_pc, Live 0xd0cb1000
via_agp 10048 1 - Live 0xd0bb1000
agpgart 30600 1 via_agp, Live 0xd0bbc000
evdev 9728 0 - Live 0xd0bad000
reiserfs 219904 2 - Live 0xd0bd4000
ide_cd 37088 0 - Live 0xd0b81000
cdrom 33760 1 ide_cd, Live 0xd0b8c000
ide_disk 15872 8 - Live 0xd0830000
generic 5828 0 [permanent], Live 0xd0814000
3c59x 41576 0 - Live 0xd0839000
mii 5760 1 3c59x, Live 0xd0827000
via82cxxx 8964 0 [permanent], Live 0xd0810000
ide_core 101256 5 ide_generic,ide_cd,ide_disk,generic,via82cxxx, Live 
0xd0866000
uhci_hcd 22024 0 - Live 0xd0820000
usbcore 124100 2 uhci_hcd, Live 0xd0846000
processor 30728 0 - Live 0xd0817000


Loaded driver and hardware information (/proc/ioports, /proc/iomem) :
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
02f8-02ff : serial
0376-0376 : ide1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vesafb
03f2-03f5 : floppy
03f6-03f6 : ide0
03f7-03f7 : floppy DIR
03f8-03ff : serial
0cf8-0cff : PCI conf1
5000-500f : 0000:00:07.4
  5000-5007 : vt596_smbus
6000-607f : 0000:00:07.4
  6000-607f : via686a
d000-d00f : 0000:00:07.1
  d000-d007 : ide0
  d008-d00f : ide1
d400-d41f : 0000:00:07.2
  d400-d41f : uhci_hcd
d800-d81f : 0000:00:07.3
  d800-d81f : uhci_hcd
e000-e03f : 0000:00:09.0
  e000-e03f : Ensoniq AudioPCI
e400-e43f : 0000:00:0c.0


00000000-0009fbff : System RAM
  00000000-00000000 : Crash kernel
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cc7ff : Video ROM
000f0000-000fffff : System ROM
00100000-0ffeffff : System RAM
  00100000-0029573c : Kernel code
  0029573d-00327c33 : Kernel data
0fff0000-0fff2fff : ACPI Non-volatile Storage
0fff3000-0fffffff : ACPI Tables
20000000-2000ffff : 0000:00:0a.0
20010000-2001ffff : 0000:00:0c.0
d0000000-d7ffffff : PCI Bus #01
  d0000000-d7ffffff : 0000:01:00.0
    d0000000-d3ffffff : vesafb
d8000000-dbffffff : 0000:00:00.0
dc000000-ddffffff : PCI Bus #01
  dc000000-dcffffff : 0000:01:00.0
  dd000000-dd00ffff : 0000:01:00.0
df000000-df00ffff : 0000:00:0a.0
df010000-df01ffff : 0000:00:0a.0
df020000-df020fff : 0000:00:0a.0
ffff0000-ffffffff : reserved


PCI information ('lspci -vvv' as root) :
00:00.0 Host bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133] (rev 03)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR+
        Latency: 8
        Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [a0] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 
64bit- FW- AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- 
Rate=<none>
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133 AGP] 
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: dc000000-ddffffff
        Prefetchable memory behind bridge: d0000000-d7ffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (rev 
40)
        Subsystem: VIA Technologies, Inc. VT82C686/A PCI to ISA Bridge
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping+ SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if 8a 
[Master SecP PriP])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Region 4: I/O ports at d000 [size=16]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 1a) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin D routed to IRQ 10
        Region 4: I/O ports at d400 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 1a) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin D routed to IRQ 10
        Region 4: I/O ports at d800 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.4 Host bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 
40)
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin ? routed to IRQ 11
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:09.0 Multimedia audio controller: Ensoniq ES1370 [AudioPCI]
        Subsystem: Unknown device 4942:4c4c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort+ <MAbort+ >SERR- <PERR-
        Latency: 32 (3000ns min, 32000ns max)
        Interrupt: pin A routed to IRQ 9
        Region 0: I/O ports at e000 [size=64]

00:0a.0 FireWire (IEEE 1394): Texas Instruments PCILynx/PCILynx2 IEEE 1394 
Link Layer Controller (rev 02) (prog-if 00 [Generic])
        Subsystem: Supermac Technology Unknown device 6951
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at df020000 (32-bit, non-prefetchable) [size=4K]
        Region 1: Memory at df010000 (32-bit, non-prefetchable) [size=64K]
        Region 2: Memory at df000000 (32-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at 20000000 [disabled] [size=64K]

00:0c.0 Ethernet controller: 3Com Corporation 3c900 10BaseT [Boomerang]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (750ns min, 2000ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at e400 [size=64]
        [virtual] Expansion ROM at 20010000 [disabled] [size=64K]

01:00.0 VGA compatible controller: nVidia Corporation NV11DDR [GeForce2 MX 100 
DDR/200 DDR] (rev b2) (prog-if 00 [VGA])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (1250ns min, 250ns max)
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at d0000000 (32-bit, prefetchable) [size=128M]
        [virtual] Expansion ROM at dd000000 [disabled] [size=64K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [44] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA- ITACoh- GART64- HTrans- 
64bit- FW+ AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- 
Rate=<none>

