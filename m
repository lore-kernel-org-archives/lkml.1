Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbYFBTO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbYFBTO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYFBTOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:14:16 -0400
Received: from centos-01.unidatacentre.com ([193.34.82.1]:58172 "EHLO
	mail1.unidatacentre.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbYFBTOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:14:05 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jun 2008 15:14:03 EDT
X-Originating-IP: 87.232.32.236
Message-ID: <484452EF.6020505@roselawnhouse.com>
Date: Mon, 02 Jun 2008 21:07:11 +0100
From: Anton Sidorov <anton@roselawnhouse.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080524)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel does not boot in SMP mode if I press any button on a keyboard
 before kernel loads (i.e. grub menu)
X-Enigmail-Version: 0.95.6
OpenPGP: id=448AEF9F
Content-Type: multipart/mixed;
 boundary="------------070209070307060307080700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070209070307060307080700
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

1. kernel does not boot in SMP mode if I press any button on a keyboard 
before kernel loads (i.e. grub menu)
2. This is Dell Vostro 400 Core 2 Quad Q6600 with the latest bios 
1.0.13. Ubuntu kernel 2.6.24-16-generic boots with ipqpoll. Gentoo 
2.6.24-gentoo-r8 and vanilla 2.6.25.4 do not boot in SMP mode if I press 
any button on a keyboard before kernel loads (i.e. grub menu). I tried 
noacpi, noapic, acpi=off, irqpoll still does not boot.
It boots if I add nosmp but the computer is very slow.
3. Gentoo 2.6.24-gentoo-r8, vanilla 2.6.25.4, Dell Vostro 400 Core 2 
Quad Q6600
4. Linux version 2.6.24-gentoo-r8-optimized (root@anton-dsktp) (gcc 
version 4.1.2 (Gentoo 4.1.2 p1.1)) #4 SMP Sat May 31 22:44:51 IST 2008
5. /proc/cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping    : 11
cpu MHz        : 1600.000
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 4
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm 
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3 
cx16 xtpr lahf_lm
bogomips    : 4792.26
clflush size    : 64

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping    : 11
cpu MHz        : 1600.000
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 4
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm 
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3 
cx16 xtpr lahf_lm
bogomips    : 4789.51
clflush size    : 64

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping    : 11
cpu MHz        : 1600.000
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 2
cpu cores    : 4
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm 
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3 
cx16 xtpr lahf_lm
bogomips    : 4789.55
clflush size    : 64

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping    : 11
cpu MHz        : 1600.000
cache size    : 4096 KB
physical id    : 0
siblings    : 4
core id        : 3
cpu cores    : 4
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm 
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3 
cx16 xtpr lahf_lm
bogomips    : 4789.55
clflush size    : 64
6. /proc/modules
nls_iso8859_1 4224 1 - Live 0xf8ff9000
vfat 10496 1 - Live 0xf8f68000
fat 45084 1 vfat, Live 0xf9008000
snd_pcm_oss 35328 0 - Live 0xf8f84000
snd_mixer_oss 14336 1 snd_pcm_oss, Live 0xf8f5e000
snd_seq_oss 29312 0 - Live 0xf8f7b000
snd_seq_midi_event 6528 1 snd_seq_oss, Live 0xf8e3b000
snd_seq 47088 4 snd_seq_oss,snd_seq_midi_event, Live 0xf8f6e000
snd_seq_device 6924 2 snd_seq_oss,snd_seq, Live 0xf8dcd000
xt_limit 2560 2 - Live 0xf8dd0000
xt_tcpudp 3456 19 - Live 0xf8cf6000
nf_conntrack_ipv4 12552 4 - Live 0xf8dd3000
xt_state 2432 4 - Live 0xf8d02000
nf_conntrack 48064 2 nf_conntrack_ipv4,xt_state, Live 0xf8f51000
iptable_filter 2688 1 - Live 0xf8cf2000
ip_tables 10580 1 iptable_filter, Live 0xf8dc6000
x_tables 11780 4 xt_limit,xt_tcpudp,xt_state,ip_tables, Live 0xf8d6d000
ext2 46852 1 - Live 0xf8e2e000
usb_storage 35072 0 - Live 0xf8e24000
acpi_cpufreq 7324 1 - Live 0xf8d48000
usblp 12032 0 - Live 0xf8d51000
nvidia 7813024 24 - Live 0xf965c000 (P)
thermal 12956 0 - Live 0xf8d4c000
snd_hda_intel 278812 1 - Live 0xf8dde000
snd_pcm 61316 2 snd_pcm_oss,snd_hda_intel, Live 0xf8d74000
snd_timer 18948 2 snd_seq,snd_pcm, Live 0xf8d27000
fan 3844 0 - Live 0xf8cf4000
snd 44036 10 
snd_pcm_oss,snd_mixer_oss,snd_seq_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_timer, 
Live 0xf8d55000
soundcore 6112 1 snd, Live 0xf8d06000
processor 29272 2 acpi_cpufreq,thermal, Live 0xf8d1e000
button 6544 0 - Live 0xf8cff000
e1000e 91044 0 - Live 0xf8d2e000
ehci_hcd 32268 0 - Live 0xf8d0a000
uhci_hcd 22412 0 - Live 0xf8cf8000
i2c_core 19200 1 nvidia, Live 0xf8cdb000
snd_page_alloc 8072 2 snd_hda_intel,snd_pcm, Live 0xf8ceb000
iTCO_wdt 10276 0 - Live 0xf8ce5000
evdev 9088 4 - Live 0xf8ce1000
pcspkr 2816 0 - Live 0xf8cd9000
7.  /proc/iomem
00000000-0009e7ff : System RAM
0009e800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cf1ff : Video ROM
000f0000-000fffff : System ROM
00100000-7fe8ffff : System RAM
  00100000-0032b6b7 : Kernel code
  0032b6b8-003e2163 : Kernel data
  00425000-004875d3 : Kernel bss
7fe90000-7fee2fff : ACPI Non-volatile Storage
7fee3000-7feeffff : ACPI Tables
7fef0000-7fefffff : reserved
7ff00000-7fffffff : pnp 00:0b
d0000000-dfffffff : PCI Bus #01
  d0000000-dfffffff : 0000:01:00.0
e0000000-efffffff : PCI MMCONFIG 0
  e0000000-efffffff : reserved
fa000000-fcffffff : PCI Bus #01
  fa000000-faffffff : 0000:01:00.0
    fa000000-faffffff : nvidia
  fb000000-fbffffff : 0000:01:00.0
  fc000000-fc01ffff : 0000:01:00.0
fdd00000-fddfffff : PCI Bus #02
fde00000-fdefffff : PCI Bus #02
  fdeff000-fdefffff : 0000:02:00.0
fdfc0000-fdfdffff : 0000:00:19.0
  fdfc0000-fdfdffff : e1000e
fdff4000-fdff7fff : 0000:00:1b.0
  fdff4000-fdff7fff : ICH HD audio
fdffc000-fdffc0ff : 0000:00:1f.3
fdffd000-fdffd3ff : 0000:00:1d.7
  fdffd000-fdffd3ff : ehci_hcd
fdffe000-fdffe3ff : 0000:00:1a.7
  fdffe000-fdffe3ff : ehci_hcd
fdfff000-fdffffff : 0000:00:19.0
  fdfff000-fdffffff : e1000e
fec00000-ffffffff : reserved
  fed00000-fed003ff : HPET 0
8. /proc/ioports
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
0290-0297 : pnp 00:01
03c0-03df : vga+
0400-047f : 0000:00:1f.0
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0420-042f : ACPI GPE0_BLK
  0460-047f : iTCO_wdt
0480-04bf : 0000:00:1f.0
04d0-04d1 : pnp 00:01
0500-051f : 0000:00:1f.3
0800-087f : pnp 00:01
0880-088f : pnp 00:01
0cf8-0cff : PCI conf1
c000-cfff : PCI Bus #01
d000-dfff : PCI Bus #02
ec00-ec0f : 0000:00:1f.5
ed00-ed0f : 0000:00:1f.5
  ed00-ed0f : libata
ee00-ee03 : 0000:00:1f.5
  ee00-ee03 : libata
ef00-ef07 : 0000:00:1f.5
  ef00-ef07 : libata
f000-f003 : 0000:00:1f.5
  f000-f003 : libata
f100-f107 : 0000:00:1f.5
  f100-f107 : libata
f300-f30f : 0000:00:1f.2
f400-f40f : 0000:00:1f.2
  f400-f40f : libata
f500-f503 : 0000:00:1f.2
  f500-f503 : libata
f600-f607 : 0000:00:1f.2
  f600-f607 : libata
f700-f703 : 0000:00:1f.2
  f700-f703 : libata
f800-f807 : 0000:00:1f.2
  f800-f807 : libata
f900-f91f : 0000:00:1d.2
  f900-f91f : uhci_hcd
fa00-fa1f : 0000:00:1d.1
  fa00-fa1f : uhci_hcd
fb00-fb1f : 0000:00:1d.0
  fb00-fb1f : uhci_hcd
fc00-fc1f : 0000:00:1a.2
  fc00-fc1f : uhci_hcd
fd00-fd1f : 0000:00:1a.1
  fd00-fd1f : uhci_hcd
fe00-fe1f : 0000:00:1a.0
  fe00-fe1f : uhci_hcd
ff00-ff1f : 0000:00:19.0
  ff00-ff1f : e1000e
9. lspci -vvv
00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
    Subsystem: Dell Unknown device 023d
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information <?>

00:01.0 PCI bridge: Intel Corporation PCI Express Root Port (rev 02) 
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
    I/O behind bridge: 0000c000-0000cfff
    Memory behind bridge: fa000000-fcffffff
    Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [88] Subsystem: Dell Unknown device 023d
    Capabilities: [80] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
        Address: 00000000  Data: 0000
    Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
        LnkCap:    Port #2, Speed 2.5GT/s, Width x16, ASPM L0s, Latency 
L0 <1us, L1 <4us
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
            Slot #  0, PowerLimit 0.000000; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
            Control: AttnInd Off, PwrInd On, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
            Changed: MRL- PresDet+ LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [140] Root Complex Link <?>
    Kernel driver in use: pcieport-driver

00:19.0 Ethernet controller: Intel Corporation 82562V-2 10/100 Network 
Connection (rev 02)
    Subsystem: Dell Unknown device 023d
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 21
    Region 0: Memory at fdfc0000 (32-bit, non-prefetchable) [size=128K]
    Region 1: Memory at fdfff000 (32-bit, non-prefetchable) [size=4K]
    Region 2: I/O ports at ff00 [size=32]
    Capabilities: [c8] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=1 PME-
    Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [e0] Vendor Specific Information <?>
    Kernel driver in use: e1000e
    Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 
02) (prog-if 00 [UHCI])
    Subsystem: Dell Unknown device 023d
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 4: I/O ports at fe00 [size=32]
    Capabilities: [50] Vendor Specific Information <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 
02) (prog-if 00 [UHCI])
    Subsystem: Dell Unknown device 023d
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 18
    Region 4: I/O ports at fd00 [size=32]
    Capabilities: [50] Vendor Specific Information <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1a.2 USB Controller: Intel Corporation USB UHCI Controller #6 (rev 
02) (prog-if 00 [UHCI])
    Subsystem: Dell Unknown device 023d
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 17
    Region 4: I/O ports at fc00 [size=32]
    Capabilities: [50] Vendor Specific Information <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 
02) (prog-if 20 [EHCI])
    Subsystem: Dell Unknown device 023d
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 20
    Region 0: Memory at fdffe000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ehci_hcd
    Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation HD Audio Controller (rev 02)
    Subsystem: Dell Unknown device 023d
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 22
    Region 0: Memory at fdff4000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
            ExtTag- RBE- FLReset+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown, 
Latency L0 <64ns, L1 <1us
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [130] Root Complex Link <?>
    Kernel driver in use: HDA Intel
    Kernel modules: snd-hda-intel

00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 
02) (prog-if 00 [UHCI])
    Subsystem: Dell Unknown device 023d
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 19
    Region 4: I/O ports at fb00 [size=32]
    Capabilities: [50] Vendor Specific Information <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 
02) (prog-if 00 [UHCI])
    Subsystem: Dell Unknown device 023d
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 17
    Region 4: I/O ports at fa00 [size=32]
    Capabilities: [50] Vendor Specific Information <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 
02) (prog-if 00 [UHCI])
    Subsystem: Dell Unknown device 023d
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 20
    Region 4: I/O ports at f900 [size=32]
    Capabilities: [50] Vendor Specific Information <?>
    Kernel driver in use: uhci_hcd
    Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 
02) (prog-if 20 [EHCI])
    Subsystem: Dell Unknown device 023d
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 19
    Region 0: Memory at fdffd000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ehci_hcd
    Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 
01 [Subtractive decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
    I/O behind bridge: 0000d000-0000dfff
    Memory behind bridge: fde00000-fdefffff
    Prefetchable memory behind bridge: 00000000fdd00000-00000000fddfffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [50] Subsystem: Dell Unknown device 023d

00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
    Subsystem: Dell Unknown device 023d
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information <?>
    Kernel modules: iTCO_wdt

00:1f.2 IDE interface: Intel Corporation 4 port SATA IDE Controller (rev 
02) (prog-if 8f [Master SecP SecO PriP PriO])
    Subsystem: Dell Unknown device 023d
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 17
    Region 0: I/O ports at f800 [size=8]
    Region 1: I/O ports at f700 [size=4]
    Region 2: I/O ports at f600 [size=8]
    Region 3: I/O ports at f500 [size=4]
    Region 4: I/O ports at f400 [size=16]
    Region 5: I/O ports at f300 [size=16]
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [b0] Vendor Specific Information <?>
    Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
    Subsystem: Dell Unknown device 023d
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin B routed to IRQ 11
    Region 0: Memory at fdffc000 (64-bit, non-prefetchable) [size=256]
    Region 4: I/O ports at 0500 [size=32]

00:1f.5 IDE interface: Intel Corporation 2 port SATA IDE Controller (rev 
02) (prog-if 85 [Master SecO PriO])
    Subsystem: Dell Unknown device 023d
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 17
    Region 0: I/O ports at f100 [size=8]
    Region 1: I/O ports at f000 [size=4]
    Region 2: I/O ports at ef00 [size=8]
    Region 3: I/O ports at ee00 [size=4]
    Region 4: I/O ports at ed00 [size=16]
    Region 5: I/O ports at ec00 [size=16]
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [b0] Vendor Specific Information <?>
    Kernel driver in use: ata_piix

01:00.0 VGA compatible controller: nVidia Corporation NV42 [GeForce 6800 
XT] (rev a2) (prog-if 00 [VGA controller])
    Subsystem: XFX Pine Group Inc. Unknown device 2177
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
    Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
    Region 3: Memory at fb000000 (64-bit, non-prefetchable) [size=16M]
    [virtual] Expansion ROM at fc000000 [disabled] [size=128K]
    Capabilities: [60] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [78] Express (v1) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <4us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s, Latency 
L0 <1us, L1 <16us
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100] Virtual Channel <?>
    Capabilities: [128] Power Budgeting <?>
    Kernel driver in use: nvidia
    Kernel modules: nvidia

02:00.0 FireWire (IEEE 1394): NEC Corporation IEEE 1394 Host Controller 
(rev 01) (prog-if 10 [OHCI])
    Subsystem: NEC Corporation Unknown device 00ce
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 4
    Region 0: Memory at fdeff000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [60] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

10. /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD2500AAJS-7 Rev: 12.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD2500AAJS-7 Rev: 12.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: PBDS     Model: DVD+-RW DH-16W1S Rev: 2D14
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: PLDS     Model: DVD-ROM DH-16D2S Rev: JD11
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: TEAC     Model: USB   HS-CF Card Rev: 4.08
  Type:   Direct-Access                    ANSI  SCSI revision: 00


