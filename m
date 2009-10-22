Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZJVMVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZJVMVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZJVMVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:21:53 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:59614 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZJVMVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:21:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=MQoKEht0Om6NfB+jwENlOdxEjNyYcfCJdm+JI+rEqgPrzFO6X6PwZLh0Ylx05OWaKn
         MXi36uweJ2HnUIc8bokVPujYDElQmYMI6DXKpgEpCiTKyjyykV8AS9nJFZEsbQ/+6SBY
         TPAjUv0ZLAom24Y4bTmNNHfUUuz9qY90gRmi4=
MIME-Version: 1.0
Date: Thu, 22 Oct 2009 14:21:55 +0200
Message-ID: <ffd8902a0910220521o2b94f2daw1aadd9b902ca497f@mail.gmail.com>
Subject: PROBLEM: WARNING: at arch/x86/kernel/apic/apic.c:249 
	native_apic_write_dummy+0x32/0x3e() (git 2.6.32-rc5)
From: Christian Hartmann <cornogle@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello kernel-hackers,

PROBLEM: WARNING: at arch/x86/kernel/apic/apic.c:
249 native_apic_write_dummy+0x32/0x3e() (git 2.6.32-rc5)

On every reboot I detect this warning message.
KEYWORDS: mce, apic

Linux version 2.6.32-rc5 (chris@oddysseus) (gcc version 4.3.4 (Debian
4.3.4-5) ) #1 PREEMPT Tue Oct 20 11:49:36 CEST 2009

chris@oddysseus:~/linux_2.6/00_2.6$ ./scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux oddysseus 2.6.32-rc5 #1 PREEMPT Tue Oct 20 11:49:36 CEST 2009
i686 GNU/Linux

Oct 22 10:40:53 oddysseus kernel: [    0.007923] CPU: Trace cache: 12K
uops, L1 D cache: 8K
Oct 22 10:40:53 oddysseus kernel: [    0.008045] CPU: L2 cache: 512K
Oct 22 10:40:53 oddysseus kernel: [    0.008136] mce: CPU supports 4 MCE banks
Oct 22 10:40:53 oddysseus kernel: [    0.008237] ------------[ cut
here ]------------
Oct 22 10:40:53 oddysseus kernel: [    0.008341] WARNING: at
arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy+0x32/0x3e()
Oct 22 10:40:53 oddysseus kernel: [    0.008493] Hardware name: 2366DG3
Oct 22 10:40:53 oddysseus kernel: [    0.008582] Modules linked in:
Oct 22 10:40:53 oddysseus kernel: [    0.008701] Pid: 0, comm: swapper
Not tainted 2.6.32-rc5 #1
Oct 22 10:40:53 oddysseus kernel: [    0.008795] Call Trace:
Oct 22 10:40:53 oddysseus kernel: [    0.008890]  [<c012a9f3>]
warn_slowpath_common+0x65/0x95
Oct 22 10:40:53 oddysseus kernel: [    0.008987]  [<c012aa35>]
warn_slowpath_null+0x12/0x15
Oct 22 10:40:53 oddysseus kernel: [    0.009083]  [<c011314c>]
native_apic_write_dummy+0x32/0x3e
Oct 22 10:40:53 oddysseus kernel: [    0.009182]  [<c010ed33>]
intel_init_thermal+0xe8/0x177
Oct 22 10:40:53 oddysseus kernel: [    0.009280]  [<c010eb5f>]
mce_intel_feature_init+0x10/0x51
Oct 22 10:40:53 oddysseus kernel: [    0.009378]  [<c05930a8>]
mcheck_init+0x22d/0x2c4
Oct 22 10:40:53 oddysseus kernel: [    0.009473]  [<c0591c15>]
identify_cpu+0x30b/0x31b
Oct 22 10:40:53 oddysseus kernel: [    0.009570]  [<c056e31e>]
identify_boot_cpu+0xd/0x23
Oct 22 10:40:53 oddysseus kernel: [    0.009665]  [<c056e3bd>]
check_bugs+0xb/0xd3
Oct 22 10:40:53 oddysseus kernel: [    0.010012]  [<c016e6a4>] ?
delayacct_init+0x47/0x4f
Oct 22 10:40:53 oddysseus kernel: [    0.010110]  [<c05686ff>]
start_kernel+0x285/0x299
Oct 22 10:40:53 oddysseus kernel: [    0.010206]  [<c056808c>]
i386_start_kernel+0x8c/0x91
Oct 22 10:40:53 oddysseus kernel: [    0.010311] ---[ end trace
4eaa2a86a8e2da22 ]---
Oct 22 10:40:53 oddysseus kernel: [    0.010405] CPU0: Thermal
monitoring enabled (TM1)
Oct 22 10:40:53 oddysseus kernel: [    0.010516] Performance Events:
no PMU driver, software events only.
Oct 22 10:40:53 oddysseus kernel: [    0.010642] CPU: Mobile Intel(R)
Pentium(R) 4 - M CPU 1.80GHz stepping 07
Oct 22 10:40:53 oddysseus kernel: [    0.010803] Checking 'hlt'
instruction... OK.

cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Mobile Intel(R) Pentium(R) 4 - M CPU 1.80GHz
stepping        : 7
cpu MHz         : 1800.000
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs
bts cid
bogomips        : 3598.06
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 32 bits virtual
power management:

ver_linux:
Gnu C                  4.3.4
Gnu make               3.81
binutils               2.20
util-linux             ./scripts/ver_linux: 23: fdformat: not found
mount                  support
module-init-tools      found
Linux C Library        2.10.1
Dynamic linker (ldd)   2.10.1
Procps                 3.2.8
Console-tools          0.2.3
Sh-utils               7.5
Modules Loaded         radeon ttm drm_kms_helper drm i2c_algo_bit
cfbcopyarea cfbimgblt cfbfillrect binfmt_misc sco bridge stp llc bnep
rfcomm l2cap bluetooth speedstep_lib cpufreq_stats cpufreq_powersave
snd_mixer_oss uvcvideo acpi_cpufreq arc4 ecb ath5k mac80211 ath
nsc_ircc video irda pcmcia cfg80211 battery processor ac button output
snd_intel8x0m uhci_hcd ehci_hcd usbcore thermal fan

cat /proc/modules
radeon 407913 2 - Live 0xf8dc6000
ttm 28474 1 radeon, Live 0xf89c4000
drm_kms_helper 17575 1 radeon, Live 0xf8920000
drm 112618 4 radeon,ttm,drm_kms_helper, Live 0xf889f000
i2c_algo_bit 3701 1 radeon, Live 0xf8819000
cfbcopyarea 3086 1 radeon, Live 0xf880c000
cfbimgblt 1857 1 radeon, Live 0xf8803000
cfbfillrect 2526 1 radeon, Live 0xf87e9000
binfmt_misc 5159 1 - Live 0xf87e5000
sco 6622 2 - Live 0xf8a32000
bridge 35218 0 - Live 0xf881c000
stp 1032 1 bridge, Live 0xf8816000
llc 2653 2 bridge,stp, Live 0xf8810000
bnep 7416 2 - Live 0xf8808000
rfcomm 26325 0 - Live 0xf87fa000
l2cap 23373 4 bnep,rfcomm, Live 0xf87ec000
bluetooth 38821 6 sco,bnep,rfcomm,l2cap, Live 0xf87d9000
speedstep_lib 2204 0 - Live 0xfa5ec000
cpufreq_stats 1797 0 - Live 0xfa5d8000
cpufreq_powersave 630 0 - Live 0xfa5c3000
snd_mixer_oss 11045 0 - Live 0xfa5af000
uvcvideo 46770 0 - Live 0xfa572000
acpi_cpufreq 3678 0 - Live 0xfa49b000
arc4 1022 2 - Live 0xfa37b000
ecb 1517 2 - Live 0xfa375000
ath5k 121501 0 - Live 0xfa34e000
mac80211 130405 1 ath5k, Live 0xfa0b8000
ath 6034 1 ath5k, Live 0xf9bb2000
nsc_ircc 10731 0 - Live 0xf9b3b000
video 14961 0 - Live 0xf9af3000
irda 77002 1 nsc_ircc, Live 0xf97e4000
pcmcia 17832 0 - Live 0xf94de000
cfg80211 87676 3 ath5k,mac80211,ath, Live 0xf9405000
battery 3970 0 - Live 0xf91dd000
processor 23071 2 acpi_cpufreq, Live 0xf91ae000
ac 1768 0 - Live 0xf9112000
button 3794 0 - Live 0xf90aa000
output 1312 1 video, Live 0xf9082000
snd_intel8x0m 8596 0 - Live 0xf906a000
uhci_hcd 16797 0 - Live 0xf8fac000
ehci_hcd 28170 0 - Live 0xf8eca000
usbcore 106258 4 uvcvideo,uhci_hcd,ehci_hcd, Live 0xf8a3c000
thermal 9638 0 - Live 0xf8827000
fan 2726 0 - Live 0xf87f7000

