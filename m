Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbZHGTzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbZHGTzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933261AbZHGTzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:55:05 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4338 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226AbZHGTzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:55:00 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 15:54:59 EDT
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Fri, 07 Aug 2009 21:45:20 +0200
To: linux-kernel@vger.kernel.org
From: Frank de Jong <frapex@xs4all.nl>
Subject: PROBLEM: crash / hang with linux-2.6.30.x on PII-350 SMP system
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Message-Id: <20090807194541.0F0D11D27F20@mx.drokz.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Bug report follows.

[1.] One line summary of the problem:
Crash / hang with linux-2.6.30.x on PII SMP system (PREEMPT)

[2.] Full description of the problem/report:
Crash / hang with linux-2.6.30.x on PII SMP system (PREEMPT).
First occured in linux-2.6.30-rc1 (probably, rc1(?) & rc2 do OOPS on SMP)
Still exists in linux-2.6.30.2, linux-2.6.30.3, linux-2.6.30.4.

TRIED:
- linux-2.6.29.6 (result: STABLE)

- linux-2.6.30   (result: CRASH)
- linux-2.6.30.3 (result: CRASH)
- linux-2.6.30.4 (result: CRASH)
- linux-2.6.30.4, PREEMPT disabled (result: CRASH)
- removed "-fno-delete-null-pointer-checks" from Makefile (result: CRASH)
- kernel optimized for processor family:
   * Pentium-II/Celeron(pre-Coppermine) (result: CRASH)
   * Pentium-Pro (result: CRASH)
   * Pentium-MMX (result: CRASH)
   * Pentium-Classic (result: CRASH)
   * 486 (result: CRASH)
   * 386 (result: CRASH)

- linux-2.6.30-rc7 (result: CRASH)
- linux-2.6.30-rc6 (result: CRASH)
- linux-2.6.30-rc5 (result: CRASH)
- linux-2.6.30-rc4 (result: CRASH)
- linux-2.6.30-rc3 (result: CRASH)
- linux-2.6.30-rc2 (result: OOPS@BOOT)
- linux-2.6.30-rc1 (result: OOPS@BOOT(?))

SYMPTOMS:
- Console output freezes, cursor stops blinking, no errors, nothing;
- Can occur at any moment (1 minute - 4 hours);
- Completely random crash / hang;
- Putting the machine to work gets it to crash / hang sooner.