--------------070209070307060307080700
Content-Type: text/plain;
 name="config"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config"

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMg
TGludXgga2VybmVsIHZlcnNpb246IDIuNi4yNC1nZW50b28tcjgKIyBTYXQgTWF5IDMxIDIy
OjQ0OjE3IDIwMDgKIwojIENPTkZJR182NEJJVCBpcyBub3Qgc2V0CkNPTkZJR19YODZfMzI9
eQojIENPTkZJR19YODZfNjQgaXMgbm90IHNldApDT05GSUdfWDg2PXkKQ09ORklHX0dFTkVS
SUNfVElNRT15CkNPTkZJR19HRU5FUklDX0NNT1NfVVBEQVRFPXkKQ09ORklHX0NMT0NLU09V
UkNFX1dBVENIRE9HPXkKQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFM9eQpDT05GSUdfR0VO
RVJJQ19DTE9DS0VWRU5UU19CUk9BRENBU1Q9eQpDT05GSUdfTE9DS0RFUF9TVVBQT1JUPXkK
Q09ORklHX1NUQUNLVFJBQ0VfU1VQUE9SVD15CkNPTkZJR19TRU1BUEhPUkVfU0xFRVBFUlM9
eQpDT05GSUdfTU1VPXkKQ09ORklHX1pPTkVfRE1BPXkKQ09ORklHX1FVSUNLTElTVD15CkNP
TkZJR19HRU5FUklDX0lTQV9ETUE9eQpDT05GSUdfR0VORVJJQ19JT01BUD15CkNPTkZJR19H
RU5FUklDX0JVRz15CkNPTkZJR19HRU5FUklDX0hXRUlHSFQ9eQpDT05GSUdfQVJDSF9NQVlf
SEFWRV9QQ19GREM9eQpDT05GSUdfRE1JPXkKIyBDT05GSUdfUldTRU1fR0VORVJJQ19TUElO
TE9DSyBpcyBub3Qgc2V0CkNPTkZJR19SV1NFTV9YQ0hHQUREX0FMR09SSVRITT15CiMgQ09O
RklHX0FSQ0hfSEFTX0lMT0cyX1UzMiBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfSEFTX0lM
T0cyX1U2NCBpcyBub3Qgc2V0CkNPTkZJR19HRU5FUklDX0NBTElCUkFURV9ERUxBWT15CiMg
Q09ORklHX0dFTkVSSUNfVElNRV9WU1lTQ0FMTCBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX1NV
UFBPUlRTX09QUk9GSUxFPXkKQ09ORklHX0RFRkNPTkZJR19MSVNUPSJhcmNoL3g4Ni9jb25m
aWdzL2kzODZfZGVmY29uZmlnIgojIENPTkZJR19aT05FX0RNQTMyIGlzIG5vdCBzZXQKQ09O
RklHX0FSQ0hfUE9QVUxBVEVTX05PREVfTUFQPXkKIyBDT05GSUdfQVVESVRfQVJDSCBpcyBu
b3Qgc2V0CkNPTkZJR19HRU5FUklDX0hBUkRJUlFTPXkKQ09ORklHX0dFTkVSSUNfSVJRX1BS
T0JFPXkKQ09ORklHX0dFTkVSSUNfUEVORElOR19JUlE9eQpDT05GSUdfWDg2X1NNUD15CkNP
TkZJR19YODZfSFQ9eQpDT05GSUdfWDg2X0JJT1NfUkVCT09UPXkKQ09ORklHX1g4Nl9UUkFN
UE9MSU5FPXkKQ09ORklHX0tUSU1FX1NDQUxBUj15CgojCiMgR2VuZXJhbCBzZXR1cAojCkNP
TkZJR19FWFBFUklNRU5UQUw9eQpDT05GSUdfTE9DS19LRVJORUw9eQpDT05GSUdfSU5JVF9F
TlZfQVJHX0xJTUlUPTMyCkNPTkZJR19MT0NBTFZFUlNJT049Ii1vcHRpbWl6ZWQiCkNPTkZJ
R19MT0NBTFZFUlNJT05fQVVUTz15CkNPTkZJR19TV0FQPXkKQ09ORklHX1NZU1ZJUEM9eQpD
T05GSUdfU1lTVklQQ19TWVNDVEw9eQpDT05GSUdfUE9TSVhfTVFVRVVFPXkKQ09ORklHX0JT
RF9QUk9DRVNTX0FDQ1Q9eQpDT05GSUdfQlNEX1BST0NFU1NfQUNDVF9WMz15CiMgQ09ORklH
X1RBU0tTVEFUUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTRVJfTlMgaXMgbm90IHNldAojIENP
TkZJR19QSURfTlMgaXMgbm90IHNldAojIENPTkZJR19BVURJVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0lLQ09ORklHIGlzIG5vdCBzZXQKQ09ORklHX0xPR19CVUZfU0hJRlQ9MTgKIyBDT05G
SUdfQ0dST1VQUyBpcyBub3Qgc2V0CkNPTkZJR19GQUlSX0dST1VQX1NDSEVEPXkKQ09ORklH
X0ZBSVJfVVNFUl9TQ0hFRD15CiMgQ09ORklHX0ZBSVJfQ0dST1VQX1NDSEVEIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU1lTRlNfREVQUkVDQVRFRCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFTEFZ
IGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfSU5JVFJEPXkKQ09ORklHX0lOSVRSQU1GU19T
T1VSQ0U9IiIKIyBDT05GSUdfQ0NfT1BUSU1JWkVfRk9SX1NJWkUgaXMgbm90IHNldApDT05G
SUdfU1lTQ1RMPXkKIyBDT05GSUdfRU1CRURERUQgaXMgbm90IHNldApDT05GSUdfVUlEMTY9
eQpDT05GSUdfU1lTQ1RMX1NZU0NBTEw9eQpDT05GSUdfS0FMTFNZTVM9eQojIENPTkZJR19L
QUxMU1lNU19FWFRSQV9QQVNTIGlzIG5vdCBzZXQKQ09ORklHX0hPVFBMVUc9eQpDT05GSUdf
UFJJTlRLPXkKQ09ORklHX0JVRz15CkNPTkZJR19FTEZfQ09SRT15CkNPTkZJR19CQVNFX0ZV
TEw9eQpDT05GSUdfRlVURVg9eQpDT05GSUdfQU5PTl9JTk9ERVM9eQpDT05GSUdfRVBPTEw9
eQpDT05GSUdfU0lHTkFMRkQ9eQpDT05GSUdfRVZFTlRGRD15CkNPTkZJR19TSE1FTT15CkNP
TkZJR19WTV9FVkVOVF9DT1VOVEVSUz15CkNPTkZJR19TTFVCX0RFQlVHPXkKIyBDT05GSUdf
U0xBQiBpcyBub3Qgc2V0CkNPTkZJR19TTFVCPXkKIyBDT05GSUdfU0xPQiBpcyBub3Qgc2V0
CkNPTkZJR19TTEFCSU5GTz15CkNPTkZJR19SVF9NVVRFWEVTPXkKIyBDT05GSUdfVElOWV9T
SE1FTSBpcyBub3Qgc2V0CkNPTkZJR19CQVNFX1NNQUxMPTAKQ09ORklHX01PRFVMRVM9eQpD
T05GSUdfTU9EVUxFX1VOTE9BRD15CiMgQ09ORklHX01PRFVMRV9GT1JDRV9VTkxPQUQgaXMg
bm90IHNldAojIENPTkZJR19NT0RWRVJTSU9OUyBpcyBub3Qgc2V0CiMgQ09ORklHX01PRFVM
RV9TUkNWRVJTSU9OX0FMTCBpcyBub3Qgc2V0CkNPTkZJR19LTU9EPXkKQ09ORklHX1NUT1Bf
TUFDSElORT15CkNPTkZJR19CTE9DSz15CiMgQ09ORklHX0xCRCBpcyBub3Qgc2V0CiMgQ09O
RklHX0JMS19ERVZfSU9fVFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19MU0YgaXMgbm90IHNl
dAojIENPTkZJR19CTEtfREVWX0JTRyBpcyBub3Qgc2V0CgojCiMgSU8gU2NoZWR1bGVycwoj
CkNPTkZJR19JT1NDSEVEX05PT1A9eQpDT05GSUdfSU9TQ0hFRF9BUz15CkNPTkZJR19JT1ND
SEVEX0RFQURMSU5FPXkKQ09ORklHX0lPU0NIRURfQ0ZRPXkKQ09ORklHX0RFRkFVTFRfQVM9
eQojIENPTkZJR19ERUZBVUxUX0RFQURMSU5FIGlzIG5vdCBzZXQKIyBDT05GSUdfREVGQVVM
VF9DRlEgaXMgbm90IHNldAojIENPTkZJR19ERUZBVUxUX05PT1AgaXMgbm90IHNldApDT05G
SUdfREVGQVVMVF9JT1NDSEVEPSJhbnRpY2lwYXRvcnkiCgojCiMgUHJvY2Vzc29yIHR5cGUg
YW5kIGZlYXR1cmVzCiMKQ09ORklHX1RJQ0tfT05FU0hPVD15CkNPTkZJR19OT19IWj15CkNP
TkZJR19ISUdIX1JFU19USU1FUlM9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UU19CVUlM
RD15CkNPTkZJR19TTVA9eQpDT05GSUdfWDg2X1BDPXkKIyBDT05GSUdfWDg2X0VMQU4gaXMg
bm90IHNldAojIENPTkZJR19YODZfVk9ZQUdFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9O
VU1BUSBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9TVU1NSVQgaXMgbm90IHNldAojIENPTkZJ
R19YODZfQklHU01QIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1ZJU1dTIGlzIG5vdCBzZXQK
IyBDT05GSUdfWDg2X0dFTkVSSUNBUkNIIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X0VTNzAw
MCBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9WU01QIGlzIG5vdCBzZXQKQ09ORklHX1NDSEVE
X05PX05PX09NSVRfRlJBTUVfUE9JTlRFUj15CkNPTkZJR19QQVJBVklSVF9HVUVTVD15CiMg
Q09ORklHX1hFTiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZNSSBpcyBub3Qgc2V0CiMgQ09ORklH
X0xHVUVTVF9HVUVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX00zODYgaXMgbm90IHNldAojIENP
TkZJR19NNDg2IGlzIG5vdCBzZXQKIyBDT05GSUdfTTU4NiBpcyBub3Qgc2V0CiMgQ09ORklH
X001ODZUU0MgaXMgbm90IHNldAojIENPTkZJR19NNTg2TU1YIGlzIG5vdCBzZXQKIyBDT05G
SUdfTTY4NiBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVNSUkgaXMgbm90IHNldAojIENP
TkZJR19NUEVOVElVTUlJSSBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVNTSBpcyBub3Qg
c2V0CiMgQ09ORklHX01QRU5USVVNNCBpcyBub3Qgc2V0CiMgQ09ORklHX01LNiBpcyBub3Qg
c2V0CiMgQ09ORklHX01LNyBpcyBub3Qgc2V0CiMgQ09ORklHX01LOCBpcyBub3Qgc2V0CiMg
Q09ORklHX01DUlVTT0UgaXMgbm90IHNldAojIENPTkZJR19NRUZGSUNFT04gaXMgbm90IHNl
dAojIENPTkZJR19NV0lOQ0hJUEM2IGlzIG5vdCBzZXQKIyBDT05GSUdfTVdJTkNISVAyIGlz
IG5vdCBzZXQKIyBDT05GSUdfTVdJTkNISVAzRCBpcyBub3Qgc2V0CiMgQ09ORklHX01HRU9E
RUdYMSBpcyBub3Qgc2V0CiMgQ09ORklHX01HRU9ERV9MWCBpcyBub3Qgc2V0CiMgQ09ORklH
X01DWVJJWElJSSBpcyBub3Qgc2V0CiMgQ09ORklHX01WSUFDM18yIGlzIG5vdCBzZXQKIyBD
T05GSUdfTVZJQUM3IGlzIG5vdCBzZXQKIyBDT05GSUdfTVBTQyBpcyBub3Qgc2V0CkNPTkZJ
R19NQ09SRTI9eQojIENPTkZJR19HRU5FUklDX0NQVSBpcyBub3Qgc2V0CkNPTkZJR19YODZf
R0VORVJJQz15CkNPTkZJR19YODZfQ01QWENIRz15CkNPTkZJR19YODZfTDFfQ0FDSEVfU0hJ
RlQ9NwpDT05GSUdfWDg2X1hBREQ9eQpDT05GSUdfWDg2X1dQX1dPUktTX09LPXkKQ09ORklH
X1g4Nl9JTlZMUEc9eQpDT05GSUdfWDg2X0JTV0FQPXkKQ09ORklHX1g4Nl9QT1BBRF9PSz15
CkNPTkZJR19YODZfR09PRF9BUElDPXkKQ09ORklHX1g4Nl9JTlRFTF9VU0VSQ09QWT15CkNP
TkZJR19YODZfVVNFX1BQUk9fQ0hFQ0tTVU09eQpDT05GSUdfWDg2X1RTQz15CkNPTkZJR19Y
ODZfTUlOSU1VTV9DUFVfRkFNSUxZPTQKQ09ORklHX0hQRVRfVElNRVI9eQpDT05GSUdfSFBF
VF9FTVVMQVRFX1JUQz15CkNPTkZJR19OUl9DUFVTPTQKQ09ORklHX1NDSEVEX1NNVD15CkNP
TkZJR19TQ0hFRF9NQz15CiMgQ09ORklHX1BSRUVNUFRfTk9ORSBpcyBub3Qgc2V0CkNPTkZJ
R19QUkVFTVBUX1ZPTFVOVEFSWT15CiMgQ09ORklHX1BSRUVNUFQgaXMgbm90IHNldApDT05G
SUdfUFJFRU1QVF9CS0w9eQpDT05GSUdfWDg2X0xPQ0FMX0FQSUM9eQpDT05GSUdfWDg2X0lP
X0FQSUM9eQpDT05GSUdfWDg2X01DRT15CkNPTkZJR19YODZfTUNFX05PTkZBVEFMPW0KQ09O
RklHX1g4Nl9NQ0VfUDRUSEVSTUFMPXkKQ09ORklHX1ZNODY9eQojIENPTkZJR19UT1NISUJB
IGlzIG5vdCBzZXQKIyBDT05GSUdfSThLIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1JFQk9P
VEZJWFVQUyBpcyBub3Qgc2V0CkNPTkZJR19NSUNST0NPREU9bQpDT05GSUdfTUlDUk9DT0RF
X09MRF9JTlRFUkZBQ0U9eQpDT05GSUdfWDg2X01TUj1tCkNPTkZJR19YODZfQ1BVSUQ9bQoj
IENPTkZJR19OT0hJR0hNRU0gaXMgbm90IHNldApDT05GSUdfSElHSE1FTTRHPXkKIyBDT05G
SUdfSElHSE1FTTY0RyBpcyBub3Qgc2V0CkNPTkZJR19QQUdFX09GRlNFVD0weEMwMDAwMDAw
CkNPTkZJR19ISUdITUVNPXkKQ09ORklHX05FRURfTk9ERV9NRU1NQVBfU0laRT15CkNPTkZJ
R19BUkNIX0ZMQVRNRU1fRU5BQkxFPXkKQ09ORklHX0FSQ0hfU1BBUlNFTUVNX0VOQUJMRT15
CkNPTkZJR19BUkNIX1NFTEVDVF9NRU1PUllfTU9ERUw9eQpDT05GSUdfU0VMRUNUX01FTU9S
WV9NT0RFTD15CiMgQ09ORklHX0ZMQVRNRU1fTUFOVUFMIGlzIG5vdCBzZXQKIyBDT05GSUdf
RElTQ09OVElHTUVNX01BTlVBTCBpcyBub3Qgc2V0CkNPTkZJR19TUEFSU0VNRU1fTUFOVUFM
PXkKQ09ORklHX1NQQVJTRU1FTT15CkNPTkZJR19IQVZFX01FTU9SWV9QUkVTRU5UPXkKQ09O
RklHX1NQQVJTRU1FTV9TVEFUSUM9eQojIENPTkZJR19TUEFSU0VNRU1fVk1FTU1BUF9FTkFC
TEUgaXMgbm90IHNldAoKIwojIE1lbW9yeSBob3RwbHVnIGlzIGN1cnJlbnRseSBpbmNvbXBh
dGlibGUgd2l0aCBTb2Z0d2FyZSBTdXNwZW5kCiMKQ09ORklHX1NQTElUX1BUTE9DS19DUFVT
PTQKIyBDT05GSUdfUkVTT1VSQ0VTXzY0QklUIGlzIG5vdCBzZXQKQ09ORklHX1pPTkVfRE1B
X0ZMQUc9MQpDT05GSUdfQk9VTkNFPXkKQ09ORklHX05SX1FVSUNLPTEKQ09ORklHX1ZJUlRf
VE9fQlVTPXkKIyBDT05GSUdfSElHSFBURSBpcyBub3Qgc2V0CiMgQ09ORklHX01BVEhfRU1V
TEFUSU9OIGlzIG5vdCBzZXQKQ09ORklHX01UUlI9eQojIENPTkZJR19FRkkgaXMgbm90IHNl
dApDT05GSUdfSVJRQkFMQU5DRT15CkNPTkZJR19TRUNDT01QPXkKIyBDT05GSUdfSFpfMTAw
IGlzIG5vdCBzZXQKIyBDT05GSUdfSFpfMjUwIGlzIG5vdCBzZXQKQ09ORklHX0haXzMwMD15
CiMgQ09ORklHX0haXzEwMDAgaXMgbm90IHNldApDT05GSUdfSFo9MzAwCiMgQ09ORklHX0tF
WEVDIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JBU0hfRFVNUCBpcyBub3Qgc2V0CkNPTkZJR19Q
SFlTSUNBTF9TVEFSVD0weDEwMDAwMAojIENPTkZJR19SRUxPQ0FUQUJMRSBpcyBub3Qgc2V0
CkNPTkZJR19QSFlTSUNBTF9BTElHTj0weDEwMDAwMApDT05GSUdfSE9UUExVR19DUFU9eQpD
T05GSUdfQ09NUEFUX1ZEU089eQpDT05GSUdfQVJDSF9FTkFCTEVfTUVNT1JZX0hPVFBMVUc9
eQoKIwojIFBvd2VyIG1hbmFnZW1lbnQgb3B0aW9ucwojCkNPTkZJR19QTT15CiMgQ09ORklH
X1BNX0xFR0FDWSBpcyBub3Qgc2V0CiMgQ09ORklHX1BNX0RFQlVHIGlzIG5vdCBzZXQKQ09O
RklHX1BNX1NMRUVQX1NNUD15CkNPTkZJR19QTV9TTEVFUD15CkNPTkZJR19TVVNQRU5EX1NN
UF9QT1NTSUJMRT15CkNPTkZJR19TVVNQRU5EPXkKQ09ORklHX0hJQkVSTkFUSU9OX1NNUF9Q
T1NTSUJMRT15CkNPTkZJR19ISUJFUk5BVElPTj15CkNPTkZJR19QTV9TVERfUEFSVElUSU9O
PSIiCkNPTkZJR19BQ1BJPXkKQ09ORklHX0FDUElfU0xFRVA9eQojIENPTkZJR19BQ1BJX1BS
T0NGUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FDUElfUFJPQ0ZTX1BPV0VSIGlzIG5vdCBzZXQK
Q09ORklHX0FDUElfU1lTRlNfUE9XRVI9eQojIENPTkZJR19BQ1BJX1BST0NfRVZFTlQgaXMg
bm90IHNldApDT05GSUdfQUNQSV9BQz1tCkNPTkZJR19BQ1BJX0JBVFRFUlk9bQpDT05GSUdf
QUNQSV9CVVRUT049bQpDT05GSUdfQUNQSV9WSURFTz1tCkNPTkZJR19BQ1BJX0ZBTj1tCiMg
Q09ORklHX0FDUElfRE9DSyBpcyBub3Qgc2V0CkNPTkZJR19BQ1BJX1BST0NFU1NPUj1tCkNP
TkZJR19BQ1BJX0hPVFBMVUdfQ1BVPXkKQ09ORklHX0FDUElfVEhFUk1BTD1tCiMgQ09ORklH
X0FDUElfQVNVUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FDUElfVE9TSElCQSBpcyBub3Qgc2V0
CkNPTkZJR19BQ1BJX0JMQUNLTElTVF9ZRUFSPTIwMDEKIyBDT05GSUdfQUNQSV9ERUJVRyBp
cyBub3Qgc2V0CkNPTkZJR19BQ1BJX0VDPXkKQ09ORklHX0FDUElfUE9XRVI9eQpDT05GSUdf
QUNQSV9TWVNURU09eQpDT05GSUdfWDg2X1BNX1RJTUVSPXkKQ09ORklHX0FDUElfQ09OVEFJ
TkVSPXkKQ09ORklHX0FDUElfU0JTPW0KIyBDT05GSUdfQVBNIGlzIG5vdCBzZXQKCiMKIyBD
UFUgRnJlcXVlbmN5IHNjYWxpbmcKIwpDT05GSUdfQ1BVX0ZSRVE9eQpDT05GSUdfQ1BVX0ZS
RVFfVEFCTEU9eQojIENPTkZJR19DUFVfRlJFUV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19D
UFVfRlJFUV9TVEFUPXkKIyBDT05GSUdfQ1BVX0ZSRVFfU1RBVF9ERVRBSUxTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ1BVX0ZSRVFfREVGQVVMVF9HT1ZfUEVSRk9STUFOQ0UgaXMgbm90IHNl
dAojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9VU0VSU1BBQ0UgaXMgbm90IHNldApD
T05GSUdfQ1BVX0ZSRVFfREVGQVVMVF9HT1ZfT05ERU1BTkQ9eQojIENPTkZJR19DUFVfRlJF
UV9ERUZBVUxUX0dPVl9DT05TRVJWQVRJVkUgaXMgbm90IHNldApDT05GSUdfQ1BVX0ZSRVFf
R09WX1BFUkZPUk1BTkNFPXkKQ09ORklHX0NQVV9GUkVRX0dPVl9QT1dFUlNBVkU9bQpDT05G
SUdfQ1BVX0ZSRVFfR09WX1VTRVJTUEFDRT1tCkNPTkZJR19DUFVfRlJFUV9HT1ZfT05ERU1B
TkQ9eQpDT05GSUdfQ1BVX0ZSRVFfR09WX0NPTlNFUlZBVElWRT1tCgojCiMgQ1BVRnJlcSBw
cm9jZXNzb3IgZHJpdmVycwojCkNPTkZJR19YODZfQUNQSV9DUFVGUkVRPW0KIyBDT05GSUdf
WDg2X1BPV0VSTk9XX0s2IGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1BPV0VSTk9XX0s3IGlz
IG5vdCBzZXQKIyBDT05GSUdfWDg2X1BPV0VSTk9XX0s4IGlzIG5vdCBzZXQKIyBDT05GSUdf
WDg2X0dYX1NVU1BNT0QgaXMgbm90IHNldAojIENPTkZJR19YODZfU1BFRURTVEVQX0NFTlRS
SU5PIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1NQRUVEU1RFUF9JQ0ggaXMgbm90IHNldAoj
IENPTkZJR19YODZfU1BFRURTVEVQX1NNSSBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9QNF9D
TE9DS01PRCBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9DUFVGUkVRX05GT1JDRTIgaXMgbm90
IHNldAojIENPTkZJR19YODZfTE9OR1JVTiBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9MT05H
SEFVTCBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9FX1BPV0VSU0FWRVIgaXMgbm90IHNldAoK
IwojIHNoYXJlZCBvcHRpb25zCiMKIyBDT05GSUdfWDg2X0FDUElfQ1BVRlJFUV9QUk9DX0lO
VEYgaXMgbm90IHNldAojIENPTkZJR19YODZfU1BFRURTVEVQX0xJQiBpcyBub3Qgc2V0CkNP
TkZJR19DUFVfSURMRT15CkNPTkZJR19DUFVfSURMRV9HT1ZfTEFEREVSPXkKQ09ORklHX0NQ
VV9JRExFX0dPVl9NRU5VPXkKCiMKIyBCdXMgb3B0aW9ucyAoUENJIGV0Yy4pCiMKQ09ORklH
X1BDST15CiMgQ09ORklHX1BDSV9HT0JJT1MgaXMgbm90IHNldAojIENPTkZJR19QQ0lfR09N
TUNPTkZJRyBpcyBub3Qgc2V0CiMgQ09ORklHX1BDSV9HT0RJUkVDVCBpcyBub3Qgc2V0CkNP
TkZJR19QQ0lfR09BTlk9eQpDT05GSUdfUENJX0JJT1M9eQpDT05GSUdfUENJX0RJUkVDVD15
CkNPTkZJR19QQ0lfTU1DT05GSUc9eQpDT05GSUdfUENJX0RPTUFJTlM9eQpDT05GSUdfUENJ
RVBPUlRCVVM9eQpDT05GSUdfUENJRUFFUj15CkNPTkZJR19BUkNIX1NVUFBPUlRTX01TST15
CiMgQ09ORklHX1BDSV9NU0kgaXMgbm90IHNldAojIENPTkZJR19QQ0lfTEVHQUNZIGlzIG5v
dCBzZXQKQ09ORklHX0hUX0lSUT15CkNPTkZJR19JU0FfRE1BX0FQST15CiMgQ09ORklHX0lT
QSBpcyBub3Qgc2V0CiMgQ09ORklHX01DQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NDeDIwMCBp
cyBub3Qgc2V0CkNPTkZJR19LOF9OQj15CiMgQ09ORklHX1BDQ0FSRCBpcyBub3Qgc2V0CiMg
Q09ORklHX0hPVFBMVUdfUENJIGlzIG5vdCBzZXQKCiMKIyBFeGVjdXRhYmxlIGZpbGUgZm9y
bWF0cyAvIEVtdWxhdGlvbnMKIwpDT05GSUdfQklORk1UX0VMRj15CiMgQ09ORklHX0JJTkZN
VF9BT1VUIGlzIG5vdCBzZXQKIyBDT05GSUdfQklORk1UX01JU0MgaXMgbm90IHNldAoKIwoj
IE5ldHdvcmtpbmcKIwpDT05GSUdfTkVUPXkKCiMKIyBOZXR3b3JraW5nIG9wdGlvbnMKIwpD
T05GSUdfUEFDS0VUPXkKQ09ORklHX1BBQ0tFVF9NTUFQPXkKQ09ORklHX1VOSVg9eQpDT05G
SUdfWEZSTT15CkNPTkZJR19YRlJNX1VTRVI9bQojIENPTkZJR19YRlJNX1NVQl9QT0xJQ1kg
aXMgbm90IHNldAojIENPTkZJR19YRlJNX01JR1JBVEUgaXMgbm90IHNldAojIENPTkZJR19O
RVRfS0VZIGlzIG5vdCBzZXQKQ09ORklHX0lORVQ9eQojIENPTkZJR19JUF9NVUxUSUNBU1Qg
aXMgbm90IHNldAojIENPTkZJR19JUF9BRFZBTkNFRF9ST1VURVIgaXMgbm90IHNldApDT05G
SUdfSVBfRklCX0hBU0g9eQojIENPTkZJR19JUF9QTlAgaXMgbm90IHNldAojIENPTkZJR19O
RVRfSVBJUCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9JUEdSRSBpcyBub3Qgc2V0CiMgQ09O
RklHX0FSUEQgaXMgbm90IHNldAojIENPTkZJR19TWU5fQ09PS0lFUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0lORVRfQUggaXMgbm90IHNldAojIENPTkZJR19JTkVUX0VTUCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lORVRfSVBDT01QIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9YRlJNX1RV
Tk5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfVFVOTkVMIGlzIG5vdCBzZXQKQ09ORklH
X0lORVRfWEZSTV9NT0RFX1RSQU5TUE9SVD1tCkNPTkZJR19JTkVUX1hGUk1fTU9ERV9UVU5O
RUw9bQojIENPTkZJR19JTkVUX1hGUk1fTU9ERV9CRUVUIGlzIG5vdCBzZXQKQ09ORklHX0lO
RVRfTFJPPW0KQ09ORklHX0lORVRfRElBRz1tCkNPTkZJR19JTkVUX1RDUF9ESUFHPW0KIyBD
T05GSUdfVENQX0NPTkdfQURWQU5DRUQgaXMgbm90IHNldApDT05GSUdfVENQX0NPTkdfQ1VC
SUM9eQpDT05GSUdfREVGQVVMVF9UQ1BfQ09ORz0iY3ViaWMiCiMgQ09ORklHX1RDUF9NRDVT
SUcgaXMgbm90IHNldAojIENPTkZJR19JUF9WUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lQVjYg
aXMgbm90IHNldAojIENPTkZJR19JTkVUNl9YRlJNX1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09O
RklHX0lORVQ2X1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVFdPUktfU0VDTUFSSyBp
cyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVI9eQojIENPTkZJR19ORVRGSUxURVJfREVCVUcg
aXMgbm90IHNldAoKIwojIENvcmUgTmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24KIwpDT05GSUdf
TkVURklMVEVSX05FVExJTks9bQojIENPTkZJR19ORVRGSUxURVJfTkVUTElOS19RVUVVRSBp
cyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9ORVRMSU5LX0xPRyBpcyBub3Qgc2V0CkNP
TkZJR19ORl9DT05OVFJBQ0tfRU5BQkxFRD1tCkNPTkZJR19ORl9DT05OVFJBQ0s9bQojIENP
TkZJR19ORl9DVF9BQ0NUIGlzIG5vdCBzZXQKIyBDT05GSUdfTkZfQ09OTlRSQUNLX01BUksg
aXMgbm90IHNldAojIENPTkZJR19ORl9DT05OVFJBQ0tfRVZFTlRTIGlzIG5vdCBzZXQKQ09O
RklHX05GX0NUX1BST1RPX0dSRT1tCiMgQ09ORklHX05GX0NUX1BST1RPX1NDVFAgaXMgbm90
IHNldAojIENPTkZJR19ORl9DVF9QUk9UT19VRFBMSVRFIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkZfQ09OTlRSQUNLX0FNQU5EQSBpcyBub3Qgc2V0CkNPTkZJR19ORl9DT05OVFJBQ0tfRlRQ
PW0KIyBDT05GSUdfTkZfQ09OTlRSQUNLX0gzMjMgaXMgbm90IHNldAojIENPTkZJR19ORl9D
T05OVFJBQ0tfSVJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTkZfQ09OTlRSQUNLX05FVEJJT1Nf
TlMgaXMgbm90IHNldApDT05GSUdfTkZfQ09OTlRSQUNLX1BQVFA9bQojIENPTkZJR19ORl9D
T05OVFJBQ0tfU0FORSBpcyBub3Qgc2V0CiMgQ09ORklHX05GX0NPTk5UUkFDS19TSVAgaXMg
bm90IHNldAojIENPTkZJR19ORl9DT05OVFJBQ0tfVEZUUCBpcyBub3Qgc2V0CiMgQ09ORklH
X05GX0NUX05FVExJTksgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX1hUQUJMRVM9bQoj
IENPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0NMQVNTSUZZIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVURklMVEVSX1hUX1RBUkdFVF9NQVJLIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklM
VEVSX1hUX1RBUkdFVF9ORlFVRVVFIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklMVEVSX1hU
X1RBUkdFVF9ORkxPRyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRf
VENQTVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NPTU1FTlQg
aXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfQ09OTkJZVEVTIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NPTk5MSU1JVCBpcyBub3Qgc2V0
CiMgQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9DT05OTUFSSyBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVEZJTFRFUl9YVF9NQVRDSF9DT05OVFJBQ0sgaXMgbm90IHNldAojIENPTkZJR19O
RVRGSUxURVJfWFRfTUFUQ0hfRENDUCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9Y
VF9NQVRDSF9EU0NQIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0VT
UCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9IRUxQRVIgaXMgbm90
IHNldAojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfTEVOR1RIIGlzIG5vdCBzZXQKQ09O
RklHX05FVEZJTFRFUl9YVF9NQVRDSF9MSU1JVD1tCiMgQ09ORklHX05FVEZJTFRFUl9YVF9N
QVRDSF9NQUMgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfTUFSSyBp
cyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9QT0xJQ1kgaXMgbm90IHNl
dAojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfTVVMVElQT1JUIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVURklMVEVSX1hUX01BVENIX1BLVFRZUEUgaXMgbm90IHNldAojIENPTkZJR19O
RVRGSUxURVJfWFRfTUFUQ0hfUVVPVEEgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJf
WFRfTUFUQ0hfUkVBTE0gaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hf
U0NUUCBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU1RBVEU9bQojIENP
TkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU1RBVElTVElDIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX1NUUklORyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRF
Ul9YVF9NQVRDSF9UQ1BNU1MgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJfWFRfTUFU
Q0hfVElNRSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9VMzIgaXMg
bm90IHNldAojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfSEFTSExJTUlUIGlzIG5vdCBz
ZXQKCiMKIyBJUDogTmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24KIwpDT05GSUdfTkZfQ09OTlRS
QUNLX0lQVjQ9bQpDT05GSUdfTkZfQ09OTlRSQUNLX1BST0NfQ09NUEFUPXkKIyBDT05GSUdf
SVBfTkZfUVVFVUUgaXMgbm90IHNldApDT05GSUdfSVBfTkZfSVBUQUJMRVM9bQojIENPTkZJ
R19JUF9ORl9NQVRDSF9JUFJBTkdFIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfTkZfTUFUQ0hf
VE9TIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfTkZfTUFUQ0hfUkVDRU5UIGlzIG5vdCBzZXQK
IyBDT05GSUdfSVBfTkZfTUFUQ0hfRUNOIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfTkZfTUFU
Q0hfQUggaXMgbm90IHNldAojIENPTkZJR19JUF9ORl9NQVRDSF9UVEwgaXMgbm90IHNldAoj
IENPTkZJR19JUF9ORl9NQVRDSF9PV05FUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX05GX01B
VENIX0FERFJUWVBFIGlzIG5vdCBzZXQKQ09ORklHX0lQX05GX0ZJTFRFUj1tCiMgQ09ORklH
X0lQX05GX1RBUkdFVF9SRUpFQ1QgaXMgbm90IHNldAojIENPTkZJR19JUF9ORl9UQVJHRVRf
TE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfTkZfVEFSR0VUX1VMT0cgaXMgbm90IHNldAoj
IENPTkZJR19ORl9OQVQgaXMgbm90IHNldAojIENPTkZJR19JUF9ORl9NQU5HTEUgaXMgbm90
IHNldAojIENPTkZJR19JUF9ORl9SQVcgaXMgbm90IHNldApDT05GSUdfSVBfTkZfQVJQVEFC
TEVTPW0KIyBDT05GSUdfSVBfTkZfQVJQRklMVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBf
TkZfQVJQX01BTkdMRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX0RDQ1AgaXMgbm90IHNldAoj
IENPTkZJR19JUF9TQ1RQIGlzIG5vdCBzZXQKIyBDT05GSUdfVElQQyBpcyBub3Qgc2V0CiMg
Q09ORklHX0FUTSBpcyBub3Qgc2V0CiMgQ09ORklHX0JSSURHRSBpcyBub3Qgc2V0CkNPTkZJ
R19WTEFOXzgwMjFRPW0KIyBDT05GSUdfREVDTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfTExD
MiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQUxLIGlz
IG5vdCBzZXQKIyBDT05GSUdfWDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfTEFQQiBpcyBub3Qg
c2V0CiMgQ09ORklHX0VDT05FVCBpcyBub3Qgc2V0CiMgQ09ORklHX1dBTl9ST1VURVIgaXMg
bm90IHNldAojIENPTkZJR19ORVRfU0NIRUQgaXMgbm90IHNldAoKIwojIE5ldHdvcmsgdGVz
dGluZwojCiMgQ09ORklHX05FVF9QS1RHRU4gaXMgbm90IHNldAojIENPTkZJR19IQU1SQURJ
TyBpcyBub3Qgc2V0CiMgQ09ORklHX0lSREEgaXMgbm90IHNldAojIENPTkZJR19CVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FGX1JYUlBDIGlzIG5vdCBzZXQKCiMKIyBXaXJlbGVzcwojCiMg
Q09ORklHX0NGRzgwMjExIGlzIG5vdCBzZXQKIyBDT05GSUdfV0lSRUxFU1NfRVhUIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUFDODAyMTEgaXMgbm90IHNldAojIENPTkZJR19JRUVFODAyMTEg
aXMgbm90IHNldAojIENPTkZJR19SRktJTEwgaXMgbm90IHNldAojIENPTkZJR19ORVRfOVAg
aXMgbm90IHNldAoKIwojIERldmljZSBEcml2ZXJzCiMKCiMKIyBHZW5lcmljIERyaXZlciBP
cHRpb25zCiMKQ09ORklHX1VFVkVOVF9IRUxQRVJfUEFUSD0iL3NiaW4vaG90cGx1ZyIKQ09O
RklHX1NUQU5EQUxPTkU9eQpDT05GSUdfUFJFVkVOVF9GSVJNV0FSRV9CVUlMRD15CkNPTkZJ
R19GV19MT0FERVI9eQojIENPTkZJR19TWVNfSFlQRVJWSVNPUiBpcyBub3Qgc2V0CkNPTkZJ
R19DT05ORUNUT1I9bQojIENPTkZJR19NVEQgaXMgbm90IHNldAojIENPTkZJR19QQVJQT1JU
IGlzIG5vdCBzZXQKQ09ORklHX1BOUD15CiMgQ09ORklHX1BOUF9ERUJVRyBpcyBub3Qgc2V0
CgojCiMgUHJvdG9jb2xzCiMKQ09ORklHX1BOUEFDUEk9eQpDT05GSUdfQkxLX0RFVj15CiMg
Q09ORklHX0JMS19ERVZfRkQgaXMgbm90IHNldAojIENPTkZJR19CTEtfQ1BRX0RBIGlzIG5v
dCBzZXQKIyBDT05GSUdfQkxLX0NQUV9DSVNTX0RBIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxL
X0RFVl9EQUM5NjAgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1VNRU0gaXMgbm90IHNl
dAojIENPTkZJR19CTEtfREVWX0NPV19DT01NT04gaXMgbm90IHNldApDT05GSUdfQkxLX0RF
Vl9MT09QPXkKQ09ORklHX0JMS19ERVZfQ1JZUFRPTE9PUD1tCiMgQ09ORklHX0JMS19ERVZf
TkJEIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9TWDggaXMgbm90IHNldAojIENPTkZJ
R19CTEtfREVWX1VCIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfUkFNPXkKQ09ORklHX0JM
S19ERVZfUkFNX0NPVU5UPTE2CkNPTkZJR19CTEtfREVWX1JBTV9TSVpFPTQwOTYKQ09ORklH
X0JMS19ERVZfUkFNX0JMT0NLU0laRT0xMDI0CkNPTkZJR19DRFJPTV9QS1RDRFZEPW0KQ09O
RklHX0NEUk9NX1BLVENEVkRfQlVGRkVSUz04CiMgQ09ORklHX0NEUk9NX1BLVENEVkRfV0NB
Q0hFIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBX09WRVJfRVRIIGlzIG5vdCBzZXQKQ09ORklH
X01JU0NfREVWSUNFUz15CiMgQ09ORklHX0lCTV9BU00gaXMgbm90IHNldAojIENPTkZJR19Q
SEFOVE9NIGlzIG5vdCBzZXQKIyBDT05GSUdfRUVQUk9NXzkzQ1g2IGlzIG5vdCBzZXQKIyBD
T05GSUdfU0dJX0lPQzQgaXMgbm90IHNldAojIENPTkZJR19USUZNX0NPUkUgaXMgbm90IHNl
dAojIENPTkZJR19BU1VTX0xBUFRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZVSklUU1VfTEFQ
VE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfTVNJX0xBUFRPUCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NPTllfTEFQVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfVEhJTktQQURfQUNQSSBpcyBub3Qg
c2V0CiMgQ09ORklHX0lERSBpcyBub3Qgc2V0CgojCiMgU0NTSSBkZXZpY2Ugc3VwcG9ydAoj
CiMgQ09ORklHX1JBSURfQVRUUlMgaXMgbm90IHNldApDT05GSUdfU0NTST15CkNPTkZJR19T
Q1NJX0RNQT15CiMgQ09ORklHX1NDU0lfVEdUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9O
RVRMSU5LIGlzIG5vdCBzZXQKQ09ORklHX1NDU0lfUFJPQ19GUz15CgojCiMgU0NTSSBzdXBw
b3J0IHR5cGUgKGRpc2ssIHRhcGUsIENELVJPTSkKIwpDT05GSUdfQkxLX0RFVl9TRD15CiMg
Q09ORklHX0NIUl9ERVZfU1QgaXMgbm90IHNldAojIENPTkZJR19DSFJfREVWX09TU1QgaXMg
bm90IHNldApDT05GSUdfQkxLX0RFVl9TUj15CiMgQ09ORklHX0JMS19ERVZfU1JfVkVORE9S
IGlzIG5vdCBzZXQKQ09ORklHX0NIUl9ERVZfU0c9eQojIENPTkZJR19DSFJfREVWX1NDSCBp
cyBub3Qgc2V0CgojCiMgU29tZSBTQ1NJIGRldmljZXMgKGUuZy4gQ0QganVrZWJveCkgc3Vw
cG9ydCBtdWx0aXBsZSBMVU5zCiMKIyBDT05GSUdfU0NTSV9NVUxUSV9MVU4gaXMgbm90IHNl
dAojIENPTkZJR19TQ1NJX0NPTlNUQU5UUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfTE9H
R0lORyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX1NDQU5fQVNZTkM9eQpDT05GSUdfU0NTSV9X
QUlUX1NDQU49bQoKIwojIFNDU0kgVHJhbnNwb3J0cwojCiMgQ09ORklHX1NDU0lfU1BJX0FU
VFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9GQ19BVFRSUyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NDU0lfSVNDU0lfQVRUUlMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NBU19MSUJT
QVMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NSUF9BVFRSUyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NDU0lfTE9XTEVWRUwgaXMgbm90IHNldApDT05GSUdfQVRBPXkKIyBDT05GSUdfQVRB
X05PTlNUQU5EQVJEIGlzIG5vdCBzZXQKQ09ORklHX0FUQV9BQ1BJPXkKIyBDT05GSUdfU0FU
QV9BSENJIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9TVlcgaXMgbm90IHNldApDT05GSUdf
QVRBX1BJSVg9eQojIENPTkZJR19TQVRBX01WIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9O
ViBpcyBub3Qgc2V0CiMgQ09ORklHX1BEQ19BRE1BIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FU
QV9RU1RPUiBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfUFJPTUlTRSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NBVEFfU1g0IGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9TSUwgaXMgbm90IHNl
dAojIENPTkZJR19TQVRBX1NJTDI0IGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9TSVMgaXMg
bm90IHNldAojIENPTkZJR19TQVRBX1VMSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfVklB
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9WSVRFU1NFIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0FUQV9JTklDMTYyWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQUNQSSBpcyBub3Qgc2V0
CiMgQ09ORklHX1BBVEFfQUxJIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9BTUQgaXMgbm90
IHNldAojIENPTkZJR19QQVRBX0FSVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9BVElJ
WFAgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0NNRDY0MF9QQ0kgaXMgbm90IHNldAojIENP
TkZJR19QQVRBX0NNRDY0WCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQ1M1NTIwIGlzIG5v
dCBzZXQKIyBDT05GSUdfUEFUQV9DUzU1MzAgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0NT
NTUzNSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQ1M1NTM2IGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFUQV9DWVBSRVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9FRkFSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVRBX0dFTkVSSUMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0hQVDM2
NiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSFBUMzdYIGlzIG5vdCBzZXQKIyBDT05GSUdf
UEFUQV9IUFQzWDJOIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9IUFQzWDMgaXMgbm90IHNl
dAojIENPTkZJR19QQVRBX0lUODIxWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSVQ4MjEz
IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9KTUlDUk9OIGlzIG5vdCBzZXQKIyBDT05GSUdf
UEFUQV9UUklGTEVYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9NQVJWRUxMIGlzIG5vdCBz
ZXQKQ09ORklHX1BBVEFfTVBJSVg9eQojIENPTkZJR19QQVRBX09MRFBJSVggaXMgbm90IHNl
dAojIENPTkZJR19QQVRBX05FVENFTEwgaXMgbm90IHNldAojIENPTkZJR19QQVRBX05TODc0
MTAgaXMgbm90IHNldAojIENPTkZJR19QQVRBX05TODc0MTUgaXMgbm90IHNldAojIENPTkZJ
R19QQVRBX09QVEkgaXMgbm90IHNldAojIENPTkZJR19QQVRBX09QVElETUEgaXMgbm90IHNl
dAojIENPTkZJR19QQVRBX1BEQ19PTEQgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1JBRElT
WVMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1JaMTAwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X1BBVEFfU0MxMjAwIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9TRVJWRVJXT1JLUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BBVEFfUERDMjAyN1ggaXMgbm90IHNldAojIENPTkZJR19QQVRB
X1NJTDY4MCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfU0lTIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFUQV9WSUEgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1dJTkJPTkQgaXMgbm90IHNl
dApDT05GSUdfTUQ9eQpDT05GSUdfQkxLX0RFVl9NRD15CiMgQ09ORklHX01EX0xJTkVBUiBp
cyBub3Qgc2V0CiMgQ09ORklHX01EX1JBSUQwIGlzIG5vdCBzZXQKQ09ORklHX01EX1JBSUQx
PXkKIyBDT05GSUdfTURfUkFJRDEwIGlzIG5vdCBzZXQKIyBDT05GSUdfTURfUkFJRDQ1NiBp
cyBub3Qgc2V0CiMgQ09ORklHX01EX01VTFRJUEFUSCBpcyBub3Qgc2V0CiMgQ09ORklHX01E
X0ZBVUxUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfRE0gaXMgbm90IHNldAojIENP
TkZJR19GVVNJT04gaXMgbm90IHNldAoKIwojIElFRUUgMTM5NCAoRmlyZVdpcmUpIHN1cHBv
cnQKIwojIENPTkZJR19GSVJFV0lSRSBpcyBub3Qgc2V0CkNPTkZJR19JRUVFMTM5ND1tCgoj
CiMgU3Vic3lzdGVtIE9wdGlvbnMKIwojIENPTkZJR19JRUVFMTM5NF9WRVJCT1NFREVCVUcg
aXMgbm90IHNldAoKIwojIENvbnRyb2xsZXJzCiMKIyBDT05GSUdfSUVFRTEzOTRfUENJTFlO
WCBpcyBub3Qgc2V0CiMgQ09ORklHX0lFRUUxMzk0X09IQ0kxMzk0IGlzIG5vdCBzZXQKCiMK
IyBQcm90b2NvbHMKIwojIENPTkZJR19JRUVFMTM5NF9TQlAyIGlzIG5vdCBzZXQKIyBDT05G
SUdfSUVFRTEzOTRfRVRIMTM5NF9ST01fRU5UUlkgaXMgbm90IHNldAojIENPTkZJR19JRUVF
MTM5NF9FVEgxMzk0IGlzIG5vdCBzZXQKIyBDT05GSUdfSUVFRTEzOTRfUkFXSU8gaXMgbm90
IHNldApDT05GSUdfSTJPPW0KQ09ORklHX0kyT19MQ1RfTk9USUZZX09OX0NIQU5HRVM9eQpD
T05GSUdfSTJPX0VYVF9BREFQVEVDPXkKQ09ORklHX0kyT19DT05GSUc9bQpDT05GSUdfSTJP
X0NPTkZJR19PTERfSU9DVEw9eQpDT05GSUdfSTJPX0JVUz1tCkNPTkZJR19JMk9fQkxPQ0s9
bQpDT05GSUdfSTJPX1NDU0k9bQpDT05GSUdfSTJPX1BST0M9bQojIENPTkZJR19NQUNJTlRP
U0hfRFJJVkVSUyBpcyBub3Qgc2V0CkNPTkZJR19ORVRERVZJQ0VTPXkKIyBDT05GSUdfTkVU
REVWSUNFU19NVUxUSVFVRVVFIGlzIG5vdCBzZXQKIyBDT05GSUdfRFVNTVkgaXMgbm90IHNl
dAojIENPTkZJR19CT05ESU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfTUFDVkxBTiBpcyBub3Qg
c2V0CiMgQ09ORklHX0VRVUFMSVpFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1RVTiBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZFVEggaXMgbm90IHNldAojIENPTkZJR19ORVRfU0IxMDAwIGlzIG5v
dCBzZXQKIyBDT05GSUdfQVJDTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0VUSEVSTkVU
IGlzIG5vdCBzZXQKQ09ORklHX05FVERFVl8xMDAwPXkKIyBDT05GSUdfQUNFTklDIGlzIG5v
dCBzZXQKIyBDT05GSUdfREwySyBpcyBub3Qgc2V0CiMgQ09ORklHX0UxMDAwIGlzIG5vdCBz
ZXQKQ09ORklHX0UxMDAwRT1tCiMgQ09ORklHX0lQMTAwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X05TODM4MjAgaXMgbm90IHNldAojIENPTkZJR19IQU1BQ0hJIGlzIG5vdCBzZXQKIyBDT05G
SUdfWUVMTE9XRklOIGlzIG5vdCBzZXQKIyBDT05GSUdfUjgxNjkgaXMgbm90IHNldAojIENP
TkZJR19TSVMxOTAgaXMgbm90IHNldAojIENPTkZJR19TS0dFIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0tZMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NLOThMSU4gaXMgbm90IHNldAojIENPTkZJ
R19WSUFfVkVMT0NJVFkgaXMgbm90IHNldAojIENPTkZJR19USUdPTjMgaXMgbm90IHNldAoj
IENPTkZJR19CTlgyIGlzIG5vdCBzZXQKIyBDT05GSUdfUUxBM1hYWCBpcyBub3Qgc2V0CiMg
Q09ORklHX0FUTDEgaXMgbm90IHNldAojIENPTkZJR19ORVRERVZfMTAwMDAgaXMgbm90IHNl
dAojIENPTkZJR19UUiBpcyBub3Qgc2V0CgojCiMgV2lyZWxlc3MgTEFOCiMKIyBDT05GSUdf
V0xBTl9QUkU4MDIxMSBpcyBub3Qgc2V0CiMgQ09ORklHX1dMQU5fODAyMTEgaXMgbm90IHNl
dAoKIwojIFVTQiBOZXR3b3JrIEFkYXB0ZXJzCiMKIyBDT05GSUdfVVNCX0NBVEMgaXMgbm90
IHNldAojIENPTkZJR19VU0JfS0FXRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1BFR0FT
VVMgaXMgbm90IHNldAojIENPTkZJR19VU0JfUlRMODE1MCBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9VU0JORVQgaXMgbm90IHNldAojIENPTkZJR19XQU4gaXMgbm90IHNldAojIENPTkZJ
R19GRERJIGlzIG5vdCBzZXQKIyBDT05GSUdfSElQUEkgaXMgbm90IHNldAojIENPTkZJR19Q
UFAgaXMgbm90IHNldAojIENPTkZJR19TTElQIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0ZD
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0hBUEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUQ09O
U09MRSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVFBPTEwgaXMgbm90IHNldAojIENPTkZJR19O
RVRfUE9MTF9DT05UUk9MTEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSVNETiBpcyBub3Qgc2V0
CiMgQ09ORklHX1BIT05FIGlzIG5vdCBzZXQKCiMKIyBJbnB1dCBkZXZpY2Ugc3VwcG9ydAoj
CkNPTkZJR19JTlBVVD15CiMgQ09ORklHX0lOUFVUX0ZGX01FTUxFU1MgaXMgbm90IHNldAoj
IENPTkZJR19JTlBVVF9QT0xMREVWIGlzIG5vdCBzZXQKCiMKIyBVc2VybGFuZCBpbnRlcmZh
Y2VzCiMKQ09ORklHX0lOUFVUX01PVVNFREVWPXkKIyBDT05GSUdfSU5QVVRfTU9VU0VERVZf
UFNBVVggaXMgbm90IHNldApDT05GSUdfSU5QVVRfTU9VU0VERVZfU0NSRUVOX1g9MTAyNApD
T05GSUdfSU5QVVRfTU9VU0VERVZfU0NSRUVOX1k9NzY4CiMgQ09ORklHX0lOUFVUX0pPWURF
ViBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9FVkRFVj1tCiMgQ09ORklHX0lOUFVUX0VWQlVH
IGlzIG5vdCBzZXQKCiMKIyBJbnB1dCBEZXZpY2UgRHJpdmVycwojCkNPTkZJR19JTlBVVF9L
RVlCT0FSRD15CkNPTkZJR19LRVlCT0FSRF9BVEtCRD15CiMgQ09ORklHX0tFWUJPQVJEX1NV
TktCRCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0xLS0JEIGlzIG5vdCBzZXQKIyBD
T05GSUdfS0VZQk9BUkRfWFRLQkQgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9ORVdU
T04gaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9TVE9XQVdBWSBpcyBub3Qgc2V0CkNP
TkZJR19JTlBVVF9NT1VTRT15CiMgQ09ORklHX01PVVNFX1BTMiBpcyBub3Qgc2V0CiMgQ09O
RklHX01PVVNFX1NFUklBTCBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX0FQUExFVE9VQ0gg
aXMgbm90IHNldAojIENPTkZJR19NT1VTRV9WU1hYWEFBIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5QVVRfSk9ZU1RJQ0sgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9UQUJMRVQgaXMgbm90
IHNldAojIENPTkZJR19JTlBVVF9UT1VDSFNDUkVFTiBpcyBub3Qgc2V0CkNPTkZJR19JTlBV
VF9NSVNDPXkKQ09ORklHX0lOUFVUX1BDU1BLUj1tCiMgQ09ORklHX0lOUFVUX1dJU1RST05f
QlROUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0FUTEFTX0JUTlMgaXMgbm90IHNldAoj
IENPTkZJR19JTlBVVF9BVElfUkVNT1RFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQVRJ
X1JFTU9URTIgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9LRVlTUEFOX1JFTU9URSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOUFVUX1BPV0VSTUFURSBpcyBub3Qgc2V0CiMgQ09ORklHX0lO
UFVUX1lFQUxJTksgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9VSU5QVVQgaXMgbm90IHNl
dAoKIwojIEhhcmR3YXJlIEkvTyBwb3J0cwojCkNPTkZJR19TRVJJTz15CkNPTkZJR19TRVJJ
T19JODA0Mj15CiMgQ09ORklHX1NFUklPX1NFUlBPUlQgaXMgbm90IHNldAojIENPTkZJR19T
RVJJT19DVDgyQzcxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklPX1BDSVBTMiBpcyBub3Qg
c2V0CkNPTkZJR19TRVJJT19MSUJQUzI9eQojIENPTkZJR19TRVJJT19SQVcgaXMgbm90IHNl
dAojIENPTkZJR19HQU1FUE9SVCBpcyBub3Qgc2V0CgojCiMgQ2hhcmFjdGVyIGRldmljZXMK
IwpDT05GSUdfVlQ9eQpDT05GSUdfVlRfQ09OU09MRT15CkNPTkZJR19IV19DT05TT0xFPXkK
IyBDT05GSUdfVlRfSFdfQ09OU09MRV9CSU5ESU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VS
SUFMX05PTlNUQU5EQVJEIGlzIG5vdCBzZXQKCiMKIyBTZXJpYWwgZHJpdmVycwojCiMgQ09O
RklHX1NFUklBTF84MjUwIGlzIG5vdCBzZXQKQ09ORklHX0ZJWF9FQVJMWUNPTl9NRU09eQoK
IwojIE5vbi04MjUwIHNlcmlhbCBwb3J0IHN1cHBvcnQKIwojIENPTkZJR19TRVJJQUxfSlNN
IGlzIG5vdCBzZXQKQ09ORklHX1VOSVg5OF9QVFlTPXkKIyBDT05GSUdfTEVHQUNZX1BUWVMg
aXMgbm90IHNldAojIENPTkZJR19JUE1JX0hBTkRMRVIgaXMgbm90IHNldApDT05GSUdfSFdf
UkFORE9NPXkKQ09ORklHX0hXX1JBTkRPTV9JTlRFTD15CiMgQ09ORklHX0hXX1JBTkRPTV9B
TUQgaXMgbm90IHNldAojIENPTkZJR19IV19SQU5ET01fR0VPREUgaXMgbm90IHNldAojIENP
TkZJR19IV19SQU5ET01fVklBIGlzIG5vdCBzZXQKIyBDT05GSUdfTlZSQU0gaXMgbm90IHNl
dApDT05GSUdfUlRDPXkKIyBDT05GSUdfUjM5NjQgaXMgbm90IHNldAojIENPTkZJR19BUFBM
SUNPTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NPTllQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01X
QVZFIGlzIG5vdCBzZXQKIyBDT05GSUdfUEM4NzM2eF9HUElPIGlzIG5vdCBzZXQKIyBDT05G
SUdfTlNDX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19DUzU1MzVfR1BJTyBpcyBub3Qgc2V0
CiMgQ09ORklHX1JBV19EUklWRVIgaXMgbm90IHNldApDT05GSUdfSFBFVD15CiMgQ09ORklH
X0hQRVRfUlRDX0lSUSBpcyBub3Qgc2V0CkNPTkZJR19IUEVUX01NQVA9eQpDT05GSUdfSEFO
R0NIRUNLX1RJTUVSPXkKIyBDT05GSUdfVENHX1RQTSBpcyBub3Qgc2V0CiMgQ09ORklHX1RF
TENMT0NLIGlzIG5vdCBzZXQKQ09ORklHX0RFVlBPUlQ9eQpDT05GSUdfSTJDPW0KQ09ORklH
X0kyQ19CT0FSRElORk89eQojIENPTkZJR19JMkNfQ0hBUkRFViBpcyBub3Qgc2V0CgojCiMg
STJDIEFsZ29yaXRobXMKIwpDT05GSUdfSTJDX0FMR09CSVQ9bQojIENPTkZJR19JMkNfQUxH
T1BDRiBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19BTEdPUENBIGlzIG5vdCBzZXQKCiMKIyBJ
MkMgSGFyZHdhcmUgQnVzIHN1cHBvcnQKIwojIENPTkZJR19JMkNfQUxJMTUzNSBpcyBub3Qg
c2V0CiMgQ09ORklHX0kyQ19BTEkxNTYzIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0FMSTE1
WDMgaXMgbm90IHNldAojIENPTkZJR19JMkNfQU1ENzU2IGlzIG5vdCBzZXQKIyBDT05GSUdf
STJDX0FNRDgxMTEgaXMgbm90IHNldAojIENPTkZJR19JMkNfSTgwMSBpcyBub3Qgc2V0CiMg
Q09ORklHX0kyQ19JODEwIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1BJSVg0IGlzIG5vdCBz
ZXQKIyBDT05GSUdfSTJDX05GT1JDRTIgaXMgbm90IHNldAojIENPTkZJR19JMkNfT0NPUkVT
IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1BBUlBPUlRfTElHSFQgaXMgbm90IHNldAojIENP
TkZJR19JMkNfUFJPU0FWQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NBVkFHRTQgaXMg
bm90IHNldAojIENPTkZJR19JMkNfU0lNVEVDIGlzIG5vdCBzZXQKIyBDT05GSUdfU0N4MjAw
X0FDQiBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19TSVM1NTk1IGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX1NJUzYzMCBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19TSVM5NlggaXMgbm90IHNl
dAojIENPTkZJR19JMkNfVEFPU19FVk0gaXMgbm90IHNldAojIENPTkZJR19JMkNfU1RVQiBp
cyBub3Qgc2V0CiMgQ09ORklHX0kyQ19USU5ZX1VTQiBpcyBub3Qgc2V0CiMgQ09ORklHX0ky
Q19WSUEgaXMgbm90IHNldAojIENPTkZJR19JMkNfVklBUFJPIGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX1ZPT0RPTzMgaXMgbm90IHNldAoKIwojIE1pc2NlbGxhbmVvdXMgSTJDIENoaXAg
c3VwcG9ydAojCiMgQ09ORklHX1NFTlNPUlNfRFMxMzM3IGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19EUzEzNzQgaXMgbm90IHNldAojIENPTkZJR19EUzE2ODIgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0VFUFJPTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfUENG
ODU3NCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfUENBOTUzOSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfUENGODU5MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFY
Njg3NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVFNMMjU1MCBpcyBub3Qgc2V0CiMg
Q09ORklHX0kyQ19ERUJVR19DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVHX0FM
R08gaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQlVTIGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX0RFQlVHX0NISVAgaXMgbm90IHNldAoKIwojIFNQSSBzdXBwb3J0CiMKIyBDT05G
SUdfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX01BU1RFUiBpcyBub3Qgc2V0CiMgQ09O
RklHX1cxIGlzIG5vdCBzZXQKQ09ORklHX1BPV0VSX1NVUFBMWT15CiMgQ09ORklHX1BPV0VS
X1NVUFBMWV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1BEQV9QT1dFUiBpcyBub3Qgc2V0
CiMgQ09ORklHX0JBVFRFUllfRFMyNzYwIGlzIG5vdCBzZXQKQ09ORklHX0hXTU9OPW0KIyBD
T05GSUdfSFdNT05fVklEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BQklUVUdVUlUg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FCSVRVR1VSVTMgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0FENzQxOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNMTAy
MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNMTAyNSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfQURNMTAyNiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNMTAy
OSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNMTAzMSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfQURNOTI0MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURUNzQ3
MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSzhURU1QIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19BU0IxMDAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FUWFAxIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19EUzE2MjEgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX0k1S19BTUIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0Y3MTgwNUYgaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX0Y3MTg4MkZHIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19GNzUzNzVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GU0NIRVIgaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX0ZTQ1BPUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfRlNDSE1EIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19HTDUxOFNNIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19HTDUyMFNNIGlzIG5vdCBzZXQKQ09ORklHX1NFTlNP
UlNfQ09SRVRFTVA9bQojIENPTkZJR19TRU5TT1JTX0lUODcgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0xNNjMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNNzUgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0xNNzcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X0xNNzggaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNODAgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0xNODMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNODUgaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNODcgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX0xNOTAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNOTIgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0xNOTMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDE2
MTkgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDY2NTAgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX1BDODczNjAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1BDODc0
MjcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1NJUzU1OTUgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0RNRTE3MzcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1NNU0M0
N00xIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19TTVNDNDdNMTkyIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19TTVNDNDdCMzk3IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19USE1DNTAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1ZJQTY4NkEgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX1ZUMTIxMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
VlQ4MjMxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19XODM3ODFEIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19XODM3OTFEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19X
ODM3OTJEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19XODM3OTMgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX1c4M0w3ODVUUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
VzgzNjI3SEYgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4MzYyN0VIRiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfSERBUFMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X0FQUExFU01DIGlzIG5vdCBzZXQKIyBDT05GSUdfSFdNT05fREVCVUdfQ0hJUCBpcyBub3Qg
c2V0CkNPTkZJR19XQVRDSERPRz15CiMgQ09ORklHX1dBVENIRE9HX05PV0FZT1VUIGlzIG5v
dCBzZXQKCiMKIyBXYXRjaGRvZyBEZXZpY2UgRHJpdmVycwojCiMgQ09ORklHX1NPRlRfV0FU
Q0hET0cgaXMgbm90IHNldAojIENPTkZJR19BQ1FVSVJFX1dEVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0FEVkFOVEVDSF9XRFQgaXMgbm90IHNldAojIENPTkZJR19BTElNMTUzNV9XRFQgaXMg
bm90IHNldAojIENPTkZJR19BTElNNzEwMV9XRFQgaXMgbm90IHNldAojIENPTkZJR19TQzUy
MF9XRFQgaXMgbm90IHNldAojIENPTkZJR19FVVJPVEVDSF9XRFQgaXMgbm90IHNldAojIENP
TkZJR19JQjcwMF9XRFQgaXMgbm90IHNldAojIENPTkZJR19JQk1BU1IgaXMgbm90IHNldAoj
IENPTkZJR19XQUZFUl9XRFQgaXMgbm90IHNldAojIENPTkZJR19JNjMwMEVTQl9XRFQgaXMg
bm90IHNldApDT05GSUdfSVRDT19XRFQ9bQojIENPTkZJR19JVENPX1ZFTkRPUl9TVVBQT1JU
IGlzIG5vdCBzZXQKIyBDT05GSUdfSVQ4NzEyRl9XRFQgaXMgbm90IHNldAojIENPTkZJR19T
QzEyMDBfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfUEM4NzQxM19XRFQgaXMgbm90IHNldAoj
IENPTkZJR182MFhYX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NCQzgzNjBfV0RUIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0JDNzI0MF9XRFQgaXMgbm90IHNldAojIENPTkZJR19DUFU1X1dE
VCBpcyBub3Qgc2V0CiMgQ09ORklHX1NNU0MzN0I3ODdfV0RUIGlzIG5vdCBzZXQKIyBDT05G
SUdfVzgzNjI3SEZfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfVzgzNjk3SEZfV0RUIGlzIG5v
dCBzZXQKIyBDT05GSUdfVzgzODc3Rl9XRFQgaXMgbm90IHNldAojIENPTkZJR19XODM5NzdG
X1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX01BQ0haX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NCQ19FUFhfQzNfV0FUQ0hET0cgaXMgbm90IHNldAoKIwojIFBDSS1iYXNlZCBXYXRjaGRv
ZyBDYXJkcwojCiMgQ09ORklHX1BDSVBDV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19X
RFRQQ0kgaXMgbm90IHNldAoKIwojIFVTQi1iYXNlZCBXYXRjaGRvZyBDYXJkcwojCiMgQ09O
RklHX1VTQlBDV0FUQ0hET0cgaXMgbm90IHNldAoKIwojIFNvbmljcyBTaWxpY29uIEJhY2tw
bGFuZQojCkNPTkZJR19TU0JfUE9TU0lCTEU9eQojIENPTkZJR19TU0IgaXMgbm90IHNldAoK
IwojIE11bHRpZnVuY3Rpb24gZGV2aWNlIGRyaXZlcnMKIwojIENPTkZJR19NRkRfU001MDEg
aXMgbm90IHNldAoKIwojIE11bHRpbWVkaWEgZGV2aWNlcwojCkNPTkZJR19WSURFT19ERVY9
bQojIENPTkZJR19WSURFT19WNEwxIGlzIG5vdCBzZXQKQ09ORklHX1ZJREVPX1Y0TDFfQ09N
UEFUPXkKQ09ORklHX1ZJREVPX1Y0TDI9eQpDT05GSUdfVklERU9fQ0FQVFVSRV9EUklWRVJT
PXkKIyBDT05GSUdfVklERU9fQURWX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1ZJREVPX0hF
TFBFUl9DSElQU19BVVRPPXkKIyBDT05GSUdfVklERU9fVklWSSBpcyBub3Qgc2V0CiMgQ09O
RklHX1ZJREVPX1NBQTUyNDZBIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fU0FBNTI0OSBp
cyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1NBQTcxMzQgaXMgbm90IHNldAojIENPTkZJR19W
SURFT19IRVhJVU1fT1JJT04gaXMgbm90IHNldAojIENPTkZJR19WSURFT19IRVhJVU1fR0VN
SU5JIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQ1g4OCBpcyBub3Qgc2V0CiMgQ09ORklH
X1ZJREVPX0NBRkVfQ0NJQyBpcyBub3Qgc2V0CkNPTkZJR19WNExfVVNCX0RSSVZFUlM9eQoj
IENPTkZJR19WSURFT19QVlJVU0IyIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fVVNCVklT
SU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0VUNjFYMjUxIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NOOUMxMDIgaXMgbm90IHNldAojIENPTkZJR19VU0JfWkMwMzAxIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1pSMzY0WFggaXMgbm90IHNldAojIENPTkZJR19SQURJT19BREFQ
VEVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RWQl9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdf
REFCIGlzIG5vdCBzZXQKCiMKIyBHcmFwaGljcyBzdXBwb3J0CiMKQ09ORklHX0FHUD15CiMg
Q09ORklHX0FHUF9BTEkgaXMgbm90IHNldAojIENPTkZJR19BR1BfQVRJIGlzIG5vdCBzZXQK
IyBDT05GSUdfQUdQX0FNRCBpcyBub3Qgc2V0CkNPTkZJR19BR1BfQU1ENjQ9eQpDT05GSUdf
QUdQX0lOVEVMPXkKIyBDT05GSUdfQUdQX05WSURJQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FH
UF9TSVMgaXMgbm90IHNldAojIENPTkZJR19BR1BfU1dPUktTIGlzIG5vdCBzZXQKIyBDT05G
SUdfQUdQX1ZJQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FHUF9FRkZJQ0VPTiBpcyBub3Qgc2V0
CkNPTkZJR19EUk09bQojIENPTkZJR19EUk1fVERGWCBpcyBub3Qgc2V0CiMgQ09ORklHX0RS
TV9SMTI4IGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1JBREVPTiBpcyBub3Qgc2V0CiMgQ09O
RklHX0RSTV9JODEwIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX0k4MzAgaXMgbm90IHNldAoj
IENPTkZJR19EUk1fSTkxNSBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9NR0EgaXMgbm90IHNl
dAojIENPTkZJR19EUk1fU0lTIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1ZJQSBpcyBub3Qg
c2V0CiMgQ09ORklHX0RSTV9TQVZBR0UgaXMgbm90IHNldAojIENPTkZJR19WR0FTVEFURSBp
cyBub3Qgc2V0CkNPTkZJR19WSURFT19PVVRQVVRfQ09OVFJPTD1tCkNPTkZJR19GQj1tCkNP
TkZJR19GSVJNV0FSRV9FRElEPXkKIyBDT05GSUdfRkJfRERDIGlzIG5vdCBzZXQKQ09ORklH
X0ZCX0NGQl9GSUxMUkVDVD1tCkNPTkZJR19GQl9DRkJfQ09QWUFSRUE9bQpDT05GSUdfRkJf
Q0ZCX0lNQUdFQkxJVD1tCiMgQ09ORklHX0ZCX0NGQl9SRVZfUElYRUxTX0lOX0JZVEUgaXMg
bm90IHNldAojIENPTkZJR19GQl9TWVNfRklMTFJFQ1QgaXMgbm90IHNldAojIENPTkZJR19G
Ql9TWVNfQ09QWUFSRUEgaXMgbm90IHNldAojIENPTkZJR19GQl9TWVNfSU1BR0VCTElUIGlz
IG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0ZPUFMgaXMgbm90IHNldApDT05GSUdfRkJfREVG
RVJSRURfSU89eQojIENPTkZJR19GQl9TVkdBTElCIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJf
TUFDTU9ERVMgaXMgbm90IHNldAojIENPTkZJR19GQl9CQUNLTElHSFQgaXMgbm90IHNldApD
T05GSUdfRkJfTU9ERV9IRUxQRVJTPXkKIyBDT05GSUdfRkJfVElMRUJMSVRUSU5HIGlzIG5v
dCBzZXQKCiMKIyBGcmFtZSBidWZmZXIgaGFyZHdhcmUgZHJpdmVycwojCiMgQ09ORklHX0ZC
X0NJUlJVUyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1BNMiBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX0NZQkVSMjAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0FSQyBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZCX1ZHQTE2IGlzIG5vdCBzZXQKQ09ORklHX0ZCX1VWRVNBPW0KIyBDT05GSUdf
RkJfSEVDVUJBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfSEdBIGlzIG5vdCBzZXQKIyBDT05G
SUdfRkJfUzFEMTNYWFggaXMgbm90IHNldAojIENPTkZJR19GQl9OVklESUEgaXMgbm90IHNl
dAojIENPTkZJR19GQl9SSVZBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfSTgxMCBpcyBub3Qg
c2V0CiMgQ09ORklHX0ZCX0xFODA1NzggaXMgbm90IHNldAojIENPTkZJR19GQl9JTlRFTCBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZCX01BVFJPWCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1JB
REVPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0FUWTEyOCBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX0FUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1MzIGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfU0FWQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU0lTIGlzIG5vdCBzZXQKIyBDT05G
SUdfRkJfTkVPTUFHSUMgaXMgbm90IHNldAojIENPTkZJR19GQl9LWVJPIGlzIG5vdCBzZXQK
IyBDT05GSUdfRkJfM0RGWCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1ZPT0RPTzEgaXMgbm90
IHNldAojIENPTkZJR19GQl9WVDg2MjMgaXMgbm90IHNldAojIENPTkZJR19GQl9DWUJMQSBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZCX1RSSURFTlQgaXMgbm90IHNldAojIENPTkZJR19GQl9B
UksgaXMgbm90IHNldAojIENPTkZJR19GQl9QTTMgaXMgbm90IHNldAojIENPTkZJR19GQl9H
RU9ERSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1ZJUlRVQUwgaXMgbm90IHNldApDT05GSUdf
QkFDS0xJR0hUX0xDRF9TVVBQT1JUPXkKQ09ORklHX0xDRF9DTEFTU19ERVZJQ0U9bQpDT05G
SUdfQkFDS0xJR0hUX0NMQVNTX0RFVklDRT1tCiMgQ09ORklHX0JBQ0tMSUdIVF9DT1JHSSBp
cyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9QUk9HRUFSIGlzIG5vdCBzZXQKCiMKIyBE
aXNwbGF5IGRldmljZSBzdXBwb3J0CiMKQ09ORklHX0RJU1BMQVlfU1VQUE9SVD1tCgojCiMg
RGlzcGxheSBoYXJkd2FyZSBkcml2ZXJzCiMKCiMKIyBDb25zb2xlIGRpc3BsYXkgZHJpdmVy
IHN1cHBvcnQKIwpDT05GSUdfVkdBX0NPTlNPTEU9eQpDT05GSUdfVkdBQ09OX1NPRlRfU0NS
T0xMQkFDSz15CkNPTkZJR19WR0FDT05fU09GVF9TQ1JPTExCQUNLX1NJWkU9MTI4CkNPTkZJ
R19WSURFT19TRUxFQ1Q9eQpDT05GSUdfRFVNTVlfQ09OU09MRT15CkNPTkZJR19GUkFNRUJV
RkZFUl9DT05TT0xFPW0KIyBDT05GSUdfRlJBTUVCVUZGRVJfQ09OU09MRV9ERVRFQ1RfUFJJ
TUFSWSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZSQU1FQlVGRkVSX0NPTlNPTEVfUk9UQVRJT04g
aXMgbm90IHNldAojIENPTkZJR19GT05UUyBpcyBub3Qgc2V0CkNPTkZJR19GT05UXzh4OD15
CkNPTkZJR19GT05UXzh4MTY9eQpDT05GSUdfTE9HTz15CkNPTkZJR19MT0dPX0xJTlVYX01P
Tk89eQpDT05GSUdfTE9HT19MSU5VWF9WR0ExNj15CkNPTkZJR19MT0dPX0xJTlVYX0NMVVQy
MjQ9eQoKIwojIFNvdW5kCiMKQ09ORklHX1NPVU5EPW0KCiMKIyBBZHZhbmNlZCBMaW51eCBT
b3VuZCBBcmNoaXRlY3R1cmUKIwpDT05GSUdfU05EPW0KQ09ORklHX1NORF9USU1FUj1tCkNP
TkZJR19TTkRfUENNPW0KQ09ORklHX1NORF9TRVFVRU5DRVI9bQojIENPTkZJR19TTkRfU0VR
X0RVTU1ZIGlzIG5vdCBzZXQKQ09ORklHX1NORF9PU1NFTVVMPXkKQ09ORklHX1NORF9NSVhF
Ul9PU1M9bQpDT05GSUdfU05EX1BDTV9PU1M9bQpDT05GSUdfU05EX1BDTV9PU1NfUExVR0lO
Uz15CkNPTkZJR19TTkRfU0VRVUVOQ0VSX09TUz15CkNPTkZJR19TTkRfUlRDVElNRVI9bQpD
T05GSUdfU05EX1NFUV9SVENUSU1FUl9ERUZBVUxUPXkKQ09ORklHX1NORF9EWU5BTUlDX01J
Tk9SUz15CiMgQ09ORklHX1NORF9TVVBQT1JUX09MRF9BUEkgaXMgbm90IHNldAojIENPTkZJ
R19TTkRfVkVSQk9TRV9QUk9DRlMgaXMgbm90IHNldAojIENPTkZJR19TTkRfVkVSQk9TRV9Q
UklOVEsgaXMgbm90IHNldAojIENPTkZJR19TTkRfREVCVUcgaXMgbm90IHNldAoKIwojIEdl
bmVyaWMgZGV2aWNlcwojCiMgQ09ORklHX1NORF9EVU1NWSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9WSVJNSURJIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX01UUEFWIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX1NFUklBTF9VMTY1NTAgaXMgbm90IHNldAojIENPTkZJR19TTkRfTVBV
NDAxIGlzIG5vdCBzZXQKCiMKIyBQQ0kgZGV2aWNlcwojCiMgQ09ORklHX1NORF9BRDE4ODkg
aXMgbm90IHNldAojIENPTkZJR19TTkRfQUxTMzAwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0FMUzQwMDAgaXMgbm90IHNldAojIENPTkZJR19TTkRfQUxJNTQ1MSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9BVElJWFAgaXMgbm90IHNldAojIENPTkZJR19TTkRfQVRJSVhQX01PREVN
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FVODgxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9BVTg4MjAgaXMgbm90IHNldAojIENPTkZJR19TTkRfQVU4ODMwIGlzIG5vdCBzZXQKIyBD
T05GSUdfU05EX0FaVDMzMjggaXMgbm90IHNldAojIENPTkZJR19TTkRfQlQ4N1ggaXMgbm90
IHNldAojIENPTkZJR19TTkRfQ0EwMTA2IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0NNSVBD
SSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9DUzQyODEgaXMgbm90IHNldAojIENPTkZJR19T
TkRfQ1M0NlhYIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0NTNTUzMCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9DUzU1MzVBVURJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9EQVJMQTIw
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0dJTkEyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9MQVlMQTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0RBUkxBMjQgaXMgbm90IHNldAoj
IENPTkZJR19TTkRfR0lOQTI0IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0xBWUxBMjQgaXMg
bm90IHNldAojIENPTkZJR19TTkRfTU9OQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9NSUEg
aXMgbm90IHNldAojIENPTkZJR19TTkRfRUNITzNHIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0lORElHTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9JTkRJR09JTyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9JTkRJR09ESiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9FTVUxMEsxIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX0VNVTEwSzFYIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0VOUzEzNzAgaXMgbm90IHNldAojIENPTkZJR19TTkRfRU5TMTM3MSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9FUzE5MzggaXMgbm90IHNldAojIENPTkZJR19TTkRfRVMxOTY4IGlzIG5v
dCBzZXQKIyBDT05GSUdfU05EX0ZNODAxIGlzIG5vdCBzZXQKQ09ORklHX1NORF9IREFfSU5U
RUw9bQojIENPTkZJR19TTkRfSERBX0hXREVQIGlzIG5vdCBzZXQKQ09ORklHX1NORF9IREFf
Q09ERUNfUkVBTFRFSz15CkNPTkZJR19TTkRfSERBX0NPREVDX0FOQUxPRz15CkNPTkZJR19T
TkRfSERBX0NPREVDX1NJR01BVEVMPXkKQ09ORklHX1NORF9IREFfQ09ERUNfVklBPXkKQ09O
RklHX1NORF9IREFfQ09ERUNfQVRJSERNST15CkNPTkZJR19TTkRfSERBX0NPREVDX0NPTkVY
QU5UPXkKQ09ORklHX1NORF9IREFfQ09ERUNfQ01FRElBPXkKQ09ORklHX1NORF9IREFfQ09E
RUNfU0kzMDU0PXkKQ09ORklHX1NORF9IREFfR0VORVJJQz15CiMgQ09ORklHX1NORF9IREFf
UE9XRVJfU0FWRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9IRFNQIGlzIG5vdCBzZXQKIyBD
T05GSUdfU05EX0hEU1BNIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0lDRTE3MTIgaXMgbm90
IHNldAojIENPTkZJR19TTkRfSUNFMTcyNCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9JTlRF
TDhYMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9JTlRFTDhYME0gaXMgbm90IHNldAojIENP
TkZJR19TTkRfS09SRzEyMTIgaXMgbm90IHNldAojIENPTkZJR19TTkRfTUFFU1RSTzMgaXMg
bm90IHNldAojIENPTkZJR19TTkRfTUlYQVJUIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX05N
MjU2IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1BDWEhSIGlzIG5vdCBzZXQKIyBDT05GSUdf
U05EX1JJUFRJREUgaXMgbm90IHNldAojIENPTkZJR19TTkRfUk1FMzIgaXMgbm90IHNldAoj
IENPTkZJR19TTkRfUk1FOTYgaXMgbm90IHNldAojIENPTkZJR19TTkRfUk1FOTY1MiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NORF9TT05JQ1ZJQkVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X1RSSURFTlQgaXMgbm90IHNldAojIENPTkZJR19TTkRfVklBODJYWCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9WSUE4MlhYX01PREVNIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1ZYMjIy
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1lNRlBDSSBpcyBub3Qgc2V0CgojCiMgVVNCIGRl
dmljZXMKIwojIENPTkZJR19TTkRfVVNCX0FVRElPIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X1VTQl9VU1gyWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9VU0JfQ0FJQVEgaXMgbm90IHNl
dAoKIwojIFN5c3RlbSBvbiBDaGlwIGF1ZGlvIHN1cHBvcnQKIwpDT05GSUdfU05EX1NPQz1t
CgojCiMgU29DIEF1ZGlvIHN1cHBvcnQgZm9yIFN1cGVySAojCgojCiMgT3BlbiBTb3VuZCBT
eXN0ZW0KIwojIENPTkZJR19TT1VORF9QUklNRSBpcyBub3Qgc2V0CkNPTkZJR19ISURfU1VQ
UE9SVD15CkNPTkZJR19ISUQ9eQojIENPTkZJR19ISURfREVCVUcgaXMgbm90IHNldAojIENP
TkZJR19ISURSQVcgaXMgbm90IHNldAoKIwojIFVTQiBJbnB1dCBEZXZpY2VzCiMKQ09ORklH
X1VTQl9ISUQ9eQojIENPTkZJR19VU0JfSElESU5QVVRfUE9XRVJCT09LIGlzIG5vdCBzZXQK
IyBDT05GSUdfSElEX0ZGIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9ISURERVY9eQpDT05GSUdf
VVNCX1NVUFBPUlQ9eQpDT05GSUdfVVNCX0FSQ0hfSEFTX0hDRD15CkNPTkZJR19VU0JfQVJD
SF9IQVNfT0hDST15CkNPTkZJR19VU0JfQVJDSF9IQVNfRUhDST15CkNPTkZJR19VU0I9eQoj
IENPTkZJR19VU0JfREVCVUcgaXMgbm90IHNldAoKIwojIE1pc2NlbGxhbmVvdXMgVVNCIG9w
dGlvbnMKIwpDT05GSUdfVVNCX0RFVklDRUZTPXkKIyBDT05GSUdfVVNCX0RFVklDRV9DTEFT
UyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9EWU5BTUlDX01JTk9SUyBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9TVVNQRU5EIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1BFUlNJU1QgaXMg
bm90IHNldAojIENPTkZJR19VU0JfT1RHIGlzIG5vdCBzZXQKCiMKIyBVU0IgSG9zdCBDb250
cm9sbGVyIERyaXZlcnMKIwpDT05GSUdfVVNCX0VIQ0lfSENEPW0KQ09ORklHX1VTQl9FSENJ
X1NQTElUX0lTTz15CkNPTkZJR19VU0JfRUhDSV9ST09UX0hVQl9UVD15CkNPTkZJR19VU0Jf
RUhDSV9UVF9ORVdTQ0hFRD15CiMgQ09ORklHX1VTQl9JU1AxMTZYX0hDRCBpcyBub3Qgc2V0
CkNPTkZJR19VU0JfT0hDSV9IQ0Q9bQojIENPTkZJR19VU0JfT0hDSV9CSUdfRU5ESUFOX0RF
U0MgaXMgbm90IHNldAojIENPTkZJR19VU0JfT0hDSV9CSUdfRU5ESUFOX01NSU8gaXMgbm90
IHNldApDT05GSUdfVVNCX09IQ0lfTElUVExFX0VORElBTj15CkNPTkZJR19VU0JfVUhDSV9I
Q0Q9bQojIENPTkZJR19VU0JfU0w4MTFfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1I4
QTY2NTk3X0hDRCBpcyBub3Qgc2V0CgojCiMgVVNCIERldmljZSBDbGFzcyBkcml2ZXJzCiMK
IyBDT05GSUdfVVNCX0FDTSBpcyBub3Qgc2V0CkNPTkZJR19VU0JfUFJJTlRFUj1tCgojCiMg
Tk9URTogVVNCX1NUT1JBR0UgZW5hYmxlcyBTQ1NJLCBhbmQgJ1NDU0kgZGlzayBzdXBwb3J0
JwojCgojCiMgbWF5IGFsc28gYmUgbmVlZGVkOyBzZWUgVVNCX1NUT1JBR0UgSGVscCBmb3Ig
bW9yZSBpbmZvcm1hdGlvbgojCkNPTkZJR19VU0JfU1RPUkFHRT1tCiMgQ09ORklHX1VTQl9T
VE9SQUdFX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfREFUQUZBQiBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0ZSRUVDT00gaXMgbm90IHNldAojIENP
TkZJR19VU0JfU1RPUkFHRV9JU0QyMDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFH
RV9EUENNIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfVVNCQVQgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfU1RPUkFHRV9TRERSMDkgaXMgbm90IHNldAojIENPTkZJR19VU0Jf
U1RPUkFHRV9TRERSNTUgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9KVU1QU0hP
VCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0FMQVVEQSBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9TVE9SQUdFX0tBUk1BIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0xJQlVT
VUFMIGlzIG5vdCBzZXQKCiMKIyBVU0IgSW1hZ2luZyBkZXZpY2VzCiMKIyBDT05GSUdfVVNC
X01EQzgwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NSUNST1RFSyBpcyBub3Qgc2V0CkNP
TkZJR19VU0JfTU9OPXkKCiMKIyBVU0IgcG9ydCBkcml2ZXJzCiMKCiMKIyBVU0IgU2VyaWFs
IENvbnZlcnRlciBzdXBwb3J0CiMKQ09ORklHX1VTQl9TRVJJQUw9bQojIENPTkZJR19VU0Jf
U0VSSUFMX0dFTkVSSUMgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0FJUkNBQkxF
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9BSVJQUklNRSBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9TRVJJQUxfQVJLMzExNiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJ
QUxfQkVMS0lOIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9DSDM0MSBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfV0hJVEVIRUFUIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX1NFUklBTF9ESUdJX0FDQ0VMRVBPUlQgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VS
SUFMX0NQMjEwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfQ1lQUkVTU19NOCBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfRU1QRUcgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfU0VSSUFMX0ZURElfU0lPIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9G
VU5TT0ZUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9WSVNPUiBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9TRVJJQUxfSVBBUSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJ
QUxfSVIgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0VER0VQT1JUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1NFUklBTF9FREdFUE9SVF9USSBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9TRVJJQUxfR0FSTUlOIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9JUFcg
aXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU5fUERBIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1NFUklBTF9LRVlTUEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NF
UklBTF9LTFNJIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9LT0JJTF9TQ1QgaXMg
bm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX01DVF9VMjMyIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NFUklBTF9NT1M3NzIwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9N
T1M3ODQwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9OQVZNQU4gaXMgbm90IHNl
dAojIENPTkZJR19VU0JfU0VSSUFMX1BMMjMwMyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9T
RVJJQUxfT1RJNjg1OCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfSFA0WCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfU0FGRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9TRVJJQUxfU0lFUlJBV0lSRUxFU1MgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFM
X1RJIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9DWUJFUkpBQ0sgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfU0VSSUFMX1hJUkNPTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9T
RVJJQUxfT1BUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9PTU5JTkVUIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9ERUJVRyBpcyBub3Qgc2V0CgojCiMgVVNC
IE1pc2NlbGxhbmVvdXMgZHJpdmVycwojCiMgQ09ORklHX1VTQl9FTUk2MiBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9FTUkyNiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9BRFVUVVggaXMg
bm90IHNldAojIENPTkZJR19VU0JfQVVFUlNXQUxEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X1JJTzUwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRUdPVE9XRVIgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfTENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0JFUlJZX0NIQVJHRSBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRUQgaXMgbm90IHNldAojIENPTkZJR19VU0JfQ1lQ
UkVTU19DWTdDNjMgaXMgbm90IHNldAojIENPTkZJR19VU0JfQ1lUSEVSTSBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9QSElER0VUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lETU9VU0Ug
aXMgbm90IHNldAojIENPTkZJR19VU0JfRlRESV9FTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0FQUExFRElTUExBWSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TSVNVU0JWR0EgaXMg
bm90IHNldAojIENPTkZJR19VU0JfTEQgaXMgbm90IHNldAojIENPTkZJR19VU0JfVFJBTkNF
VklCUkFUT1IgaXMgbm90IHNldAojIENPTkZJR19VU0JfSU9XQVJSSU9SIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1RFU1QgaXMgbm90IHNldAoKIwojIFVTQiBEU0wgbW9kZW0gc3VwcG9y
dAojCgojCiMgVVNCIEdhZGdldCBTdXBwb3J0CiMKIyBDT05GSUdfVVNCX0dBREdFVCBpcyBu
b3Qgc2V0CkNPTkZJR19NTUM9bQojIENPTkZJR19NTUNfREVCVUcgaXMgbm90IHNldAojIENP
TkZJR19NTUNfVU5TQUZFX1JFU1VNRSBpcyBub3Qgc2V0CgojCiMgTU1DL1NEIENhcmQgRHJp
dmVycwojCkNPTkZJR19NTUNfQkxPQ0s9bQpDT05GSUdfTU1DX0JMT0NLX0JPVU5DRT15CiMg
Q09ORklHX1NESU9fVUFSVCBpcyBub3Qgc2V0CgojCiMgTU1DL1NEIEhvc3QgQ29udHJvbGxl
ciBEcml2ZXJzCiMKIyBDT05GSUdfTU1DX1NESENJIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1D
X1dCU0QgaXMgbm90IHNldAojIENPTkZJR19NTUNfVElGTV9TRCBpcyBub3Qgc2V0CkNPTkZJ
R19ORVdfTEVEUz15CkNPTkZJR19MRURTX0NMQVNTPW0KCiMKIyBMRUQgZHJpdmVycwojCgoj
CiMgTEVEIFRyaWdnZXJzCiMKQ09ORklHX0xFRFNfVFJJR0dFUlM9eQpDT05GSUdfTEVEU19U
UklHR0VSX1RJTUVSPW0KQ09ORklHX0xFRFNfVFJJR0dFUl9IRUFSVEJFQVQ9bQojIENPTkZJ
R19JTkZJTklCQU5EIGlzIG5vdCBzZXQKIyBDT05GSUdfRURBQyBpcyBub3Qgc2V0CkNPTkZJ
R19SVENfTElCPXkKQ09ORklHX1JUQ19DTEFTUz15CkNPTkZJR19SVENfSENUT1NZUz15CkNP
TkZJR19SVENfSENUT1NZU19ERVZJQ0U9InJ0YzAiCiMgQ09ORklHX1JUQ19ERUJVRyBpcyBu
b3Qgc2V0CgojCiMgUlRDIGludGVyZmFjZXMKIwpDT05GSUdfUlRDX0lOVEZfU1lTRlM9eQpD
T05GSUdfUlRDX0lOVEZfUFJPQz15CkNPTkZJR19SVENfSU5URl9ERVY9eQojIENPTkZJR19S
VENfSU5URl9ERVZfVUlFX0VNVUwgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1RFU1Qg
aXMgbm90IHNldAoKIwojIEkyQyBSVEMgZHJpdmVycwojCiMgQ09ORklHX1JUQ19EUlZfRFMx
MzA3IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzEzNzQgaXMgbm90IHNldAojIENP
TkZJR19SVENfRFJWX0RTMTY3MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTUFYNjkw
MCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlM1QzM3MiBpcyBub3Qgc2V0CiMgQ09O
RklHX1JUQ19EUlZfSVNMMTIwOCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfWDEyMDUg
aXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1BDRjg1NjMgaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX1BDRjg1ODMgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX000MVQ4MCBp
cyBub3Qgc2V0CgojCiMgU1BJIFJUQyBkcml2ZXJzCiMKCiMKIyBQbGF0Zm9ybSBSVEMgZHJp
dmVycwojCkNPTkZJR19SVENfRFJWX0NNT1M9eQojIENPTkZJR19SVENfRFJWX0RTMTU1MyBp
cyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfU1RLMTdUQTggaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX0RTMTc0MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTTQ4VDg2IGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NNDhUNTkgaXMgbm90IHNldAojIENPTkZJR19S
VENfRFJWX1YzMDIwIGlzIG5vdCBzZXQKCiMKIyBvbi1DUFUgUlRDIGRyaXZlcnMKIwpDT05G
SUdfRE1BREVWSUNFUz15CgojCiMgRE1BIERldmljZXMKIwpDT05GSUdfSU5URUxfSU9BVERN
QT15CkNPTkZJR19ETUFfRU5HSU5FPXkKCiMKIyBETUEgQ2xpZW50cwojCiMgQ09ORklHX05F
VF9ETUEgaXMgbm90IHNldApDT05GSUdfRENBPXkKIyBDT05GSUdfVklSVFVBTElaQVRJT04g
aXMgbm90IHNldAoKIwojIFVzZXJzcGFjZSBJL08KIwojIENPTkZJR19VSU8gaXMgbm90IHNl
dAoKIwojIEZpcm13YXJlIERyaXZlcnMKIwojIENPTkZJR19FREQgaXMgbm90IHNldAojIENP
TkZJR19ERUxMX1JCVSBpcyBub3Qgc2V0CiMgQ09ORklHX0RDREJBUyBpcyBub3Qgc2V0CkNP
TkZJR19ETUlJRD15CgojCiMgRmlsZSBzeXN0ZW1zCiMKQ09ORklHX0VYVDJfRlM9bQojIENP
TkZJR19FWFQyX0ZTX1hBVFRSIGlzIG5vdCBzZXQKIyBDT05GSUdfRVhUMl9GU19YSVAgaXMg
bm90IHNldApDT05GSUdfRVhUM19GUz1tCkNPTkZJR19FWFQzX0ZTX1hBVFRSPXkKIyBDT05G
SUdfRVhUM19GU19QT1NJWF9BQ0wgaXMgbm90IHNldAojIENPTkZJR19FWFQzX0ZTX1NFQ1VS
SVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfRVhUNERFVl9GUyBpcyBub3Qgc2V0CkNPTkZJR19K
QkQ9bQpDT05GSUdfRlNfTUJDQUNIRT1tCiMgQ09ORklHX1JFSVNFUkZTX0ZTIGlzIG5vdCBz
ZXQKQ09ORklHX0pGU19GUz15CkNPTkZJR19KRlNfUE9TSVhfQUNMPXkKQ09ORklHX0pGU19T
RUNVUklUWT15CiMgQ09ORklHX0pGU19ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0pGU19T
VEFUSVNUSUNTIGlzIG5vdCBzZXQKQ09ORklHX0ZTX1BPU0lYX0FDTD15CiMgQ09ORklHX1hG
U19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0dGUzJfRlMgaXMgbm90IHNldAojIENPTkZJR19P
Q0ZTMl9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX01JTklYX0ZTIGlzIG5vdCBzZXQKIyBDT05G
SUdfUk9NRlNfRlMgaXMgbm90IHNldApDT05GSUdfSU5PVElGWT15CkNPTkZJR19JTk9USUZZ
X1VTRVI9eQojIENPTkZJR19RVU9UQSBpcyBub3Qgc2V0CkNPTkZJR19ETk9USUZZPXkKIyBD
T05GSUdfQVVUT0ZTX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0FVVE9GUzRfRlM9eQpDT05GSUdf
RlVTRV9GUz15CkNPTkZJR19HRU5FUklDX0FDTD15CgojCiMgQ0QtUk9NL0RWRCBGaWxlc3lz
dGVtcwojCkNPTkZJR19JU085NjYwX0ZTPW0KQ09ORklHX0pPTElFVD15CkNPTkZJR19aSVNP
RlM9eQpDT05GSUdfVURGX0ZTPW0KQ09ORklHX1VERl9OTFM9eQoKIwojIERPUy9GQVQvTlQg
RmlsZXN5c3RlbXMKIwpDT05GSUdfRkFUX0ZTPW0KQ09ORklHX01TRE9TX0ZTPW0KQ09ORklH
X1ZGQVRfRlM9bQpDT05GSUdfRkFUX0RFRkFVTFRfQ09ERVBBR0U9NDM3CkNPTkZJR19GQVRf
REVGQVVMVF9JT0NIQVJTRVQ9Imlzbzg4NTktMSIKQ09ORklHX05URlNfRlM9bQojIENPTkZJ
R19OVEZTX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX05URlNfUlc9eQoKIwojIFBzZXVkbyBm
aWxlc3lzdGVtcwojCkNPTkZJR19QUk9DX0ZTPXkKQ09ORklHX1BST0NfS0NPUkU9eQpDT05G
SUdfUFJPQ19TWVNDVEw9eQpDT05GSUdfU1lTRlM9eQpDT05GSUdfVE1QRlM9eQpDT05GSUdf
VE1QRlNfUE9TSVhfQUNMPXkKIyBDT05GSUdfSFVHRVRMQkZTIGlzIG5vdCBzZXQKIyBDT05G
SUdfSFVHRVRMQl9QQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09ORklHRlNfRlMgaXMgbm90
IHNldAoKIwojIE1pc2NlbGxhbmVvdXMgZmlsZXN5c3RlbXMKIwojIENPTkZJR19BREZTX0ZT
IGlzIG5vdCBzZXQKIyBDT05GSUdfQUZGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hGU19G
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0hGU1BMVVNfRlMgaXMgbm90IHNldAojIENPTkZJR19C
RUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQkZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdf
RUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JBTUZTIGlzIG5vdCBzZXQKIyBDT05GSUdf
U1FVQVNIRlMgaXMgbm90IHNldAojIENPTkZJR19WWEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05G
SUdfSFBGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1FOWDRGU19GUyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NZU1ZfRlMgaXMgbm90IHNldAojIENPTkZJR19VRlNfRlMgaXMgbm90IHNldAoj
IENPTkZJR19ORVRXT1JLX0ZJTEVTWVNURU1TIGlzIG5vdCBzZXQKCiMKIyBQYXJ0aXRpb24g
VHlwZXMKIwpDT05GSUdfUEFSVElUSU9OX0FEVkFOQ0VEPXkKIyBDT05GSUdfQUNPUk5fUEFS
VElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfT1NGX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMg
Q09ORklHX0FNSUdBX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQVJJX1BBUlRJ
VElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX01BQ19QQVJUSVRJT04gaXMgbm90IHNldApDT05G
SUdfTVNET1NfUEFSVElUSU9OPXkKIyBDT05GSUdfQlNEX0RJU0tMQUJFTCBpcyBub3Qgc2V0
CiMgQ09ORklHX01JTklYX1NVQlBBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NPTEFS
SVNfWDg2X1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1VOSVhXQVJFX0RJU0tMQUJF
TCBpcyBub3Qgc2V0CkNPTkZJR19MRE1fUEFSVElUSU9OPXkKIyBDT05GSUdfTERNX0RFQlVH
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0dJX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklH
X1VMVFJJWF9QQVJUSVRJT04gaXMgbm90IHNldAojIENPTkZJR19TVU5fUEFSVElUSU9OIGlz
IG5vdCBzZXQKIyBDT05GSUdfS0FSTUFfUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdf
RUZJX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NZU1Y2OF9QQVJUSVRJT04gaXMg
bm90IHNldApDT05GSUdfTkxTPXkKQ09ORklHX05MU19ERUZBVUxUPSJVVEYtOCIKQ09ORklH
X05MU19DT0RFUEFHRV80Mzc9eQojIENPTkZJR19OTFNfQ09ERVBBR0VfNzM3IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzc3NSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19D
T0RFUEFHRV84NTAgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODUyIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1NSBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19DT0RFUEFHRV84NTcgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYwIGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MSBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19DT0RFUEFHRV84NjIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYz
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2NCBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19DT0RFUEFHRV84NjUgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0Vf
ODY2IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2OSBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19DT0RFUEFHRV85MzYgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBB
R0VfOTUwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzkzMiBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19DT0RFUEFHRV85NDkgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09E
RVBBR0VfODc0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfOCBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19DT0RFUEFHRV8xMjUwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NP
REVQQUdFXzEyNTEgaXMgbm90IHNldApDT05GSUdfTkxTX0FTQ0lJPW0KQ09ORklHX05MU19J
U084ODU5XzE9bQojIENPTkZJR19OTFNfSVNPODg1OV8yIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkxTX0lTTzg4NTlfMyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzQgaXMgbm90
IHNldApDT05GSUdfTkxTX0lTTzg4NTlfNT1tCiMgQ09ORklHX05MU19JU084ODU5XzYgaXMg
bm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV83IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxT
X0lTTzg4NTlfOSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzEzIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMTQgaXMgbm90IHNldApDT05GSUdfTkxTX0lTTzg4
NTlfMTU9bQpDT05GSUdfTkxTX0tPSThfUj1tCiMgQ09ORklHX05MU19LT0k4X1UgaXMgbm90
IHNldApDT05GSUdfTkxTX1VURjg9eQojIENPTkZJR19ETE0gaXMgbm90IHNldAojIENPTkZJ
R19JTlNUUlVNRU5UQVRJT04gaXMgbm90IHNldAoKIwojIEtlcm5lbCBoYWNraW5nCiMKQ09O
RklHX1RSQUNFX0lSUUZMQUdTX1NVUFBPUlQ9eQojIENPTkZJR19QUklOVEtfVElNRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0VOQUJMRV9XQVJOX0RFUFJFQ0FURUQgaXMgbm90IHNldAojIENP
TkZJR19FTkFCTEVfTVVTVF9DSEVDSyBpcyBub3Qgc2V0CiMgQ09ORklHX01BR0lDX1NZU1JR
IGlzIG5vdCBzZXQKIyBDT05GSUdfVU5VU0VEX1NZTUJPTFMgaXMgbm90IHNldAojIENPTkZJ
R19ERUJVR19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hFQURFUlNfQ0hFQ0sgaXMgbm90IHNl
dAojIENPTkZJR19ERUJVR19LRVJORUwgaXMgbm90IHNldAojIENPTkZJR19TTFVCX0RFQlVH
X09OIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX0JVR1ZFUkJPU0U9eQojIENPTkZJR19TQU1Q
TEVTIGlzIG5vdCBzZXQKQ09ORklHX0VBUkxZX1BSSU5USz15CkNPTkZJR19YODZfRklORF9T
TVBfQ09ORklHPXkKQ09ORklHX1g4Nl9NUFBBUlNFPXkKQ09ORklHX0RPVUJMRUZBVUxUPXkK
CiMKIyBTZWN1cml0eSBvcHRpb25zCiMKIyBDT05GSUdfS0VZUyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFQ1VSSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VDVVJJVFlfRklMRV9DQVBBQklM
SVRJRVMgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPPXkKQ09ORklHX0NSWVBUT19BTEdBUEk9
bQpDT05GSUdfQ1JZUFRPX0FCTEtDSVBIRVI9bQpDT05GSUdfQ1JZUFRPX0FFQUQ9bQpDT05G
SUdfQ1JZUFRPX0JMS0NJUEhFUj1tCkNPTkZJR19DUllQVE9fSEFTSD1tCkNPTkZJR19DUllQ
VE9fTUFOQUdFUj1tCkNPTkZJR19DUllQVE9fSE1BQz1tCkNPTkZJR19DUllQVE9fWENCQz1t
CkNPTkZJR19DUllQVE9fTlVMTD1tCkNPTkZJR19DUllQVE9fTUQ0PW0KQ09ORklHX0NSWVBU
T19NRDU9bQpDT05GSUdfQ1JZUFRPX1NIQTE9bQpDT05GSUdfQ1JZUFRPX1NIQTI1Nj1tCkNP
TkZJR19DUllQVE9fU0hBNTEyPW0KQ09ORklHX0NSWVBUT19XUDUxMj1tCkNPTkZJR19DUllQ
VE9fVEdSMTkyPW0KIyBDT05GSUdfQ1JZUFRPX0dGMTI4TVVMIGlzIG5vdCBzZXQKQ09ORklH
X0NSWVBUT19FQ0I9bQpDT05GSUdfQ1JZUFRPX0NCQz1tCkNPTkZJR19DUllQVE9fUENCQz1t
CiMgQ09ORklHX0NSWVBUT19MUlcgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fWFRTIGlz
IG5vdCBzZXQKQ09ORklHX0NSWVBUT19DUllQVEQ9bQpDT05GSUdfQ1JZUFRPX0RFUz1tCkNP
TkZJR19DUllQVE9fRkNSWVBUPW0KQ09ORklHX0NSWVBUT19CTE9XRklTSD1tCkNPTkZJR19D
UllQVE9fVFdPRklTSD1tCkNPTkZJR19DUllQVE9fVFdPRklTSF9DT01NT049bQpDT05GSUdf
Q1JZUFRPX1RXT0ZJU0hfNTg2PW0KQ09ORklHX0NSWVBUT19TRVJQRU5UPW0KQ09ORklHX0NS
WVBUT19BRVM9bQpDT05GSUdfQ1JZUFRPX0FFU181ODY9bQpDT05GSUdfQ1JZUFRPX0NBU1Q1
PW0KQ09ORklHX0NSWVBUT19DQVNUNj1tCkNPTkZJR19DUllQVE9fVEVBPW0KQ09ORklHX0NS
WVBUT19BUkM0PW0KQ09ORklHX0NSWVBUT19LSEFaQUQ9bQpDT05GSUdfQ1JZUFRPX0FOVUJJ
Uz1tCkNPTkZJR19DUllQVE9fU0VFRD1tCkNPTkZJR19DUllQVE9fREVGTEFURT1tCkNPTkZJ
R19DUllQVE9fTUlDSEFFTF9NSUM9bQpDT05GSUdfQ1JZUFRPX0NSQzMyQz1tCkNPTkZJR19D
UllQVE9fQ0FNRUxMSUE9bQojIENPTkZJR19DUllQVE9fVEVTVCBpcyBub3Qgc2V0CkNPTkZJ
R19DUllQVE9fQVVUSEVOQz1tCiMgQ09ORklHX0NSWVBUT19IVyBpcyBub3Qgc2V0CgojCiMg
TGlicmFyeSByb3V0aW5lcwojCkNPTkZJR19CSVRSRVZFUlNFPXkKQ09ORklHX0NSQ19DQ0lU
VD1tCkNPTkZJR19DUkMxNj1tCkNPTkZJR19DUkNfSVRVX1Q9bQpDT05GSUdfQ1JDMzI9eQpD
T05GSUdfQ1JDNz1tCkNPTkZJR19MSUJDUkMzMkM9bQpDT05GSUdfWkxJQl9JTkZMQVRFPW0K
Q09ORklHX1pMSUJfREVGTEFURT1tCkNPTkZJR19QTElTVD15CkNPTkZJR19IQVNfSU9NRU09
eQpDT05GSUdfSEFTX0lPUE9SVD15CkNPTkZJR19IQVNfRE1BPXkK
--------------070209070307060307080700
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="dmesg"