chris@oddysseus:~/linux_2.6/00_2.6$ cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : piix
02f8-02ff : nsc-ircc
0376-0376 : 0000:00:1f.1
  0376-0376 : piix
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : piix
03f8-03ff : serial
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
  1000-107f : pnp 00:02
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-1020 : ACPI PM2_CNT_BLK
    1028-102b : ACPI GPE0_BLK
    102c-102f : ACPI GPE1_BLK
1180-11bf : 0000:00:1f.0
  1180-11bf : pnp 00:02
15e0-15ef : pnp 00:02
1600-167f : pnp 00:02
1800-181f : 0000:00:1d.0
  1800-181f : uhci_hcd
1820-183f : 0000:00:1d.1
  1820-183f : uhci_hcd
1840-185f : 0000:00:1d.2
  1840-185f : uhci_hcd
1860-186f : 0000:00:1f.1
  1860-186f : piix
1880-189f : 0000:00:1f.3
  1880-189f : i801_smbus
18c0-18ff : 0000:00:1f.5
  18c0-18ff : Intel 82801CA-ICH3
1c00-1cff : 0000:00:1f.5
  1c00-1cff : Intel 82801CA-ICH3
2000-207f : 0000:00:1f.6
  2000-207f : Intel 82801CA-ICH3 Modem
2400-24ff : 0000:00:1f.6
  2400-24ff : Intel 82801CA-ICH3 Modem
3000-3fff : PCI Bus 0000:01
  3000-30ff : 0000:01:00.0
4000-8fff : PCI Bus 0000:02
  4000-40ff : PCI CardBus 0000:03
  4400-44ff : PCI CardBus 0000:03
  4800-48ff : PCI CardBus 0000:07
  4c00-4cff : PCI CardBus 0000:07
  8000-803f : 0000:02:08.0
    8000-803f : e100

chris@oddysseus:~/linux_2.6/00_2.6$ cat /proc/iomem
00000000-0009efff : System RAM
0009f000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cffff : Video ROM
000d0000-000d0fff : Adapter ROM
000d1000-000d1fff : Adapter ROM
000d2000-000d3fff : reserved
000dc000-000fffff : reserved
  000e0000-000effff : Extension ROM
  000f0000-000fffff : System ROM
00100000-3ff5ffff : System RAM
  00100000-0040a959 : Kernel code
  0040a95a-0056777b : Kernel data
  005ca000-00641b2f : Kernel bss
3ff60000-3ff6dfff : ACPI Tables
3ff6e000-3ff7ffff : ACPI Non-volatile Storage
3ff80000-3fffffff : reserved
40000000-47ffffff : PCI Bus 0000:02
  40000000-43ffffff : PCI CardBus 0000:03
  44000000-47ffffff : PCI CardBus 0000:07
48000000-480003ff : 0000:00:1f.1
50000000-50000fff : 0000:02:00.0
  50000000-50000fff : yenta_socket
51000000-51000fff : 0000:02:00.1
  51000000-51000fff : yenta_socket
d0100000-d01fffff : PCI Bus 0000:01
  d0100000-d010ffff : 0000:01:00.0
  d0120000-d013ffff : 0000:01:00.0
d0200000-dfffffff : PCI Bus 0000:02
  d0200000-d0200fff : 0000:02:08.0
    d0200000-d0200fff : e100
  d4000000-d7ffffff : PCI CardBus 0000:03
  d8000000-dbffffff : PCI CardBus 0000:07
    d8000000-d800ffff : 0000:07:00.0
      d8000000-d800ffff : ath5k
e0000000-e3ffffff : 0000:00:00.0
e8000000-efffffff : PCI Bus 0000:01
  e8000000-efffffff : 0000:01:00.0
ff800000-ffffffff : reserved

sudo lspci -vvv
00:00.0 Host bridge: Intel Corporation 82845 845 [Brookdale] Chipset
Host Bridge (rev 04)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at e0000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [e4] Vendor Specific Information <?>
        Capabilities: [a0] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
        Kernel driver in use: agpgart-intel

00:01.0 PCI bridge: Intel Corporation 82845 845 [Brookdale] Chipset
AGP Bridge (rev 04) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 96
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: d0100000-d01fffff
        Prefetchable memory behind bridge: e8000000-efffffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:1d.0 USB Controller: Intel Corporation 82801CA/CAM USB Controller
#1 (rev 02) (prog-if 00 [UHCI])
        Subsystem: IBM ThinkPad A/T/X Series
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 4: I/O ports at 1800 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801CA/CAM USB Controller
#2 (rev 02) (prog-if 00 [UHCI])
        Subsystem: IBM ThinkPad A/T/X Series
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 11
        Region 4: I/O ports at 1820 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801CA/CAM USB Controller
