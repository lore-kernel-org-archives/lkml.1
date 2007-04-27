Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbXD0BfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbXD0BfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbXD0BfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:35:21 -0400
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:60271 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbXD0BfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:35:10 -0400
From: Thomas Kayser <forensic@milwpc.com>
Organization: Incident Response
To: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: PROBLEM
Date: Thu, 26 Apr 2007 20:35:21 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704262035.21753.forensic@milwpc.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PCI transparent bridge

This report is FYI, filed because of the kernel message.  Using the kernel 
parameter seems to work fine.

On boot there is a message that says this:

Kernel:PCI: Transparent bridge - 0000:00:1e.0
Kernel:PCI: Bus #04 (-#07) is hidden behind transparent bridge #03 (-#04) 
(try 'pci=assign-busses')

When I pass 'pci=assign-busses' to the kernel then the message is only this:

Kernel:PCI: Transparent bridge - 0000:00:1e.0

Keywords: pci transparent bridge

tom@debian5:/usr/src/linux-source-2.6.20$ cat /proc/version
Linux version 2.6.20-04-26-07 (2.6.20-1) (root@debian5) (gcc version 4.1.2 
20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Thu Apr 26 04:15:26 CDT 2007

Scripts/ver_linux output:

Linux debian5 2.6.20-04-26-07 #1 SMP Thu Apr 26 04:15:26 CDT 2007 i686 
GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
pcmciautils            014
pcmcia-cs              3.2.8
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   105
wireless-tools         28
Modules Loaded         rfcomm l2cap bluetooth nfsd exportfs nfs lockd nfs_acl 
sunrpc ppdev lp thermal fan button processor ac battery ipv6 sbp2 scsi_mod 
loop eth1394 pcmcia firmware_class snd_hda_intel snd_hda_codec snd_pcm_oss 
snd_mixer_oss snd_pcm snd_timer yenta_socket snd rsrc_nonstatic i2c_i801 
iTCO_wdt ide_cd soundcore snd_page_alloc cdrom pcspkr parport_pc parport 
uhci_hcd ehci_hcd i2c_core iTCO_vendor_support r8169 sdhci mmc_core ohci1394 
ieee1394 pcmcia_core intel_agp agpgart serio_raw rtc usbcore psmouse ext3 jbd 
mbcache ide_disk generic piix ide_core evdev

tom@debian5:/usr/src/linux-source-2.6.20$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz
stepping        : 6
cpu MHz         : 1828.883
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm 
constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 3661.67
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz
stepping        : 6
cpu MHz         : 1828.883
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm 
constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 3657.78
clflush size    : 64

tom@debian5:/usr/src/linux-source-2.6.20$ cat /proc/modules
rfcomm 35288 0 - Live 0xf8d0d000
l2cap 22016 5 rfcomm, Live 0xf8c73000
bluetooth 48484 4 rfcomm,l2cap, Live 0xf8c8e000
nfsd 202672 17 - Live 0xf8d86000
exportfs 5568 1 nfsd, Live 0xf8c36000
nfs 219308 4 - Live 0xf8d4f000
lockd 58056 3 nfsd,nfs, Live 0xf8c7e000
nfs_acl 3520 2 nfsd,nfs, Live 0xf8c22000
sunrpc 148284 13 nfsd,nfs,lockd,nfs_acl, Live 0xf8ce7000
ppdev 8644 0 - Live 0xf8c67000
lp 11816 0 - Live 0xf8c41000
thermal 13832 0 - Live 0xf8c3c000
fan 4676 0 - Live 0xf8c2a000
button 7760 0 - Live 0xf8ae7000
processor 30008 1 thermal, Live 0xf8c2d000
ac 5124 0 - Live 0xf8af0000
battery 9860 0 - Live 0xf8aec000
ipv6 233184 14 - Live 0xf8cad000
sbp2 21380 0 - Live 0xf8c1b000
scsi_mod 132812 1 sbp2, Live 0xf8c45000
loop 15816 0 - Live 0xf8adc000
eth1394 18500 0 - Live 0xf8ae1000
pcmcia 35436 0 - Live 0xf8ac2000
firmware_class 9536 1 pcmcia, Live 0xf89fc000
snd_hda_intel 19608 0 - Live 0xf8a8e000
snd_hda_codec 151680 1 snd_hda_intel, Live 0xf8af3000
snd_pcm_oss 38944 0 - Live 0xf8ab7000
snd_mixer_oss 15424 1 snd_pcm_oss, Live 0xf89f7000
snd_pcm 71172 3 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xf8aa4000
snd_timer 20612 1 snd_pcm, Live 0xf89f0000
yenta_socket 24844 1 - Live 0xf89e8000
snd 48036 6 
snd_hda_intel,snd_hda_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer, Live 
0xf8a81000
rsrc_nonstatic 12096 1 yenta_socket, Live 0xf896c000
i2c_i801 7500 0 - Live 0xf8970000
iTCO_wdt 10596 0 - Live 0xf893c000
ide_cd 36576 0 - Live 0xf89de000
soundcore 7520 1 snd, Live 0xf8924000
snd_page_alloc 9672 2 snd_hda_intel,snd_pcm, Live 0xf882c000
cdrom 32992 1 ide_cd, Live 0xf89d4000
pcspkr 3072 0 - Live 0xf894c000
parport_pc 32676 0 - Live 0xf89cb000
parport 33544 3 ppdev,lp,parport_pc, Live 0xf89c1000
uhci_hcd 21904 0 - Live 0xf8959000
ehci_hcd 29004 0 - Live 0xf8963000
i2c_core 20672 1 i2c_i801, Live 0xf8952000
iTCO_vendor_support 3844 1 iTCO_wdt, Live 0xf8865000
r8169 28424 0 - Live 0xf8942000
sdhci 17484 0 - Live 0xf891e000
mmc_core 25604 1 sdhci, Live 0xf8927000
ohci1394 32560 0 - Live 0xf8915000
ieee1394 89144 3 sbp2,eth1394,ohci1394, Live 0xf88d0000
pcmcia_core 37268 3 pcmcia,yenta_socket,rsrc_nonstatic, Live 0xf88c5000
intel_agp 22684 1 - Live 0xf8869000
agpgart 30344 2 intel_agp, Live 0xf888c000
serio_raw 6660 0 - Live 0xf8840000
rtc 12464 0 - Live 0xf883b000
usbcore 121864 3 uhci_hcd,ehci_hcd, Live 0xf88eb000
psmouse 35016 0 - Live 0xf8882000
ext3 121416 3 - Live 0xf88a6000
jbd 55208 1 ext3, Live 0xf8873000
mbcache 8324 1 ext3, Live 0xf8837000
ide_disk 15552 5 - Live 0xf8832000
generic 4868 0 [permanent], Live 0xf8829000
piix 9476 0 [permanent], Live 0xf8807000
ide_core 111644 4 ide_cd,ide_disk,generic,piix, Live 0xf8843000
evdev 9280 5 - Live 0xf880b000

tom@debian5:/usr/src/linux-source-2.6.20$ cat /proc/ioports
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
0170-0177 : 0000:00:1f.1
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ide0
0250-025f : pnp 00:0b
0376-0376 : 0000:00:1f.1
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ide0
0400-041f : 0000:00:1f.3
  0400-041f : i801_smbus
0480-04bf : 0000:00:1f.0
0800-087f : 0000:00:1f.0
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0820-0820 : ACPI PM2_CNT_BLK
  0828-082f : ACPI GPE0_BLK
  0860-087f : iTCO_wdt
0a00-0a0f : pnp 00:09
0cf8-0cff : PCI conf1
c000-dfff : PCI Bus #03
  c000-c0ff : PCI CardBus #04
  c400-c4ff : PCI CardBus #04
  d800-d8ff : 0000:03:07.0
    d800-d8ff : r8169
e400-e41f : 0000:00:1d.3
  e400-e41f : uhci_hcd
e480-e49f : 0000:00:1d.2
  e480-e49f : uhci_hcd
e800-e81f : 0000:00:1d.1
  e800-e81f : uhci_hcd
e880-e89f : 0000:00:1d.0
  e880-e89f : uhci_hcd
ec00-ec07 : 0000:00:02.0
ffa0-ffaf : 0000:00:1f.1
  ffa0-ffa7 : ide0

tom@debian5:/usr/src/linux-source-2.6.20$ cat /proc/iomem
00000000-0009fbff : System RAM
  00000000-00000000 : Crash kernel
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000f0000-000fffff : System ROM
00100000-3f7bffff : System RAM
  00100000-002979dc : Kernel code
  002979dd-00332233 : Kernel data
3f7c0000-3f7cdfff : ACPI Tables
3f7ce000-3f7fffff : ACPI Non-volatile Storage
40000000-43ffffff : PCI CardBus #04
44000000-47ffffff : PCI CardBus #04
bdf00000-bfefffff : PCI Bus #03
  bdf00000-bdf1ffff : 0000:03:07.0
d0000000-dfffffff : 0000:00:02.0
fdf00000-fdffffff : PCI Bus #02
  fdfff000-fdffffff : 0000:02:00.0
fe000000-fe8fffff : PCI Bus #03
  fe000000-fe000fff : 0000:03:01.0
    fe000000-fe000fff : yenta_socket
  fe8fec00-fe8fecff : 0000:03:07.0
    fe8fec00-fe8fecff : r8169
  fe8ff000-fe8ff0ff : 0000:03:01.3
  fe8ff400-fe8ff4ff : 0000:03:01.2
    fe8ff400-fe8ff4ff : sdhci:slot0
  fe8ff800-fe8fffff : 0000:03:01.1
    fe8ff800-fe8fffff : ohci1394
fea80000-feafffff : 0000:00:02.1
feb3bc00-feb3bfff : 0000:00:1d.7
  feb3bc00-feb3bfff : ehci_hcd
feb3c000-feb3ffff : 0000:00:1b.0
  feb3c000-feb3ffff : ICH HD audio
feb40000-feb7ffff : 0000:00:02.0
feb80000-febfffff : 0000:00:02.0
fee00000-fee00fff : reserved
ffb80000-ffffffff : reserved

This is one of wildly successful CBB notebook computers from 
LinuxCertified.com, the 14" display LC2210DC, or ASI S62FM

debian5:/usr/src/linux-source-2.6.20# lspci -vvv
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT 
Express Memory Controller Hub (rev 03)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML 
Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1252
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at feb80000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at ec00 [size=8]
        Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at feb40000 (32-bit, non-prefetchable) [size=256K]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML Express 
Integrated Graphics Controller (rev 03)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1252
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at fea80000 (32-bit, non-prefetchable) [size=512K]
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition 
Audio Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at feb3c000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 
(rev 02) (prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes Disabled CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 2, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
                Address: fee0300c  Data: 41b9
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 
1297
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 
(rev 02) (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fdf00000-fdffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 3, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
                Address: fee0300c  Data: 41c1
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 
1297
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at e880 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at e800 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at e480 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 16
        Region 4: I/O ports at e400 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 02) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at feb3bc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) 
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=03, subordinate=07, sec-latency=32
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: fe000000-fe8fffff
        Prefetchable memory behind bridge: 00000000bdf00000-00000000bfefffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Unknown device 
1297

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge 
(rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller 
(rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at ffa0 [size=16]

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 
02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at 0400 [size=32]

02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network 
Connection (rev 02)
        Subsystem: Intel Corporation Unknown device 1000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at fdfff000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <512ns, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
                Link: Latency L0s <128ns, L1 <64us
                Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

03:01.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b3)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 168
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at fe000000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=03, secondary=04, subordinate=07, sec-latency=176
        Memory window 0: 40000000-43fff000 (prefetchable)
        Memory window 1: 44000000-47fff000
        I/O window 0: 0000c000-0000c0ff
        I/O window 1: 0000c400-0000c4ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001

03:01.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 
08) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (500ns min, 1000ns max)
        Interrupt: pin B routed to IRQ 18
        Region 0: Memory at fe8ff800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME+

03:01.2 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 
SD/SDIO/MMC/MS/MSPro Host Adapter (rev 17)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Interrupt: pin C routed to IRQ 19
        Region 0: Memory at fe8ff400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter 
(rev 08)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1297
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 4
        Region 0: Memory at fe8ff000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit 
Ethernet (rev 10)
        Subsystem: ASUSTeK Computer Inc. Unknown device 11e5
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at d800 [size=256]
        Region 1: Memory at fe8fec00 (32-bit, non-prefetchable) [size=256]
        Expansion ROM at bdf00000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

tom@debian5:/usr/src/linux-source-2.6.20$ cat /proc/scsi/scsi
Attached devices:


-- 

Those who exalt human knowledge become laughing stock for The Sons of God.