TGludXggdmVyc2lvbiAyLjYuMjQtZ2VudG9vLXI4LW9wdGltaXplZCAocm9vdEBhbnRvbi1k
c2t0cCkgKGdjYyB2ZXJzaW9uIDQuMS4yIChHZW50b28gNC4xLjIgcDEuMSkpICM0IFNNUCBT
YXQgTWF5IDMxIDIyOjQ0OjUxIElTVCAyMDA4CkJJT1MtcHJvdmlkZWQgcGh5c2ljYWwgUkFN
IG1hcDoKIEJJT1MtZTgyMDogMDAwMDAwMDAwMDAwMDAwMCAtIDAwMDAwMDAwMDAwOWU4MDAg
KHVzYWJsZSkKIEJJT1MtZTgyMDogMDAwMDAwMDAwMDA5ZTgwMCAtIDAwMDAwMDAwMDAwYTAw
MDAgKHJlc2VydmVkKQogQklPUy1lODIwOiAwMDAwMDAwMDAwMGYwMDAwIC0gMDAwMDAwMDAw
MDEwMDAwMCAocmVzZXJ2ZWQpCiBCSU9TLWU4MjA6IDAwMDAwMDAwMDAxMDAwMDAgLSAwMDAw
MDAwMDdmZTkwMDAwICh1c2FibGUpCiBCSU9TLWU4MjA6IDAwMDAwMDAwN2ZlOTAwMDAgLSAw
MDAwMDAwMDdmZWUzMDAwIChBQ1BJIE5WUykKIEJJT1MtZTgyMDogMDAwMDAwMDA3ZmVlMzAw
MCAtIDAwMDAwMDAwN2ZlZjAwMDAgKEFDUEkgZGF0YSkKIEJJT1MtZTgyMDogMDAwMDAwMDA3
ZmVmMDAwMCAtIDAwMDAwMDAwN2ZmMDAwMDAgKHJlc2VydmVkKQogQklPUy1lODIwOiAwMDAw
MDAwMGUwMDAwMDAwIC0gMDAwMDAwMDBmMDAwMDAwMCAocmVzZXJ2ZWQpCiBCSU9TLWU4MjA6
IDAwMDAwMDAwZmVjMDAwMDAgLSAwMDAwMDAwMTAwMDAwMDAwIChyZXNlcnZlZCkKMTE1ME1C
IEhJR0hNRU0gYXZhaWxhYmxlLgo4OTZNQiBMT1dNRU0gYXZhaWxhYmxlLgpmb3VuZCBTTVAg
TVAtdGFibGUgYXQgMDAwZjNmMDAKRW50ZXJpbmcgYWRkX2FjdGl2ZV9yYW5nZSgwLCAwLCA1
MjM5MjApIDAgZW50cmllcyBvZiAyNTYgdXNlZApab25lIFBGTiByYW5nZXM6CiAgRE1BICAg
ICAgICAgICAgIDAgLT4gICAgIDQwOTYKICBOb3JtYWwgICAgICAgNDA5NiAtPiAgIDIyOTM3
NgogIEhpZ2hNZW0gICAgMjI5Mzc2IC0+ICAgNTIzOTIwCk1vdmFibGUgem9uZSBzdGFydCBQ
Rk4gZm9yIGVhY2ggbm9kZQplYXJseV9ub2RlX21hcFsxXSBhY3RpdmUgUEZOIHJhbmdlcwog
ICAgMDogICAgICAgIDAgLT4gICA1MjM5MjAKT24gbm9kZSAwIHRvdGFscGFnZXM6IDUyMzky
MAogIERNQSB6b25lOiAzMiBwYWdlcyB1c2VkIGZvciBtZW1tYXAKICBETUEgem9uZTogMCBw
YWdlcyByZXNlcnZlZAogIERNQSB6b25lOiA0MDY0IHBhZ2VzLCBMSUZPIGJhdGNoOjAKICBO
b3JtYWwgem9uZTogMTc2MCBwYWdlcyB1c2VkIGZvciBtZW1tYXAKICBOb3JtYWwgem9uZTog
MjIzNTIwIHBhZ2VzLCBMSUZPIGJhdGNoOjMxCiAgSGlnaE1lbSB6b25lOiAyMzAxIHBhZ2Vz
IHVzZWQgZm9yIG1lbW1hcAogIEhpZ2hNZW0gem9uZTogMjkyMjQzIHBhZ2VzLCBMSUZPIGJh
dGNoOjMxCiAgTW92YWJsZSB6b25lOiAwIHBhZ2VzIHVzZWQgZm9yIG1lbW1hcApETUkgMi41
IHByZXNlbnQuCkFDUEk6IFJTRFAgMDAwRjk3QTAsIDAwMjQgKHIyIERFTEwgICkKQUNQSTog
WFNEVCA3RkVFMzA4MCwgMDA1QyAocjEgREVMTCAgICBGWDA5ICAgIDQyMzAyRTMxIEFXUkQg
ICAgICAgIDApCkFDUEk6IEZBQ1AgN0ZFRTcyMDAsIDAwRjQgKHIzIERFTEwgICAgRlgwOSAg
ICA0MjMwMkUzMSBBV1JEICAgICAgICAwKQpBQ1BJOiBEU0RUIDdGRUUzMjAwLCAzRkZDIChy
MSBERUxMICAgQVdSREFDUEkgICAgIDEwMDAgTVNGVCAgMzAwMDAwMCkKQUNQSTogRkFDUyA3
RkU5MDAwMCwgMDA0MApBQ1BJOiBIUEVUIDdGRUU3M0MwLCAwMDM4IChyMSBERUxMICAgIEZY
MDkgICAgNDIzMDJFMzEgQVdSRCAgICAgICA5OCkKQUNQSTogTUNGRyA3RkVFNzQwMCwgMDAz
QyAocjEgREVMTCAgICBGWDA5ICAgIDQyMzAyRTMxIEFXUkQgICAgICAgIDApCkFDUEk6IFNM
SUMgN0ZFRTc0NDAsIDAxNzYgKHIxIERFTEwgICAgRlgwOSAgICA0MjMwMkUzMSBBV1JEICAg
ICAgICAwKQpBQ1BJOiBETVkyIDdGRUU3NUMwLCAwMDgwIChyMSBERUxMICAgIEZYMDkgICAg
NDIzMDJFMzEgQVdSRCAgICAgICAgMCkKQUNQSTogQVBJQyA3RkVFNzMwMCwgMDA4NCAocjEg
REVMTCAgICBGWDA5ICAgIDQyMzAyRTMxIEFXUkQgICAgICAgIDApCkFDUEk6IFNTRFQgN0ZF
RTdGNjAsIDAzODAgKHIxICBQbVJlZiAgICBDcHVQbSAgICAgMzAwMCBJTlRMIDIwMDQxMjAz
KQpBQ1BJOiBQTS1UaW1lciBJTyBQb3J0OiAweDQwOApBQ1BJOiBMb2NhbCBBUElDIGFkZHJl
c3MgMHhmZWUwMDAwMApBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDAwXSBsYXBpY19pZFsweDAw
XSBlbmFibGVkKQpQcm9jZXNzb3IgIzAgNjoxNSBBUElDIHZlcnNpb24gMjAKQUNQSTogTEFQ
SUMgKGFjcGlfaWRbMHgwMV0gbGFwaWNfaWRbMHgwMV0gZW5hYmxlZCkKUHJvY2Vzc29yICMx
IDY6MTUgQVBJQyB2ZXJzaW9uIDIwCkFDUEk6IExBUElDIChhY3BpX2lkWzB4MDJdIGxhcGlj
X2lkWzB4MDNdIGVuYWJsZWQpClByb2Nlc3NvciAjMyA2OjE1IEFQSUMgdmVyc2lvbiAyMApB
Q1BJOiBMQVBJQyAoYWNwaV9pZFsweDAzXSBsYXBpY19pZFsweDAyXSBlbmFibGVkKQpQcm9j
ZXNzb3IgIzIgNjoxNSBBUElDIHZlcnNpb24gMjAKQUNQSTogTEFQSUNfTk1JIChhY3BpX2lk
WzB4MDBdIGhpZ2ggZWRnZSBsaW50WzB4MV0pCkFDUEk6IExBUElDX05NSSAoYWNwaV9pZFsw
eDAxXSBoaWdoIGVkZ2UgbGludFsweDFdKQpBQ1BJOiBMQVBJQ19OTUkgKGFjcGlfaWRbMHgw
Ml0gaGlnaCBlZGdlIGxpbnRbMHgxXSkKQUNQSTogTEFQSUNfTk1JIChhY3BpX2lkWzB4MDNd
IGhpZ2ggZWRnZSBsaW50WzB4MV0pCkFDUEk6IElPQVBJQyAoaWRbMHgwNF0gYWRkcmVzc1sw
eGZlYzAwMDAwXSBnc2lfYmFzZVswXSkKSU9BUElDWzBdOiBhcGljX2lkIDQsIHZlcnNpb24g
MzIsIGFkZHJlc3MgMHhmZWMwMDAwMCwgR1NJIDAtMjMKQUNQSTogSU5UX1NSQ19PVlIgKGJ1
cyAwIGJ1c19pcnEgMCBnbG9iYWxfaXJxIDIgZGZsIGRmbCkKQUNQSTogSU5UX1NSQ19PVlIg
KGJ1cyAwIGJ1c19pcnEgOSBnbG9iYWxfaXJxIDkgaGlnaCBsZXZlbCkKQUNQSTogSVJRMCB1
c2VkIGJ5IG92ZXJyaWRlLgpBQ1BJOiBJUlEyIHVzZWQgYnkgb3ZlcnJpZGUuCkFDUEk6IElS
UTkgdXNlZCBieSBvdmVycmlkZS4KRW5hYmxpbmcgQVBJQyBtb2RlOiAgRmxhdC4gIFVzaW5n
IDEgSS9PIEFQSUNzCkFDUEk6IEhQRVQgaWQ6IDB4ODA4NmEyMDEgYmFzZTogMHhmZWQwMDAw
MApVc2luZyBBQ1BJIChNQURUKSBmb3IgU01QIGNvbmZpZ3VyYXRpb24gaW5mb3JtYXRpb24K
QWxsb2NhdGluZyBQQ0kgcmVzb3VyY2VzIHN0YXJ0aW5nIGF0IDgwMDAwMDAwIChnYXA6IDdm
ZjAwMDAwOjYwMTAwMDAwKQpzd3N1c3A6IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeSByZWdp
b246IDAwMDAwMDAwMDAwOWUwMDAgLSAwMDAwMDAwMDAwMDlmMDAwCnN3c3VzcDogUmVnaXN0
ZXJlZCBub3NhdmUgbWVtb3J5IHJlZ2lvbjogMDAwMDAwMDAwMDA5ZjAwMCAtIDAwMDAwMDAw
MDAwYTAwMDAKc3dzdXNwOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnkgcmVnaW9uOiAwMDAw
MDAwMDAwMGEwMDAwIC0gMDAwMDAwMDAwMDBmMDAwMApzd3N1c3A6IFJlZ2lzdGVyZWQgbm9z
YXZlIG1lbW9yeSByZWdpb246IDAwMDAwMDAwMDAwZjAwMDAgLSAwMDAwMDAwMDAwMTAwMDAw
CkJ1aWx0IDEgem9uZWxpc3RzIGluIFpvbmUgb3JkZXIsIG1vYmlsaXR5IGdyb3VwaW5nIG9u
LiAgVG90YWwgcGFnZXM6IDUxOTgyNwpLZXJuZWwgY29tbWFuZCBsaW5lOiByb290PS9kZXYv
bWQ1IHJvCm1hcHBlZCBBUElDIHRvIGZmZmZiMDAwIChmZWUwMDAwMCkKbWFwcGVkIElPQVBJ
QyB0byBmZmZmYTAwMCAoZmVjMDAwMDApCkVuYWJsaW5nIGZhc3QgRlBVIHNhdmUgYW5kIHJl
c3RvcmUuLi4gZG9uZS4KRW5hYmxpbmcgdW5tYXNrZWQgU0lNRCBGUFUgZXhjZXB0aW9uIHN1
cHBvcnQuLi4gZG9uZS4KSW5pdGlhbGl6aW5nIENQVSMwClBJRCBoYXNoIHRhYmxlIGVudHJp
ZXM6IDQwOTYgKG9yZGVyOiAxMiwgMTYzODQgYnl0ZXMpCkRldGVjdGVkIDIzOTQuMDM3IE1I
eiBwcm9jZXNzb3IuCkNvbnNvbGU6IGNvbG91ciBWR0ErIDgweDI1CmNvbnNvbGUgW3R0eTBd
IGVuYWJsZWQKRGVudHJ5IGNhY2hlIGhhc2ggdGFibGUgZW50cmllczogMTMxMDcyIChvcmRl
cjogNywgNTI0Mjg4IGJ5dGVzKQpJbm9kZS1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDY1
NTM2IChvcmRlcjogNiwgMjYyMTQ0IGJ5dGVzKQpNZW1vcnk6IDIwNzM0MjRrLzIwOTU2ODBr
IGF2YWlsYWJsZSAoMjIyMWsga2VybmVsIGNvZGUsIDIxMTUyayByZXNlcnZlZCwgNzMwayBk
YXRhLCAyMzZrIGluaXQsIDExNzgxNzZrIGhpZ2htZW0pCnZpcnR1YWwga2VybmVsIG1lbW9y
eSBsYXlvdXQ6CiAgICBmaXhtYXAgIDogMHhmZmY4MTAwMCAtIDB4ZmZmZmYwMDAgICAoIDUw
NCBrQikKICAgIHBrbWFwICAgOiAweGZmODAwMDAwIC0gMHhmZmMwMDAwMCAgICg0MDk2IGtC
KQogICAgdm1hbGxvYyA6IDB4Zjg4MDAwMDAgLSAweGZmN2ZlMDAwICAgKCAxMTEgTUIpCiAg
ICBsb3dtZW0gIDogMHhjMDAwMDAwMCAtIDB4ZjgwMDAwMDAgICAoIDg5NiBNQikKICAgICAg
LmluaXQgOiAweGMwM2VhMDAwIC0gMHhjMDQyNTAwMCAgICggMjM2IGtCKQogICAgICAuZGF0
YSA6IDB4YzAzMmI2YjggLSAweGMwM2UyMTY0ICAgKCA3MzAga0IpCiAgICAgIC50ZXh0IDog
MHhjMDEwMDAwMCAtIDB4YzAzMmI2YjggICAoMjIyMSBrQikKQ2hlY2tpbmcgaWYgdGhpcyBw
cm9jZXNzb3IgaG9ub3VycyB0aGUgV1AgYml0IGV2ZW4gaW4gc3VwZXJ2aXNvciBtb2RlLi4u
IE9rLgpTTFVCOiBHZW5zbGFicz0xMSwgSFdhbGlnbj02NCwgT3JkZXI9MC0xLCBNaW5PYmpl
Y3RzPTQsIENQVXM9NCwgTm9kZXM9MQpocGV0IGNsb2NrZXZlbnQgcmVnaXN0ZXJlZApDYWxp
YnJhdGluZyBkZWxheSB1c2luZyB0aW1lciBzcGVjaWZpYyByb3V0aW5lLi4gNDc5Mi4yNiBC
b2dvTUlQUyAobHBqPTc5ODQ0MTcpCk1vdW50LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczog
NTEyCkNQVTogQWZ0ZXIgZ2VuZXJpYyBpZGVudGlmeSwgY2FwczogYmZlYmZiZmYgMjAwMDAw
MDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMGUzYmQgMDAwMDAwMDAgMDAwMDAwMDEgMDAwMDAw
MDAKbW9uaXRvci9td2FpdCBmZWF0dXJlIHByZXNlbnQuCnVzaW5nIG13YWl0IGluIGlkbGUg
dGhyZWFkcy4KQ1BVOiBMMSBJIGNhY2hlOiAzMkssIEwxIEQgY2FjaGU6IDMySwpDUFU6IEwy
IGNhY2hlOiA0MDk2SwpDUFU6IFBoeXNpY2FsIFByb2Nlc3NvciBJRDogMApDUFU6IFByb2Nl
c3NvciBDb3JlIElEOiAwCkNQVTogQWZ0ZXIgYWxsIGluaXRzLCBjYXBzOiBiZmViZmJmZiAy
MDAwMDAwMCAwMDAwMDAwMCAwMDAwMzk0MCAwMDAwZTNiZCAwMDAwMDAwMCAwMDAwMDAwMSAw
MDAwMDAwMApJbnRlbCBtYWNoaW5lIGNoZWNrIGFyY2hpdGVjdHVyZSBzdXBwb3J0ZWQuCklu
dGVsIG1hY2hpbmUgY2hlY2sgcmVwb3J0aW5nIGVuYWJsZWQgb24gQ1BVIzAuCkNvbXBhdCB2
RFNPIG1hcHBlZCB0byBmZmZmZTAwMC4KQ2hlY2tpbmcgJ2hsdCcgaW5zdHJ1Y3Rpb24uLi4g
T0suClNNUCBhbHRlcm5hdGl2ZXM6IHN3aXRjaGluZyB0byBVUCBjb2RlCkFDUEk6IENvcmUg
cmV2aXNpb24gMjAwNzAxMjYKQ1BVMDogSW50ZWwoUikgQ29yZShUTSkyIFF1YWQgQ1BVICAg
IFE2NjAwICBAIDIuNDBHSHogc3RlcHBpbmcgMGIKU01QIGFsdGVybmF0aXZlczogc3dpdGNo
aW5nIHRvIFNNUCBjb2RlCkJvb3RpbmcgcHJvY2Vzc29yIDEvMSBlaXAgMzAwMApJbml0aWFs
aXppbmcgQ1BVIzEKQ2FsaWJyYXRpbmcgZGVsYXkgdXNpbmcgdGltZXIgc3BlY2lmaWMgcm91
dGluZS4uIDQ3ODkuNTEgQm9nb01JUFMgKGxwaj03OTgwMDI4KQpDUFU6IEFmdGVyIGdlbmVy
aWMgaWRlbnRpZnksIGNhcHM6IGJmZWJmYmZmIDIwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAw
IDAwMDBlM2JkIDAwMDAwMDAwIDAwMDAwMDAxIDAwMDAwMDAwCm1vbml0b3IvbXdhaXQgZmVh
dHVyZSBwcmVzZW50LgpDUFU6IEwxIEkgY2FjaGU6IDMySywgTDEgRCBjYWNoZTogMzJLCkNQ
VTogTDIgY2FjaGU6IDQwOTZLCkNQVTogUGh5c2ljYWwgUHJvY2Vzc29yIElEOiAwCkNQVTog
UHJvY2Vzc29yIENvcmUgSUQ6IDEKQ1BVOiBBZnRlciBhbGwgaW5pdHMsIGNhcHM6IGJmZWJm
YmZmIDIwMDAwMDAwIDAwMDAwMDAwIDAwMDAzOTQwIDAwMDBlM2JkIDAwMDAwMDAwIDAwMDAw
MDAxIDAwMDAwMDAwCkludGVsIG1hY2hpbmUgY2hlY2sgYXJjaGl0ZWN0dXJlIHN1cHBvcnRl
ZC4KSW50ZWwgbWFjaGluZSBjaGVjayByZXBvcnRpbmcgZW5hYmxlZCBvbiBDUFUjMS4KQ1BV
MTogSW50ZWwoUikgQ29yZShUTSkyIFF1YWQgQ1BVICAgIFE2NjAwICBAIDIuNDBHSHogc3Rl
cHBpbmcgMGIKU01QIGFsdGVybmF0aXZlczogc3dpdGNoaW5nIHRvIFNNUCBjb2RlCkJvb3Rp
bmcgcHJvY2Vzc29yIDIvMiBlaXAgMzAwMApJbml0aWFsaXppbmcgQ1BVIzIKQ2FsaWJyYXRp
bmcgZGVsYXkgdXNpbmcgdGltZXIgc3BlY2lmaWMgcm91dGluZS4uIDQ3ODkuNTUgQm9nb01J
UFMgKGxwaj03OTgwMDg0KQpDUFU6IEFmdGVyIGdlbmVyaWMgaWRlbnRpZnksIGNhcHM6IGJm
ZWJmYmZmIDIwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDBlM2JkIDAwMDAwMDAwIDAw
MDAwMDAxIDAwMDAwMDAwCm1vbml0b3IvbXdhaXQgZmVhdHVyZSBwcmVzZW50LgpDUFU6IEwx
IEkgY2FjaGU6IDMySywgTDEgRCBjYWNoZTogMzJLCkNQVTogTDIgY2FjaGU6IDQwOTZLCkNQ
VTogUGh5c2ljYWwgUHJvY2Vzc29yIElEOiAwCkNQVTogUHJvY2Vzc29yIENvcmUgSUQ6IDIK
Q1BVOiBBZnRlciBhbGwgaW5pdHMsIGNhcHM6IGJmZWJmYmZmIDIwMDAwMDAwIDAwMDAwMDAw
IDAwMDAzOTQwIDAwMDBlM2JkIDAwMDAwMDAwIDAwMDAwMDAxIDAwMDAwMDAwCkludGVsIG1h
Y2hpbmUgY2hlY2sgYXJjaGl0ZWN0dXJlIHN1cHBvcnRlZC4KSW50ZWwgbWFjaGluZSBjaGVj
ayByZXBvcnRpbmcgZW5hYmxlZCBvbiBDUFUjMi4KQ1BVMjogSW50ZWwoUikgQ29yZShUTSky
IFF1YWQgQ1BVICAgIFE2NjAwICBAIDIuNDBHSHogc3RlcHBpbmcgMGIKU01QIGFsdGVybmF0
aXZlczogc3dpdGNoaW5nIHRvIFNNUCBjb2RlCkJvb3RpbmcgcHJvY2Vzc29yIDMvMyBlaXAg
MzAwMApJbml0aWFsaXppbmcgQ1BVIzMKQ2FsaWJyYXRpbmcgZGVsYXkgdXNpbmcgdGltZXIg
c3BlY2lmaWMgcm91dGluZS4uIDQ3ODkuNTUgQm9nb01JUFMgKGxwaj03OTgwMDg3KQpDUFU6
IEFmdGVyIGdlbmVyaWMgaWRlbnRpZnksIGNhcHM6IGJmZWJmYmZmIDIwMDAwMDAwIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDBlM2JkIDAwMDAwMDAwIDAwMDAwMDAxIDAwMDAwMDAwCm1vbml0
b3IvbXdhaXQgZmVhdHVyZSBwcmVzZW50LgpDUFU6IEwxIEkgY2FjaGU6IDMySywgTDEgRCBj
YWNoZTogMzJLCkNQVTogTDIgY2FjaGU6IDQwOTZLCkNQVTogUGh5c2ljYWwgUHJvY2Vzc29y
IElEOiAwCkNQVTogUHJvY2Vzc29yIENvcmUgSUQ6IDMKQ1BVOiBBZnRlciBhbGwgaW5pdHMs
IGNhcHM6IGJmZWJmYmZmIDIwMDAwMDAwIDAwMDAwMDAwIDAwMDAzOTQwIDAwMDBlM2JkIDAw
MDAwMDAwIDAwMDAwMDAxIDAwMDAwMDAwCkludGVsIG1hY2hpbmUgY2hlY2sgYXJjaGl0ZWN0
dXJlIHN1cHBvcnRlZC4KSW50ZWwgbWFjaGluZSBjaGVjayByZXBvcnRpbmcgZW5hYmxlZCBv
biBDUFUjMy4KQ1BVMzogSW50ZWwoUikgQ29yZShUTSkyIFF1YWQgQ1BVICAgIFE2NjAwICBA
IDIuNDBHSHogc3RlcHBpbmcgMGIKVG90YWwgb2YgNCBwcm9jZXNzb3JzIGFjdGl2YXRlZCAo
MTkxNjIuODggQm9nb01JUFMpLgpFTkFCTElORyBJTy1BUElDIElSUXMKLi5USU1FUjogdmVj
dG9yPTB4MzEgYXBpYzE9MCBwaW4xPTIgYXBpYzI9LTEgcGluMj0tMQpjaGVja2luZyBUU0Mg
c3luY2hyb25pemF0aW9uIFtDUFUjMCAtPiBDUFUjMV06IHBhc3NlZC4KY2hlY2tpbmcgVFND
IHN5bmNocm9uaXphdGlvbiBbQ1BVIzAgLT4gQ1BVIzJdOiBwYXNzZWQuCmNoZWNraW5nIFRT
QyBzeW5jaHJvbml6YXRpb24gW0NQVSMwIC0+IENQVSMzXTogcGFzc2VkLgpCcm91Z2h0IHVw
IDQgQ1BVcwpuZXRfbmFtZXNwYWNlOiA2NCBieXRlcwpORVQ6IFJlZ2lzdGVyZWQgcHJvdG9j
b2wgZmFtaWx5IDE2CkFDUEk6IGJ1cyB0eXBlIHBjaSByZWdpc3RlcmVkClBDSTogVXNpbmcg
TU1DT05GSUcKU2V0dGluZyB1cCBzdGFuZGFyZCBQQ0kgcmVzb3VyY2VzCkFDUEk6IEVDOiBM
b29rIHVwIEVDIGluIERTRFQKQUNQSTogSW50ZXJwcmV0ZXIgZW5hYmxlZApBQ1BJOiAoc3Vw
cG9ydHMgUzAgUzMgUzQgUzUpCkFDUEk6IFVzaW5nIElPQVBJQyBmb3IgaW50ZXJydXB0IHJv
dXRpbmcKQUNQSTogUENJIFJvb3QgQnJpZGdlIFtQQ0kwXSAoMDAwMDowMCkKUENJIHF1aXJr
OiByZWdpb24gMDQwMC0wNDdmIGNsYWltZWQgYnkgSUNINiBBQ1BJL0dQSU8vVENPClBDSSBx
dWlyazogcmVnaW9uIDA0ODAtMDRiZiBjbGFpbWVkIGJ5IElDSDYgR1BJTwpQQ0k6IFRyYW5z
cGFyZW50IGJyaWRnZSAtIDAwMDA6MDA6MWUuMApBQ1BJOiBQQ0kgSW50ZXJydXB0IFJvdXRp
bmcgVGFibGUgW1xfU0JfLlBDSTAuX1BSVF0KQUNQSTogUENJIEludGVycnVwdCBSb3V0aW5n
IFRhYmxlIFtcX1NCXy5QQ0kwLkhVQjAuX1BSVF0KQUNQSTogUENJIEludGVycnVwdCBMaW5r
IFtMTktBXSAoSVJRcyAzIDQgKjUgNyA5IDEwIDExIDEyIDE0IDE1KQpBQ1BJOiBQQ0kgSW50
ZXJydXB0IExpbmsgW0xOS0JdIChJUlFzIDMgNCA1IDcgOSAxMCAxMSAxMiAxNCAxNSkgKjAs
IGRpc2FibGVkLgpBQ1BJOiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0NdIChJUlFzIDMgNCA1
IDcgOSAxMCAqMTEgMTIgMTQgMTUpCkFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LRF0g
KElSUXMgMyA0IDUgNyA5IDEwICoxMSAxMiAxNCAxNSkKQUNQSTogUENJIEludGVycnVwdCBM
aW5rIFtMTktFXSAoSVJRcyAzIDQgNSA3IDkgKjEwIDExIDEyIDE0IDE1KQpBQ1BJOiBQQ0kg
SW50ZXJydXB0IExpbmsgW0xOS0ZdIChJUlFzIDMgKjQgNSA3IDkgMTAgMTEgMTIgMTQgMTUp
CkFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LMF0gKElSUXMgKjMgNCA1IDcgOSAxMCAx
MSAxMiAxNCAxNSkKQUNQSTogUENJIEludGVycnVwdCBMaW5rIFtMTksxXSAoSVJRcyAzIDQg
NSA3ICo5IDEwIDExIDEyIDE0IDE1KQpMaW51eCBQbHVnIGFuZCBQbGF5IFN1cHBvcnQgdjAu
OTcgKGMpIEFkYW0gQmVsYXkKcG5wOiBQblAgQUNQSSBpbml0CkFDUEk6IGJ1cyB0eXBlIHBu
cCByZWdpc3RlcmVkCnBucGFjcGk6IGV4Y2VlZGVkIHRoZSBtYXggbnVtYmVyIG9mIG1lbSBy
ZXNvdXJjZXM6IDEyCnBucDogUG5QIEFDUEk6IGZvdW5kIDEyIGRldmljZXMKQUNQSTogQUNQ
SSBidXMgdHlwZSBwbnAgdW5yZWdpc3RlcmVkClNDU0kgc3Vic3lzdGVtIGluaXRpYWxpemVk
CmxpYmF0YSB2ZXJzaW9uIDMuMDAgbG9hZGVkLgp1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBp
bnRlcmZhY2UgZHJpdmVyIHVzYmZzCnVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFj
ZSBkcml2ZXIgaHViCnVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGRldmljZSBkcml2ZXIgdXNi
ClBDSTogVXNpbmcgQUNQSSBmb3IgSVJRIHJvdXRpbmcKUENJOiBJZiBhIGRldmljZSBkb2Vz
bid0IHdvcmssIHRyeSAicGNpPXJvdXRlaXJxIi4gIElmIGl0IGhlbHBzLCBwb3N0IGEgcmVw
b3J0CmhwZXQwOiBhdCBNTUlPIDB4ZmVkMDAwMDAsIElSUXMgMiwgOCwgMCwgMApocGV0MDog
NCA2NC1iaXQgdGltZXJzLCAxNDMxODE4MCBIegpBQ1BJOiBSVEMgY2FuIHdha2UgZnJvbSBT
NApUaW1lOiB0c2MgY2xvY2tzb3VyY2UgaGFzIGJlZW4gaW5zdGFsbGVkLgpzeXN0ZW0gMDA6
MDE6IGlvcG9ydCByYW5nZSAweDRkMC0weDRkMSBoYXMgYmVlbiByZXNlcnZlZApzeXN0ZW0g
MDA6MDE6IGlvcG9ydCByYW5nZSAweDgwMC0weDg3ZiBoYXMgYmVlbiByZXNlcnZlZApzeXN0
ZW0gMDA6MDE6IGlvcG9ydCByYW5nZSAweDI5MC0weDI5NyBoYXMgYmVlbiByZXNlcnZlZApz
eXN0ZW0gMDA6MDE6IGlvcG9ydCByYW5nZSAweDg4MC0weDg4ZiBoYXMgYmVlbiByZXNlcnZl
ZApzeXN0ZW0gMDA6MDg6IGlvcG9ydCByYW5nZSAweDQwMC0weDRiZiBjb3VsZCBub3QgYmUg
cmVzZXJ2ZWQKc3lzdGVtIDAwOjBhOiBpb21lbSByYW5nZSAweGUwMDAwMDAwLTB4ZWZmZmZm
ZmYgY291bGQgbm90IGJlIHJlc2VydmVkCnN5c3RlbSAwMDowYjogaW9tZW0gcmFuZ2UgMHhm
MDAwMC0weGZmZmZmIGNvdWxkIG5vdCBiZSByZXNlcnZlZApzeXN0ZW0gMDA6MGI6IGlvbWVt
IHJhbmdlIDB4N2ZmMDAwMDAtMHg3ZmZmZmZmZiBoYXMgYmVlbiByZXNlcnZlZApzeXN0ZW0g
MDA6MGI6IGlvbWVtIHJhbmdlIDB4ZmVkMDAwMDAtMHhmZWQwMDBmZiBjb3VsZCBub3QgYmUg
cmVzZXJ2ZWQKc3lzdGVtIDAwOjBiOiBpb21lbSByYW5nZSAweDdmZTkwMDAwLTB4N2ZlZmZm
ZmYgY291bGQgbm90IGJlIHJlc2VydmVkCnN5c3RlbSAwMDowYjogaW9tZW0gcmFuZ2UgMHgw
LTB4OWZmZmYgY291bGQgbm90IGJlIHJlc2VydmVkCnN5c3RlbSAwMDowYjogaW9tZW0gcmFu
Z2UgMHgxMDAwMDAtMHg3ZmU4ZmZmZiBjb3VsZCBub3QgYmUgcmVzZXJ2ZWQKc3lzdGVtIDAw
OjBiOiBpb21lbSByYW5nZSAweGZlYzAwMDAwLTB4ZmVjMDBmZmYgY291bGQgbm90IGJlIHJl
c2VydmVkCnN5c3RlbSAwMDowYjogaW9tZW0gcmFuZ2UgMHhmZWQxNDAwMC0weGZlZDFkZmZm
IGNvdWxkIG5vdCBiZSByZXNlcnZlZApzeXN0ZW0gMDA6MGI6IGlvbWVtIHJhbmdlIDB4ZmVk
MjAwMDAtMHhmZWQ5ZmZmZiBjb3VsZCBub3QgYmUgcmVzZXJ2ZWQKc3lzdGVtIDAwOjBiOiBp
b21lbSByYW5nZSAweGZlZTAwMDAwLTB4ZmVlMDBmZmYgY291bGQgbm90IGJlIHJlc2VydmVk
CnN5c3RlbSAwMDowYjogaW9tZW0gcmFuZ2UgMHhmZmIwMDAwMC0weGZmYjdmZmZmIGNvdWxk
IG5vdCBiZSByZXNlcnZlZApzeXN0ZW0gMDA6MGI6IGlvbWVtIHJhbmdlIDB4ZmZmMDAwMDAt
MHhmZmZmZmZmZiBjb3VsZCBub3QgYmUgcmVzZXJ2ZWQKU3dpdGNoZWQgdG8gaGlnaCByZXNv
bHV0aW9uIG1vZGUgb24gQ1BVIDEKU3dpdGNoZWQgdG8gaGlnaCByZXNvbHV0aW9uIG1vZGUg
b24gQ1BVIDIKU3dpdGNoZWQgdG8gaGlnaCByZXNvbHV0aW9uIG1vZGUgb24gQ1BVIDMKU3dp
dGNoZWQgdG8gaGlnaCByZXNvbHV0aW9uIG1vZGUgb24gQ1BVIDAKUENJOiBCcmlkZ2U6IDAw
MDA6MDA6MDEuMAogIElPIHdpbmRvdzogYzAwMC1jZmZmCiAgTUVNIHdpbmRvdzogZmEwMDAw
MDAtZmNmZmZmZmYKICBQUkVGRVRDSCB3aW5kb3c6IGQwMDAwMDAwLWRmZmZmZmZmClBDSTog
QnJpZGdlOiAwMDAwOjAwOjFlLjAKICBJTyB3aW5kb3c6IGQwMDAtZGZmZgogIE1FTSB3aW5k
b3c6IGZkZTAwMDAwLWZkZWZmZmZmCiAgUFJFRkVUQ0ggd2luZG93OiBmZGQwMDAwMC1mZGRm
ZmZmZgpBQ1BJOiBQQ0kgSW50ZXJydXB0IDAwMDA6MDA6MDEuMFtBXSAtPiBHU0kgMTYgKGxl
dmVsLCBsb3cpIC0+IElSUSAxNgpQQ0k6IFNldHRpbmcgbGF0ZW5jeSB0aW1lciBvZiBkZXZp
Y2UgMDAwMDowMDowMS4wIHRvIDY0ClBDSTogU2V0dGluZyBsYXRlbmN5IHRpbWVyIG9mIGRl
dmljZSAwMDAwOjAwOjFlLjAgdG8gNjQKTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWls
eSAyCklQIHJvdXRlIGNhY2hlIGhhc2ggdGFibGUgZW50cmllczogMzI3NjggKG9yZGVyOiA1
LCAxMzEwNzIgYnl0ZXMpClRDUCBlc3RhYmxpc2hlZCBoYXNoIHRhYmxlIGVudHJpZXM6IDEz
MTA3MiAob3JkZXI6IDgsIDEwNDg1NzYgYnl0ZXMpClRDUCBiaW5kIGhhc2ggdGFibGUgZW50
cmllczogNjU1MzYgKG9yZGVyOiA3LCA1MjQyODggYnl0ZXMpClRDUDogSGFzaCB0YWJsZXMg
Y29uZmlndXJlZCAoZXN0YWJsaXNoZWQgMTMxMDcyIGJpbmQgNjU1MzYpClRDUCByZW5vIHJl
Z2lzdGVyZWQKaGlnaG1lbSBib3VuY2UgcG9vbCBzaXplOiA2NCBwYWdlcwpmdXNlIGluaXQg
KEFQSSB2ZXJzaW9uIDcuOSkKSkZTOiBuVHhCbG9jayA9IDgxOTIsIG5UeExvY2sgPSA2NTUz
NgppbyBzY2hlZHVsZXIgbm9vcCByZWdpc3RlcmVkCmlvIHNjaGVkdWxlciBhbnRpY2lwYXRv
cnkgcmVnaXN0ZXJlZCAoZGVmYXVsdCkKaW8gc2NoZWR1bGVyIGRlYWRsaW5lIHJlZ2lzdGVy
ZWQKaW8gc2NoZWR1bGVyIGNmcSByZWdpc3RlcmVkCkJvb3QgdmlkZW8gZGV2aWNlIGlzIDAw
MDA6MDE6MDAuMApQQ0k6IFNldHRpbmcgbGF0ZW5jeSB0aW1lciBvZiBkZXZpY2UgMDAwMDow
MDowMS4wIHRvIDY0CmFzc2lnbl9pbnRlcnJ1cHRfbW9kZSBGb3VuZCBNU0kgY2FwYWJpbGl0
eQpBbGxvY2F0ZSBQb3J0IFNlcnZpY2VbMDAwMDowMDowMS4wOnBjaWUwMF0KQWxsb2NhdGUg
UG9ydCBTZXJ2aWNlWzAwMDA6MDA6MDEuMDpwY2llMDNdClJlYWwgVGltZSBDbG9jayBEcml2
ZXIgdjEuMTJhYwpocGV0X3Jlc291cmNlczogMHhmZWQwMDAwMCBpcyBidXN5CkxpbnV4IGFn
cGdhcnQgaW50ZXJmYWNlIHYwLjEwMgpIYW5nY2hlY2s6IHN0YXJ0aW5nIGhhbmdjaGVjayB0
aW1lciAwLjkuMCAodGljayBpcyAxODAgc2Vjb25kcywgbWFyZ2luIGlzIDYwIHNlY29uZHMp
LgpIYW5nY2hlY2s6IFVzaW5nIGdldF9jeWNsZXMoKS4KUkFNRElTSyBkcml2ZXIgaW5pdGlh
bGl6ZWQ6IDE2IFJBTSBkaXNrcyBvZiA0MDk2SyBzaXplIDEwMjQgYmxvY2tzaXplCmxvb3A6
IG1vZHVsZSBsb2FkZWQKRHJpdmVyICdzZCcgbmVlZHMgdXBkYXRpbmcgLSBwbGVhc2UgdXNl
IGJ1c190eXBlIG1ldGhvZHMKRHJpdmVyICdzcicgbmVlZHMgdXBkYXRpbmcgLSBwbGVhc2Ug
dXNlIGJ1c190eXBlIG1ldGhvZHMKYXRhX3BpaXggMDAwMDowMDoxZi4yOiB2ZXJzaW9uIDIu
MTIKYXRhX3BpaXggMDAwMDowMDoxZi4yOiBNQVAgWyBQMCBQMiBQMSBQMyBdCkFDUEk6IFBD
SSBJbnRlcnJ1cHQgMDAwMDowMDoxZi4yW0FdIC0+IEdTSSAxOSAobGV2ZWwsIGxvdykgLT4g
SVJRIDE3ClBDSTogU2V0dGluZyBsYXRlbmN5IHRpbWVyIG9mIGRldmljZSAwMDAwOjAwOjFm
LjIgdG8gNjQKc2NzaTAgOiBhdGFfcGlpeApzY3NpMSA6IGF0YV9waWl4CmF0YTE6IFNBVEEg
bWF4IFVETUEvMTMzIGNtZCAweGY4MDAgY3RsIDB4ZjcwMCBibWRtYSAweGY0MDAgaXJxIDE3
CmF0YTI6IFNBVEEgbWF4IFVETUEvMTMzIGNtZCAweGY2MDAgY3RsIDB4ZjUwMCBibWRtYSAw
eGY0MDggaXJxIDE3CmF0YTEuMDA6IEFUQS04OiBXREMgV0QyNTAwQUFKUy03NVZXQTAsIDEy
LjAxQjAyLCBtYXggVURNQS8xMzMKYXRhMS4wMDogNDg4MjgxMjUwIHNlY3RvcnMsIG11bHRp
IDE2OiBMQkE0OCBOQ1EgKGRlcHRoIDAvMzIpCmF0YTEuMDA6IGNvbmZpZ3VyZWQgZm9yIFVE
TUEvMTMzCmF0YTIuMDA6IEFUQS04OiBXREMgV0QyNTAwQUFKUy03NVZXQTAsIDEyLjAxQjAy
LCBtYXggVURNQS8xMzMKYXRhMi4wMDogNDg4MjgxMjUwIHNlY3RvcnMsIG11bHRpIDE2OiBM
QkE0OCBOQ1EgKGRlcHRoIDAvMzIpCmF0YTIuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTMz
CnNjc2kgMDowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAgQVRBICAgICAgV0RDIFdEMjUwMEFB
SlMtNyAxMi4wIFBROiAwIEFOU0k6IDUKc2QgMDowOjA6MDogW3NkYV0gNDg4MjgxMjUwIDUx
Mi1ieXRlIGhhcmR3YXJlIHNlY3RvcnMgKDI1MDAwMCBNQikKc2QgMDowOjA6MDogW3NkYV0g
V3JpdGUgUHJvdGVjdCBpcyBvZmYKc2QgMDowOjA6MDogW3NkYV0gTW9kZSBTZW5zZTogMDAg
M2EgMDAgMDAKc2QgMDowOjA6MDogW3NkYV0gV3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQg
Y2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBEUE8gb3IgRlVBCnNkIDA6MDowOjA6
IFtzZGFdIDQ4ODI4MTI1MCA1MTItYnl0ZSBoYXJkd2FyZSBzZWN0b3JzICgyNTAwMDAgTUIp
CnNkIDA6MDowOjA6IFtzZGFdIFdyaXRlIFByb3RlY3QgaXMgb2ZmCnNkIDA6MDowOjA6IFtz
ZGFdIE1vZGUgU2Vuc2U6IDAwIDNhIDAwIDAwCnNkIDA6MDowOjA6IFtzZGFdIFdyaXRlIGNh
Y2hlOiBlbmFibGVkLCByZWFkIGNhY2hlOiBlbmFibGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBP
IG9yIEZVQQogc2RhOiBzZGExIHNkYTIgc2RhMyA8IHNkYTUgc2RhNiBzZGE3ID4Kc2QgMDow
OjA6MDogW3NkYV0gQXR0YWNoZWQgU0NTSSBkaXNrCnNkIDA6MDowOjA6IEF0dGFjaGVkIHNj
c2kgZ2VuZXJpYyBzZzAgdHlwZSAwCnNjc2kgMTowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAg
QVRBICAgICAgV0RDIFdEMjUwMEFBSlMtNyAxMi4wIFBROiAwIEFOU0k6IDUKc2QgMTowOjA6
MDogW3NkYl0gNDg4MjgxMjUwIDUxMi1ieXRlIGhhcmR3YXJlIHNlY3RvcnMgKDI1MDAwMCBN
QikKc2QgMTowOjA6MDogW3NkYl0gV3JpdGUgUHJvdGVjdCBpcyBvZmYKc2QgMTowOjA6MDog
W3NkYl0gTW9kZSBTZW5zZTogMDAgM2EgMDAgMDAKc2QgMTowOjA6MDogW3NkYl0gV3JpdGUg
Y2FjaGU6IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBE
UE8gb3IgRlVBCnNkIDE6MDowOjA6IFtzZGJdIDQ4ODI4MTI1MCA1MTItYnl0ZSBoYXJkd2Fy
ZSBzZWN0b3JzICgyNTAwMDAgTUIpCnNkIDE6MDowOjA6IFtzZGJdIFdyaXRlIFByb3RlY3Qg
aXMgb2ZmCnNkIDE6MDowOjA6IFtzZGJdIE1vZGUgU2Vuc2U6IDAwIDNhIDAwIDAwCnNkIDE6
MDowOjA6IFtzZGJdIFdyaXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNhY2hlOiBlbmFibGVk
LCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQQogc2RiOiBzZGIxIHNkYjIgc2RiMyA8IHNk
YjUgc2RiNiBzZGI3ID4Kc2QgMTowOjA6MDogW3NkYl0gQXR0YWNoZWQgU0NTSSBkaXNrCnNk
IDE6MDowOjA6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzEgdHlwZSAwCmF0YV9waWl4IDAw
MDA6MDA6MWYuNTogTUFQIFsgUDAgLS0gUDEgLS0gXQpBQ1BJOiBQQ0kgSW50ZXJydXB0IDAw
MDA6MDA6MWYuNVtBXSAtPiBHU0kgMTkgKGxldmVsLCBsb3cpIC0+IElSUSAxNwpQQ0k6IFNl
dHRpbmcgbGF0ZW5jeSB0aW1lciBvZiBkZXZpY2UgMDAwMDowMDoxZi41IHRvIDY0CnNjc2ky
IDogYXRhX3BpaXgKc2NzaTMgOiBhdGFfcGlpeAphdGEzOiBTQVRBIG1heCBVRE1BLzEzMyBj
bWQgMHhmMTAwIGN0bCAweGYwMDAgYm1kbWEgMHhlZDAwIGlycSAxNwphdGE0OiBTQVRBIG1h
eCBVRE1BLzEzMyBjbWQgMHhlZjAwIGN0bCAweGVlMDAgYm1kbWEgMHhlZDA4IGlycSAxNwph
dGEzLjAwOiBBVEFQSTogUEJEUyBEVkQrLy1SVyBESC0xNlcxUywgMkQxNCwgbWF4IFVETUEv
MTAwCmF0YTMuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTAwCmF0YTQuMDA6IEFUQVBJOiBQ
TERTIERWRC1ST00gREgtMTZEMlMsIEpEMTEsIG1heCBVRE1BLzEwMAphdGE0LjAwOiBjb25m
aWd1cmVkIGZvciBVRE1BLzEwMApzY3NpIDI6MDowOjA6IENELVJPTSAgICAgICAgICAgIFBC
RFMgICAgIERWRCstUlcgREgtMTZXMVMgMkQxNCBQUTogMCBBTlNJOiA1CnNyMDogc2NzaTMt
bW1jIGRyaXZlOiA0OHgvNDh4IHdyaXRlciBjZC9ydyB4YS9mb3JtMiBjZGRhIHRyYXkKVW5p
Zm9ybSBDRC1ST00gZHJpdmVyIFJldmlzaW9uOiAzLjIwCnNyIDI6MDowOjA6IEF0dGFjaGVk
IHNjc2kgQ0QtUk9NIHNyMApzciAyOjA6MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2cy
IHR5cGUgNQpzY3NpIDM6MDowOjA6IENELVJPTSAgICAgICAgICAgIFBMRFMgICAgIERWRC1S
T00gREgtMTZEMlMgSkQxMSBQUTogMCBBTlNJOiA1CnNyMTogc2NzaTMtbW1jIGRyaXZlOiA0
OHgvNDh4IGNkL3J3IHhhL2Zvcm0yIGNkZGEgdHJheQpzciAzOjA6MDowOiBBdHRhY2hlZCBz
Y3NpIENELVJPTSBzcjEKc3IgMzowOjA6MDogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnMyB0
eXBlIDUKdXNibW9uOiBkZWJ1Z2ZzIGlzIG5vdCBhdmFpbGFibGUKUE5QOiBObyBQUy8yIGNv
bnRyb2xsZXIgZm91bmQuIFByb2JpbmcgcG9ydHMgZGlyZWN0bHkuCnNlcmlvOiBpODA0MiBL
QkQgcG9ydCBhdCAweDYwLDB4NjQgaXJxIDEKc2VyaW86IGk4MDQyIEFVWCBwb3J0IGF0IDB4
NjAsMHg2NCBpcnEgMTIKbWljZTogUFMvMiBtb3VzZSBkZXZpY2UgY29tbW9uIGZvciBhbGwg
bWljZQpydGNfY21vczogcHJvYmUgb2YgMDA6MDQgZmFpbGVkIHdpdGggZXJyb3IgLTE2Cm1k
OiByYWlkMSBwZXJzb25hbGl0eSByZWdpc3RlcmVkIGZvciBsZXZlbCAxCmNwdWlkbGU6IHVz
aW5nIGdvdmVybm9yIGxhZGRlcgpjcHVpZGxlOiB1c2luZyBnb3Zlcm5vciBtZW51CnVzYmNv
cmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgaGlkZGV2CnVzYmNvcmU6IHJl
Z2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNiaGlkCmRyaXZlcnMvaGlkL3VzYmhp
ZC9oaWQtY29yZS5jOiB2Mi42OlVTQiBISUQgY29yZSBkcml2ZXIKVENQIGN1YmljIHJlZ2lz
dGVyZWQKTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxCk5FVDogUmVnaXN0ZXJl
ZCBwcm90b2NvbCBmYW1pbHkgMTcKU3RhcnRpbmcgYmFsYW5jZWRfaXJxClVzaW5nIElQSSBO
by1TaG9ydGN1dCBtb2RlCmRyaXZlcnMvcnRjL2hjdG9zeXMuYzogdW5hYmxlIHRvIG9wZW4g
cnRjIGRldmljZSAocnRjMCkKbWQ6IEF1dG9kZXRlY3RpbmcgUkFJRCBhcnJheXMuCm1kOiBT
Y2FubmVkIDggYW5kIGFkZGVkIDggZGV2aWNlcy4KbWQ6IGF1dG9ydW4gLi4uCm1kOiBjb25z
aWRlcmluZyBzZGI3IC4uLgptZDogIGFkZGluZyBzZGI3IC4uLgptZDogc2RiNiBoYXMgZGlm
ZmVyZW50IFVVSUQgdG8gc2RiNwptZDogc2RiNSBoYXMgZGlmZmVyZW50IFVVSUQgdG8gc2Ri
NwptZDogc2RiMiBoYXMgZGlmZmVyZW50IFVVSUQgdG8gc2RiNwptZDogc2RhNyBoYXMgZGlm
ZmVyZW50IFVVSUQgdG8gc2RiNwptZDogIGFkZGluZyBzZGE2IC4uLgptZDogc2RhNSBoYXMg
ZGlmZmVyZW50IFVVSUQgdG8gc2RiNwptZDogc2RhMiBoYXMgZGlmZmVyZW50IFVVSUQgdG8g
c2RiNwptZDogY3JlYXRlZCBtZDMKbWQ6IGJpbmQ8c2RhNj4KbWQ6IGJpbmQ8c2RiNz4KbWQ6
IHJ1bm5pbmc6IDxzZGI3PjxzZGE2PgpyYWlkMTogcmFpZCBzZXQgbWQzIGFjdGl2ZSB3aXRo
IDIgb3V0IG9mIDIgbWlycm9ycwptZDogY29uc2lkZXJpbmcgc2RiNiAuLi4KbWQ6ICBhZGRp
bmcgc2RiNiAuLi4KbWQ6IHNkYjUgaGFzIGRpZmZlcmVudCBVVUlEIHRvIHNkYjYKbWQ6IHNk
YjIgaGFzIGRpZmZlcmVudCBVVUlEIHRvIHNkYjYKbWQ6ICBhZGRpbmcgc2RhNyAuLi4KbWQ6
IHNkYTUgaGFzIGRpZmZlcmVudCBVVUlEIHRvIHNkYjYKbWQ6IHNkYTIgaGFzIGRpZmZlcmVu
dCBVVUlEIHRvIHNkYjYKbWQ6IGNyZWF0ZWQgbWQyCm1kOiBiaW5kPHNkYTc+Cm1kOiBiaW5k
PHNkYjY+Cm1kOiBydW5uaW5nOiA8c2RiNj48c2RhNz4KcmFpZDE6IHJhaWQgc2V0IG1kMiBh
Y3RpdmUgd2l0aCAyIG91dCBvZiAyIG1pcnJvcnMKbWQ6IGNvbnNpZGVyaW5nIHNkYjUgLi4u
Cm1kOiAgYWRkaW5nIHNkYjUgLi4uCm1kOiBzZGIyIGhhcyBkaWZmZXJlbnQgVVVJRCB0byBz
ZGI1Cm1kOiAgYWRkaW5nIHNkYTUgLi4uCm1kOiBzZGEyIGhhcyBkaWZmZXJlbnQgVVVJRCB0
byBzZGI1Cm1kOiBjcmVhdGVkIG1kNQptZDogYmluZDxzZGE1PgptZDogYmluZDxzZGI1Pgpt
ZDogcnVubmluZzogPHNkYjU+PHNkYTU+CnJhaWQxOiByYWlkIHNldCBtZDUgYWN0aXZlIHdp
dGggMiBvdXQgb2YgMiBtaXJyb3JzCm1kOiBjb25zaWRlcmluZyBzZGIyIC4uLgptZDogIGFk
ZGluZyBzZGIyIC4uLgptZDogIGFkZGluZyBzZGEyIC4uLgptZDogY3JlYXRlZCBtZDAKbWQ6
IGJpbmQ8c2RhMj4KbWQ6IGJpbmQ8c2RiMj4KbWQ6IHJ1bm5pbmc6IDxzZGIyPjxzZGEyPgpy
YWlkMTogcmFpZCBzZXQgbWQwIGFjdGl2ZSB3aXRoIDIgb3V0IG9mIDIgbWlycm9ycwptZDog
Li4uIGF1dG9ydW4gRE9ORS4KVkZTOiBNb3VudGVkIHJvb3QgKGpmcyBmaWxlc3lzdGVtKSBy
ZWFkb25seS4KRnJlZWluZyB1bnVzZWQga2VybmVsIG1lbW9yeTogMjM2ayBmcmVlZAppbnB1
dDogUEMgU3BlYWtlciBhcyAvZGV2aWNlcy9wbGF0Zm9ybS9wY3Nwa3IvaW5wdXQvaW5wdXQw
CmlUQ09fd2R0OiBJbnRlbCBUQ08gV2F0Y2hEb2cgVGltZXIgRHJpdmVyIHYxLjAyICgyNi1K
dWwtMjAwNykKaVRDT193ZHQ6IEZvdW5kIGEgSUNIOVIgVENPIGRldmljZSAoVmVyc2lvbj0y
LCBUQ09CQVNFPTB4MDQ2MCkKaVRDT193ZHQ6IGluaXRpYWxpemVkLiBoZWFydGJlYXQ9MzAg
c2VjIChub3dheW91dD0wKQpVU0IgVW5pdmVyc2FsIEhvc3QgQ29udHJvbGxlciBJbnRlcmZh
Y2UgZHJpdmVyIHYzLjAKQUNQSTogUENJIEludGVycnVwdCAwMDAwOjAwOjFhLjBbQV0gLT4g
R1NJIDE2IChsZXZlbCwgbG93KSAtPiBJUlEgMTYKUENJOiBTZXR0aW5nIGxhdGVuY3kgdGlt
ZXIgb2YgZGV2aWNlIDAwMDA6MDA6MWEuMCB0byA2NAp1aGNpX2hjZCAwMDAwOjAwOjFhLjA6
IFVIQ0kgSG9zdCBDb250cm9sbGVyCnVoY2lfaGNkIDAwMDA6MDA6MWEuMDogbmV3IFVTQiBi
dXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51bWJlciAxCnVoY2lfaGNkIDAwMDA6MDA6
MWEuMDogaXJxIDE2LCBpbyBiYXNlIDB4MDAwMGZlMDAKdXNiIHVzYjE6IGNvbmZpZ3VyYXRp
b24gIzEgY2hvc2VuIGZyb20gMSBjaG9pY2UKaHViIDEtMDoxLjA6IFVTQiBodWIgZm91bmQK
aHViIDEtMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQKZTEwMDBlOiBJbnRlbChSKSBQUk8vMTAw
MCBOZXR3b3JrIERyaXZlciAtIDAuMi4wCmUxMDAwZTogQ29weXJpZ2h0IChjKSAxOTk5LTIw
MDcgSW50ZWwgQ29ycG9yYXRpb24uCmlucHV0OiBQb3dlciBCdXR0b24gKEZGKSBhcyAvZGV2
aWNlcy92aXJ0dWFsL2lucHV0L2lucHV0MQp0aGVybWFsOiBVbmtub3duIHN5bWJvbCBhY3Bp
X3Byb2Nlc3Nvcl9zZXRfdGhlcm1hbF9saW1pdApBQ1BJOiBQb3dlciBCdXR0b24gKEZGKSBb
UFdSRl0KQUNQSTogU1NEVCA3RkVFNzY4MCwgMDIyQSAocjEgIFBtUmVmICBDcHUwSXN0ICAg
ICAzMDAwIElOVEwgMjAwNDEyMDMpCkFDUEk6IFNTRFQgN0ZFRTdCNDAsIDAxNTIgKHIxICBQ
bVJlZiAgQ3B1MUlzdCAgICAgMzAwMCBJTlRMIDIwMDQxMjAzKQpBQ1BJOiBTU0RUIDdGRUU3
Q0EwLCAwMTUyIChyMSAgUG1SZWYgIENwdTJJc3QgICAgIDMwMDAgSU5UTCAyMDA0MTIwMykK
QUNQSTogU1NEVCA3RkVFN0UwMCwgMDE1MiAocjEgIFBtUmVmICBDcHUzSXN0ICAgICAzMDAw
IElOVEwgMjAwNDEyMDMpCmlucHV0OiBQb3dlciBCdXR0b24gKENNKSBhcyAvZGV2aWNlcy92
aXJ0dWFsL2lucHV0L2lucHV0MgpBQ1BJOiBQb3dlciBCdXR0b24gKENNKSBbUFdSQl0KQUNQ
STogRmFuIFtGQU5dIChvbikKQUNQSTogUENJIEludGVycnVwdCAwMDAwOjAwOjFhLjFbQl0g
LT4gR1NJIDIxIChsZXZlbCwgbG93KSAtPiBJUlEgMTgKUENJOiBTZXR0aW5nIGxhdGVuY3kg
dGltZXIgb2YgZGV2aWNlIDAwMDA6MDA6MWEuMSB0byA2NAp1aGNpX2hjZCAwMDAwOjAwOjFh
LjE6IFVIQ0kgSG9zdCBDb250cm9sbGVyCnVoY2lfaGNkIDAwMDA6MDA6MWEuMTogbmV3IFVT
QiBidXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51bWJlciAyCnVoY2lfaGNkIDAwMDA6
MDA6MWEuMTogaXJxIDE4LCBpbyBiYXNlIDB4MDAwMGZkMDAKdXNiIHVzYjI6IGNvbmZpZ3Vy
YXRpb24gIzEgY2hvc2VuIGZyb20gMSBjaG9pY2UKaHViIDItMDoxLjA6IFVTQiBodWIgZm91
bmQKaHViIDItMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQKQUNQSTogVGhlcm1hbCBab25lIFtU
SFJNXSAoNDAgQykKQUNQSTogUENJIEludGVycnVwdCAwMDAwOjAwOjFhLjJbRF0gLT4gR1NJ
IDE5IChsZXZlbCwgbG93KSAtPiBJUlEgMTcKUENJOiBTZXR0aW5nIGxhdGVuY3kgdGltZXIg
b2YgZGV2aWNlIDAwMDA6MDA6MWEuMiB0byA2NAp1aGNpX2hjZCAwMDAwOjAwOjFhLjI6IFVI
Q0kgSG9zdCBDb250cm9sbGVyCnVoY2lfaGNkIDAwMDA6MDA6MWEuMjogbmV3IFVTQiBidXMg
cmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51bWJlciAzCnVoY2lfaGNkIDAwMDA6MDA6MWEu
MjogaXJxIDE3LCBpbyBiYXNlIDB4MDAwMGZjMDAKdXNiIHVzYjM6IGNvbmZpZ3VyYXRpb24g
IzEgY2hvc2VuIGZyb20gMSBjaG9pY2UKaHViIDMtMDoxLjA6IFVTQiBodWIgZm91bmQKaHVi
IDMtMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQKQUNQSTogUENJIEludGVycnVwdCAwMDAwOjAw
OjFkLjBbQV0gLT4gR1NJIDIzIChsZXZlbCwgbG93KSAtPiBJUlEgMTkKUENJOiBTZXR0aW5n
IGxhdGVuY3kgdGltZXIgb2YgZGV2aWNlIDAwMDA6MDA6MWQuMCB0byA2NAp1aGNpX2hjZCAw
MDAwOjAwOjFkLjA6IFVIQ0kgSG9zdCBDb250cm9sbGVyCnVoY2lfaGNkIDAwMDA6MDA6MWQu
MDogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51bWJlciA0CnVoY2lf
aGNkIDAwMDA6MDA6MWQuMDogaXJxIDE5LCBpbyBiYXNlIDB4MDAwMGZiMDAKdXNiIHVzYjQ6
IGNvbmZpZ3VyYXRpb24gIzEgY2hvc2VuIGZyb20gMSBjaG9pY2UKaHViIDQtMDoxLjA6IFVT
QiBodWIgZm91bmQKaHViIDQtMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQKbnZpZGlhOiBtb2R1
bGUgbGljZW5zZSAnTlZJRElBJyB0YWludHMga2VybmVsLgpBQ1BJOiBQQ0kgSW50ZXJydXB0
IDAwMDA6MDA6MWQuMVtCXSAtPiBHU0kgMTkgKGxldmVsLCBsb3cpIC0+IElSUSAxNwpQQ0k6
IFNldHRpbmcgbGF0ZW5jeSB0aW1lciBvZiBkZXZpY2UgMDAwMDowMDoxZC4xIHRvIDY0CnVo
Y2lfaGNkIDAwMDA6MDA6MWQuMTogVUhDSSBIb3N0IENvbnRyb2xsZXIKdWhjaV9oY2QgMDAw
MDowMDoxZC4xOiBuZXcgVVNCIGJ1cyByZWdpc3RlcmVkLCBhc3NpZ25lZCBidXMgbnVtYmVy
IDUKdWhjaV9oY2QgMDAwMDowMDoxZC4xOiBpcnEgMTcsIGlvIGJhc2UgMHgwMDAwZmEwMAp1
c2IgdXNiNTogY29uZmlndXJhdGlvbiAjMSBjaG9zZW4gZnJvbSAxIGNob2ljZQpodWIgNS0w
OjEuMDogVVNCIGh1YiBmb3VuZApodWIgNS0wOjEuMDogMiBwb3J0cyBkZXRlY3RlZAp1c2Ig
Mi0xOiBuZXcgZnVsbCBzcGVlZCBVU0IgZGV2aWNlIHVzaW5nIHVoY2lfaGNkIGFuZCBhZGRy
ZXNzIDIKQUNQSTogUENJIEludGVycnVwdCAwMDAwOjAwOjFkLjJbQ10gLT4gR1NJIDE4IChs
ZXZlbCwgbG93KSAtPiBJUlEgMjAKUENJOiBTZXR0aW5nIGxhdGVuY3kgdGltZXIgb2YgZGV2
aWNlIDAwMDA6MDA6MWQuMiB0byA2NAp1aGNpX2hjZCAwMDAwOjAwOjFkLjI6IFVIQ0kgSG9z
dCBDb250cm9sbGVyCnVoY2lfaGNkIDAwMDA6MDA6MWQuMjogbmV3IFVTQiBidXMgcmVnaXN0
ZXJlZCwgYXNzaWduZWQgYnVzIG51bWJlciA2CnVoY2lfaGNkIDAwMDA6MDA6MWQuMjogaXJx
IDIwLCBpbyBiYXNlIDB4MDAwMGY5MDAKdXNiIHVzYjY6IGNvbmZpZ3VyYXRpb24gIzEgY2hv
c2VuIGZyb20gMSBjaG9pY2UKaHViIDYtMDoxLjA6IFVTQiBodWIgZm91bmQKaHViIDYtMDox
LjA6IDIgcG9ydHMgZGV0ZWN0ZWQKdXNiIDItMTogY29uZmlndXJhdGlvbiAjMSBjaG9zZW4g
ZnJvbSAxIGNob2ljZQpBQ1BJOiBQQ0kgSW50ZXJydXB0IDAwMDA6MDA6MTkuMFtBXSAtPiBH
U0kgMjAgKGxldmVsLCBsb3cpIC0+IElSUSAyMQpQQ0k6IFNldHRpbmcgbGF0ZW5jeSB0aW1l
ciBvZiBkZXZpY2UgMDAwMDowMDoxOS4wIHRvIDY0CjAwMDA6MDA6MTkuMDogZXRoMDogKFBD
SSBFeHByZXNzOjIuNUdCL3M6V2lkdGggeDEpIDAwOjFkOjA5Ojg4OjgwOmNmCjAwMDA6MDA6
MTkuMDogZXRoMDogSW50ZWwoUikgUFJPLzEwLzEwMCBOZXR3b3JrIENvbm5lY3Rpb24KMDAw
MDowMDoxOS4wOiBldGgwOiBNQUM6IDUsIFBIWTogNywgUEJBIE5vOiBmZmZmZmYtMGZmCkFD
UEk6IFBDSSBJbnRlcnJ1cHQgMDAwMDowMDoxYi4wW0FdIC0+IEdTSSAyMiAobGV2ZWwsIGxv
dykgLT4gSVJRIDIyClBDSTogU2V0dGluZyBsYXRlbmN5IHRpbWVyIG9mIGRldmljZSAwMDAw
OjAwOjFiLjAgdG8gNjQKdXNiIDMtMTogbmV3IGxvdyBzcGVlZCBVU0IgZGV2aWNlIHVzaW5n
IHVoY2lfaGNkIGFuZCBhZGRyZXNzIDIKaGRhX2NvZGVjOiBVbmtub3duIG1vZGVsIGZvciBB
TEM4ODMsIHRyeWluZyBhdXRvLXByb2JlIGZyb20gQklPUy4uLgpBQ1BJOiBQQ0kgSW50ZXJy
dXB0IDAwMDA6MDA6MWEuN1tDXSAtPiBHU0kgMTggKGxldmVsLCBsb3cpIC0+IElSUSAyMApQ
Q0k6IFNldHRpbmcgbGF0ZW5jeSB0aW1lciBvZiBkZXZpY2UgMDAwMDowMDoxYS43IHRvIDY0
CmVoY2lfaGNkIDAwMDA6MDA6MWEuNzogRUhDSSBIb3N0IENvbnRyb2xsZXIKZWhjaV9oY2Qg
MDAwMDowMDoxYS43OiBuZXcgVVNCIGJ1cyByZWdpc3RlcmVkLCBhc3NpZ25lZCBidXMgbnVt
YmVyIDcKUENJOiBjYWNoZSBsaW5lIHNpemUgb2YgMzIgaXMgbm90IHN1cHBvcnRlZCBieSBk
ZXZpY2UgMDAwMDowMDoxYS43CmVoY2lfaGNkIDAwMDA6MDA6MWEuNzogaXJxIDIwLCBpbyBt
ZW0gMHhmZGZmZTAwMAplaGNpX2hjZCAwMDAwOjAwOjFhLjc6IFVTQiAyLjAgc3RhcnRlZCwg
RUhDSSAxLjAwLCBkcml2ZXIgMTAgRGVjIDIwMDQKdXNiIHVzYjc6IGNvbmZpZ3VyYXRpb24g
IzEgY2hvc2VuIGZyb20gMSBjaG9pY2UKaHViIDctMDoxLjA6IFVTQiBodWIgZm91bmQKaHVi
IDctMDoxLjA6IDYgcG9ydHMgZGV0ZWN0ZWQKdXNiIDMtMTogZGV2aWNlIGRlc2NyaXB0b3Ig
cmVhZC9hbGwsIGVycm9yIC03MQpBQ1BJOiBQQ0kgSW50ZXJydXB0IDAwMDA6MDA6MWQuN1tB
XSAtPiBHU0kgMjMgKGxldmVsLCBsb3cpIC0+IElSUSAxOQpQQ0k6IFNldHRpbmcgbGF0ZW5j
eSB0aW1lciBvZiBkZXZpY2UgMDAwMDowMDoxZC43IHRvIDY0CmVoY2lfaGNkIDAwMDA6MDA6
MWQuNzogRUhDSSBIb3N0IENvbnRyb2xsZXIKZWhjaV9oY2QgMDAwMDowMDoxZC43OiBuZXcg
VVNCIGJ1cyByZWdpc3RlcmVkLCBhc3NpZ25lZCBidXMgbnVtYmVyIDgKUENJOiBjYWNoZSBs
aW5lIHNpemUgb2YgMzIgaXMgbm90IHN1cHBvcnRlZCBieSBkZXZpY2UgMDAwMDowMDoxZC43
CmVoY2lfaGNkIDAwMDA6MDA6MWQuNzogaXJxIDE5LCBpbyBtZW0gMHhmZGZmZDAwMAplaGNp
X2hjZCAwMDAwOjAwOjFkLjc6IFVTQiAyLjAgc3RhcnRlZCwgRUhDSSAxLjAwLCBkcml2ZXIg
MTAgRGVjIDIwMDQKdXNiIHVzYjg6IGNvbmZpZ3VyYXRpb24gIzEgY2hvc2VuIGZyb20gMSBj
aG9pY2UKaHViIDgtMDoxLjA6IFVTQiBodWIgZm91bmQKaHViIDgtMDoxLjA6IDYgcG9ydHMg
ZGV0ZWN0ZWQKdXNibHA6IGNhbid0IHNldCBkZXNpcmVkIGFsdHNldHRpbmcgMCBvbiBpbnRl
cmZhY2UgMApBQ1BJOiBQQ0kgSW50ZXJydXB0IDAwMDA6MDE6MDAuMFtBXSAtPiBHU0kgMTYg
KGxldmVsLCBsb3cpIC0+IElSUSAxNgpQQ0k6IFNldHRpbmcgbGF0ZW5jeSB0aW1lciBvZiBk
ZXZpY2UgMDAwMDowMTowMC4wIHRvIDY0Ck5WUk06IGxvYWRpbmcgTlZJRElBIFVOSVggeDg2
IEtlcm5lbCBNb2R1bGUgIDE2OS4wOSAgRnJpIEphbiAxMSAxNDozODoyOCBQU1QgMjAwOAp1
c2IgMi0xOiBVU0IgZGlzY29ubmVjdCwgYWRkcmVzcyAyCnVzYmNvcmU6IHJlZ2lzdGVyZWQg
bmV3IGludGVyZmFjZSBkcml2ZXIgdXNibHAKdXNiIDgtNTogbmV3IGhpZ2ggc3BlZWQgVVNC
IGRldmljZSB1c2luZyBlaGNpX2hjZCBhbmQgYWRkcmVzcyAyCnVzYiA4LTU6IGNvbmZpZ3Vy
YXRpb24gIzEgY2hvc2VuIGZyb20gMSBjaG9pY2UKSW5pdGlhbGl6aW5nIFVTQiBNYXNzIFN0
b3JhZ2UgZHJpdmVyLi4uCnVzYiAyLTE6IG5ldyBmdWxsIHNwZWVkIFVTQiBkZXZpY2UgdXNp
bmcgdWhjaV9oY2QgYW5kIGFkZHJlc3MgMwp1c2IgMi0xOiBjb25maWd1cmF0aW9uICMxIGNo
b3NlbiBmcm9tIDEgY2hvaWNlCnVzYmxwMDogVVNCIEJpZGlyZWN0aW9uYWwgcHJpbnRlciBk
ZXYgMyBpZiAwIGFsdCAwIHByb3RvIDIgdmlkIDB4NDEzQyBwaWQgMHg1MjEwCnVzYiAzLTE6
IG5ldyBsb3cgc3BlZWQgVVNCIGRldmljZSB1c2luZyB1aGNpX2hjZCBhbmQgYWRkcmVzcyA0
CkFkZGluZyAxOTUxNzM2ayBzd2FwIG9uIC9kZXYvbWQzLiAgUHJpb3JpdHk6LTEgZXh0ZW50
czoxIGFjcm9zczoxOTUxNzM2awp1c2IgMy0xOiBjb25maWd1cmF0aW9uICMxIGNob3NlbiBm
cm9tIDEgY2hvaWNlCg==
--------------070209070307060307080700--