#3 (rev 02) (prog-if 00 [UHCI])
        Subsystem: IBM ThinkPad A/T/X Series
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 11
        Region 4: I/O ports at 1840 [size=32]
        Kernel driver in use: uhci_hcd
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 42)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=02, subordinate=08, sec-latency=64
        I/O behind bridge: 00004000-00008fff
        Memory behind bridge: d0200000-dfffffff
        Prefetchable memory behind bridge: 40000000-47ffffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:1f.0 ISA bridge: Intel Corporation 82801CAM ISA Bridge (LPC) (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801CAM IDE U100 Controller
(rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: IBM ThinkPad A/T/X Series
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 1860 [size=16]
        Region 5: Memory at 48000000 (32-bit, non-prefetchable) [size=1K]
        Kernel driver in use: PIIX_IDE

00:1f.3 SMBus: Intel Corporation 82801CA/CAM SMBus Controller (rev 02)
        Subsystem: IBM ThinkPad A/T/X Series
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 11
        Region 4: I/O ports at 1880 [size=32]
        Kernel driver in use: i801_smbus

00:1f.5 Multimedia audio controller: Intel Corporation 82801CA/CAM
AC'97 Audio Controller (rev 02)
        Subsystem: IBM ThinkPad T30
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 11
        Region 0: I/O ports at 1c00 [size=256]
        Region 1: I/O ports at 18c0 [size=64]
        Kernel driver in use: Intel ICH

00:1f.6 Modem: Intel Corporation 82801CA/CAM AC'97 Modem Controller
(rev 02) (prog-if 00 [Generic])
        Subsystem: IBM ThinkPad A/T/X Series
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 11
        Region 0: I/O ports at 2400 [size=256]
        Region 1: I/O ports at 2000 [size=128]
        Kernel driver in use: Intel ICH Modem

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon
Mobility M7 LW [Radeon Mobility 7500] (prog-if 00 [VGA controller])
        Subsystem: IBM ThinkPad T30
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping+ SERR+ FastB2B+ DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 66 (2000ns min), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
        Region 1: I/O ports at 3000 [size=256]
        Region 2: Memory at d0100000 (32-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at d0120000 [disabled] [size=128K]
        Capabilities: [58] AGP version 2.0
                Status: RQ=48 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
                Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit-
FW- Rate=x4
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: radeon

02:00.0 CardBus bridge: Texas Instruments PCI1520 PC card Cardbus
Controller (rev 01)
        Subsystem: IBM ThinkPad T30/T40
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168, Cache Line Size: 128 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 50000000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
        Memory window 0: 40000000-43fff000 (prefetchable)
        Memory window 1: d4000000-d7fff000
        I/O window 0: 00004000-000040ff
        I/O window 1: 00004400-000044ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001
        Kernel driver in use: yenta_cardbus

02:00.1 CardBus bridge: Texas Instruments PCI1520 PC card Cardbus
Controller (rev 01)
        Subsystem: IBM ThinkPad T30/T40
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168, Cache Line Size: 128 bytes
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at 51000000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=02, secondary=07, subordinate=07, sec-latency=176
        Memory window 0: 44000000-47fff000 (prefetchable)
        Memory window 1: d8000000-dbfff000
        I/O window 0: 00004800-000048ff
        I/O window 1: 00004c00-00004cff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
        16-bit legacy interface ports at 0001
        Kernel driver in use: yenta_cardbus

02:08.0 Ethernet controller: Intel Corporation 82801CAM (ICH3) PRO/100
VE (LOM) Ethernet Controller (rev 42)
        Subsystem: IBM ThinkPad A/T/X Series
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 66 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at d0200000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 8000 [size=64]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
        Kernel driver in use: e100

07:00.0 Ethernet controller: Atheros Communications Inc. Atheros
AR5001X+ Wireless Network Adapter (rev 01)
        Subsystem: D-Link System Inc D-Link AirPlus DWL-G650 Wireless
Cardbus Adapter(rev.C)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168 (2500ns min, 7000ns max), Cache Line Size: 128 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at d8000000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
        Kernel driver in use: ath5k


I googled and found something where the developer talks about to
enable "lapic" at boottime. Cyrill Gorcunov  wrote a patch for this
warning, when lapic is not enabled at boottime, this should already
fix this warning.
I have set this now, but I will reboot later to find out, if the this
warning will be gone with this boot option.
This thread was not June 14
@http://lkml.indiana.edu/hypermail/linux/kernel/0906.1/03853.html

sincerely
Ch. Hartmann

--
......oooO..............
.....(....).....Oooo...
......)../.....(....)....
.....(_/.......)../.....
...............(_/.......
... I WAS ..............
.......... HERE...... ;)