The crashing box:
- Dual PII-350-894MB (SMP kernel, optimized for processor family: 
Pentium-II/Celeron(pre-Coppermine)

Other boxes:
- Pentium 100-128MB (kernel optimized for processor family: Pentium-Classic)
- AMD 2400XP+-1GB (kernel optimized for processor family: Athlon/Duron/K7)

The systems above (other boxes) do not seem to have any problems. 
Please note that all boxes run the same distribution and use the same 
libraries / gcc / binutils.
It only occurs on the system described running a linux-2.6.30.x SMP kernel.

As I have no idea why this bug is happening, I suppose it will be 
hard to solve.
The Changelog from linux-2.6.29.6 -> linux-2.6.30-rc1 is very big, I 
have no idea where to begin.
Anyone?


[3.] Keywords (i.e., modules, networking, kernel):
linux-2.6.30, SMP


[4.] Kernel information
Linux helium 2.6.30.4 #1 SMP PREEMPT Sat Aug 1 13:38:28 CEST 2009 
i686 pentium2 i386 GNU/Linux


[5.] Most recent kernel version which did not have the bug:
linux-2.6.29.6


[6.] Output of Oops.. message (if applicable) with symbolic 
information resolved (see Documentation/oops-tracing.txt)
N/A


[7.] A small shell script or example program which triggers the 
problem (if possible)
N/A


[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)
Linux helium 2.6.30.4 #1 SMP PREEMPT Fri Jul 31 19:36:55 CEST 2009 
i686 pentium2 i386 GNU/Linux

Gnu C                  4.3.3
Gnu make               3.81
binutils               2.19
util-linux             2.14.1
mount                  support
module-init-tools      3.5
e2fsprogs              1.41.4
xfsprogs               3.0.0
PPP                    2.4.4
Linux C Library        2.8
Dynamic linker (ldd)   2.8
Linux C++ Library      6.0.10
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.15
Sh-utils               6.12
Modules Loaded         w83781d hwmon_vid hwmon tun ne 8390p bonding 
ext2 mbcache snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device 
snd_hwdep pwc videodev v4l1_compat 3c59x mii intel_agp agpgart nfsd 
lockd auth_rpcgss sunrpc snd_pcm_oss snd_pcm snd_timer snd_page_alloc 
snd_mixer_oss snd soundcore lp parport_pc parport floppy xfs exportfs 
raid1 md_mod sg sd_mod usb_storage uhci_hcd ohci_hcd ide_gd_mod 
aic7xxx scsi_transport_spi ehci_hcd pdc202xx_new ide_pci_generic 
scsi_mod usbcore ide_core


[8.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 5
model name      : Pentium II (Deschutes)
stepping        : 1
cpu MHz         : 350.811
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr 
pge mca cmov pse36 mmx fxsr
bogomips        : 701.62
clflush size    : 32
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 5
model name      : Pentium II (Deschutes)
stepping        : 2
cpu MHz         : 350.811
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr 
pge mca cmov pse36 mmx fxsr
bogomips        : 701.66
clflush size    : 32
power management:


[8.3.] Module information (from /proc/modules):
w83781d 24760 0 - Live 0xfb699000
hwmon_vid 2348 1 w83781d, Live 0xfb578000
hwmon 2252 1 w83781d, Live 0xfb525000
tun 11072 2 - Live 0xfb509000
ne 5824 0 - Live 0xfb201000
8390p 8684 1 ne, Live 0xfb223000
bonding 75832 0 - Live 0xfb684000
ext2 47824 1 - Live 0xfb2c6000
mbcache 6952 1 ext2, Live 0xfb17b000
snd_usb_audio 71696 0 - Live 0xfb1da000
snd_usb_lib 13384 1 snd_usb_audio, Live 0xfb170000
snd_rawmidi 18444 1 snd_usb_lib, Live 0xfb162000
snd_seq_device 6120 1 snd_rawmidi, Live 0xf90ca000
snd_hwdep 6044 1 snd_usb_audio, Live 0xf90c3000
pwc 74296 0 - Live 0xfb14d000
videodev 31824 1 pwc, Live 0xf90b1000
v4l1_compat 11216 1 videodev, Live 0xf8045000
3c59x 35364 0 - Live 0xf8031000
mii 4624 1 3c59x, Live 0xf8002000
intel_agp 22868 1 - Live 0xfb700000
agpgart 30500 1 intel_agp, Live 0xfb6e7000
nfsd 200928 9 - Live 0xfb6a3000
lockd 57456 1 nfsd, Live 0xfb657000
auth_rpcgss 32320 1 nfsd, Live 0xfb634000
sunrpc 163576 8 nfsd,lockd,auth_rpcgss, Live 0xfb5fb000
snd_pcm_oss 31936 0 - Live 0xfb5bb000
snd_pcm 60892 2 snd_usb_audio,snd_pcm_oss, Live 0xfb59a000
snd_timer 17320 1 snd_pcm, Live 0xfb57a000
snd_page_alloc 7768 1 snd_pcm, Live 0xfb56a000
snd_mixer_oss 12168 1 snd_pcm_oss, Live 0xfb55c000
snd 44432 8 
snd_usb_audio,snd_rawmidi,snd_seq_device,snd_hwdep,snd_pcm_oss,snd_pcm,snd_timer,snd_mixer_oss, 
Live 0xfb545000
soundcore 6296 1 snd, Live 0xfb52d000
lp 7848 0 - Live 0xfb521000
parport_pc 28312 1 - Live 0xfb50f000
parport 30928 2 lp,parport_pc, Live 0xfb4f5000
floppy 45000 0 - Live 0xfb4d8000
xfs 414160 5 - Live 0xfb2fc000
exportfs 3692 2 nfsd,xfs, Live 0xfb27e000
raid1 17508 2 - Live 0xfb270000
md_mod 72840 3 raid1, Live 0xfb250000
sg 22016 0 - Live 0xfb227000
sd_mod 20968 10 - Live 0xfb211000
usb_storage 47868 1 - Live 0xfb1f3000
uhci_hcd 18828 0 - Live 0xfb1d3000
ohci_hcd 19492 0 - Live 0xfb1c0000
ide_gd_mod 19652 4 - Live 0xfb1aa000
aic7xxx 103952 5 - Live 0xfb17e000
scsi_transport_spi 19048 1 aic7xxx, Live 0xf90f9000
ehci_hcd 28864 0 - Live 0xf90ec000
pdc202xx_new 4900 2 - Live 0xf8049000
ide_pci_generic 3592 0 - Live 0xf803e000
scsi_mod 121440 5 sg,sd_mod,usb_storage,aic7xxx,scsi_transport_spi, 
Live 0xfb12d000
usbcore 117148 8 
snd_usb_audio,snd_usb_lib,pwc,usb_storage,uhci_hcd,ohci_hcd,ehci_hcd, 
Live 0xf90cd000
ide_core 80928 3 ide_gd_mod,pdc202xx_new,ide_pci_generic, Live 0xf801b000


[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:07.1
01f0-01f7 : 0000:00:07.1
0208-020f : pnp 00:0b
0213-0213 : ISAPnP
0220-023f : ne
0290-0297 : w83781d
   0295-0296 : w83781d
02f8-02ff : serial
0376-0376 : 0000:00:07.1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:07.1
03f7-03f7 : floppy
03f8-03ff : serial
0778-077a : parport0
0a79-0a79 : isapnp write
0cf8-0cff : PCI conf1
4000-403f : 0000:00:07.3
5000-500f : 0000:00:07.3
c000-c01f : 0000:00:07.2
   c000-c01f : uhci_hcd
c400-c4ff : 0000:00:0b.0
c800-c87f : 0000:00:11.0
cc00-cc7f : 0000:00:12.0
d000-d007 : 0000:00:13.0
   d000-d007 : pdc202xx_new
d400-d403 : 0000:00:13.0
   d400-d403 : pdc202xx_new
d800-d807 : 0000:00:13.0
   d800-d807 : pdc202xx_new
dc00-dc03 : 0000:00:13.0
   dc00-dc03 : pdc202xx_new
e000-e00f : 0000:00:13.0
   e000-e00f : pdc202xx_new
f000-f00f : 0000:00:07.1
00000000-0009ffff : System RAM
000a0000-000bffff : Video RAM area
000c0000-000cbbff : Video ROM
000cc000-000d17ff : Adapter ROM
000d2000-000d27ff : Adapter ROM
000d3000-000d37ff : Adapter ROM
000d4000-000d67ff : Adapter ROM
000d6800-000d7fff : pnp 00:08
000f0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-37ffffff : System RAM
   00100000-002a97bc : Kernel code
   002a97bd-0036d02f : Kernel data
   003b3000-003de2cf : Kernel bss
40000000-4001ffff : 0000:00:11.0
40020000-4003ffff : 0000:00:12.0
40040000-4004ffff : 0000:00:0b.0
40050000-40053fff : 0000:00:13.0
d0000000-d7ffffff : PCI Bus 0000:01
   d0000000-d7ffffff : 0000:01:00.0
     d0000000-d7ffffff : rivafb
d8000000-dbffffff : 0000:00:00.0
dc000000-ddffffff : PCI Bus 0000:01
   dc000000-dcffffff : 0000:01:00.0
     dc000000-dcffffff : rivafb
   dd000000-dd00ffff : 0000:01:00.0
df000000-df003fff : 0000:00:13.0
df004000-df00407f : 0000:00:11.0
df005000-df00507f : 0000:00:12.0
df006000-df006fff : 0000:00:0b.0
   df006000-df006fff : aic7xxx
df007000-df007fff : 0000:00:14.0
   df007000-df007fff : ohci_hcd
df008000-df008fff : 0000:00:14.1
   df008000-df008fff : ohci_hcd
df009000-df0090ff : 0000:00:14.2
   df009000-df0090ff : ehci_hcd
fec00000-fec00fff : IOAPIC 0
   fec00000-fec00fff : reserved
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
ffff0000-ffffffff : reserved


[8.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX 
Host bridge (rev 03)
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
         Latency: 32
         Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
         Capabilities: [a0] AGP version 1.0
                 Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- 
GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
                 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- 
FW- Rate=<none>
         Kernel driver in use: agpgart-intel
         Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP 
bridge (rev 03) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap- 66MHz+ UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: dc000000-ddffffff
         Prefetchable memory behind bridge: d0000000-d7ffffff
         Secondary status: 66MHz+ FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B+
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 
01) (prog-if 80 [Master])
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32
         Region 0: [virtual] Memory at 000001f0 (32-bit, 
non-prefetchable) [size=8]
         Region 1: [virtual] Memory at 000003f0 (type 3, 
non-prefetchable) [size=1]
         Region 2: [virtual] Memory at 00000170 (32-bit, 
non-prefetchable) [size=8]
         Region 3: [virtual] Memory at 00000370 (type 3, 
non-prefetchable) [size=1]
         Region 4: I/O ports at f000 [size=16]
         Kernel modules: piix

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB 
(rev 01) (prog-if 00 [UHCI])
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32
         Interrupt: pin D routed to IRQ 19
         Region 4: I/O ports at c000 [size=32]
         Kernel driver in use: uhci_hcd
         Kernel modules: uhci-hcd

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Interrupt: pin ? routed to IRQ 9
         Kernel modules: i2c-piix4

00:0b.0 SCSI storage controller: Adaptec AIC-7880U (rev 01)
         Subsystem: Adaptec AIC-7880P Ultra/Ultra Wide SCSI Chipset
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (2000ns min, 2000ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: I/O ports at c400 [disabled] [size=256]
         Region 1: Memory at df006000 (32-bit, non-prefetchable) [size=4K]
         [virtual] Expansion ROM at 40040000 [disabled] [size=64K]
         Capabilities: [dc] Power Management version 1
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: aic7xxx
         Kernel modules: aic7xxx

00:11.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 74)
         Subsystem: 3Com Corporation 3C905CX-TX/TX-M Fast Etherlink 
for PC Management NIC
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (2500ns min, 2500ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 18
         Region 0: I/O ports at c800 [size=128]
         Region 1: Memory at df004000 (32-bit, non-prefetchable) [size=128]
         [virtual] Expansion ROM at 40000000 [disabled] [size=128K]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-
         Kernel driver in use: 3c59x
         Kernel modules: 3c59x

00:12.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 74)
         Subsystem: 3Com Corporation 3C905CX-TX/TX-M Fast Etherlink 
for PC Management NIC
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (2500ns min, 2500ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 17
         Region 0: I/O ports at cc00 [size=128]
         Region 1: Memory at df005000 (32-bit, non-prefetchable) [size=128]
         [virtual] Expansion ROM at 40020000 [disabled] [size=128K]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-
         Kernel driver in use: 3c59x
         Kernel modules: 3c59x

00:13.0 Mass storage controller: Promise Technology, Inc. PDC20268 
(Ultra100 TX2) (rev 02) (prog-if 85)
         Subsystem: Promise Technology, Inc. Ultra100TX2
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- 
DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (1000ns min, 4500ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: I/O ports at d000 [size=8]
         Region 1: I/O ports at d400 [size=4]
         Region 2: I/O ports at d800 [size=8]
         Region 3: I/O ports at dc00 [size=4]
         Region 4: I/O ports at e000 [size=16]
         Region 5: Memory at df000000 (32-bit, non-prefetchable) [size=16K]
         [virtual] Expansion ROM at 40050000 [disabled] [size=16K]
         Capabilities: [60] Power Management version 1
                 Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: Promise_IDE
         Kernel modules: pdc202xx_new

00:14.0 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
         Subsystem: Belkin Root Hub
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (250ns min, 10500ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 19
         Region 0: Memory at df007000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: ohci_hcd
         Kernel modules: ohci-hcd

00:14.1 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
         Subsystem: Belkin Root Hub
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (250ns min, 10500ns max), Cache Line Size: 32 bytes
         Interrupt: pin B routed to IRQ 16
         Region 0: Memory at df008000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: ohci_hcd
         Kernel modules: ohci-hcd

00:14.2 USB Controller: NEC Corporation USB 2.0 (rev 02) (prog-if 20 [EHCI])
         Subsystem: Belkin Root Hub
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (4000ns min, 8500ns max), Cache Line Size: 32 bytes
         Interrupt: pin C routed to IRQ 17
         Region 0: Memory at df009000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: ehci_hcd
         Kernel modules: ehci-hcd

01:00.0 VGA compatible controller: nVidia Corporation NV11GL [Quadro2 
MXR/EX/Go] (rev a1) (prog-if 00 [VGA controller])
         Subsystem: Guillemot Corporation Device 7100
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (1250ns min, 250ns max)
         Interrupt: pin A routed to IRQ 0
         Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=16M]
         Region 1: Memory at d0000000 (32-bit, prefetchable) [size=128M]
         [virtual] Expansion ROM at dd000000 [disabled] [size=64K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [44] AGP version 2.0
                 Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA- ITACoh- 
GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- 
FW- Rate=<none>
         Kernel driver in use: rivafb


[8.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 01 Lun: 00
   Vendor: COMPAQ   Model: BF0728A4CB       Rev: HPB5
   Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi0 Channel: 00 Id: 02 Lun: 00
   Vendor: COMPAQ   Model: BF07285A36       Rev: HPB7
   Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi0 Channel: 00 Id: 03 Lun: 00
   Vendor: FUJITSU  Model: MAW3073NC        Rev: 0103
   Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: Maxtor 6 Model: L300R0           Rev: BAJ4
   Type:   Direct-Access                    ANSI  SCSI revision: 00


[8.7.] Other information that might be relevant to the problem 
(please look in /proc and include all information that you think to 
be relevant):
N/A


[X.] Other notes, patches, fixes, workarounds:

