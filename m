Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbXKNQJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbXKNQJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbXKNQJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:09:16 -0500
Received: from mk-filter-3-a-2.mail.uk.tiscali.com ([212.74.100.50]:20748 "EHLO
	mk-filter-3-a-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599AbXKNQJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:09:14 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 11:09:12 EST
X-Trace: 645871035-mk-filter-3.mail.uk.tiscali.com-WEBB2C-$ALLOWED_RELAY-ALLOWED-B2C-WEBMAIL
X-SBRS: -0.5
X-RemoteIP: 212.74.100.146
X-IP-MAIL-FROM: martinpeterclarke@tiscali.co.uk
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAJqpOkfUSmSSX2dsb2JhbACBW40dFQso
Message-ID: <3189710.1195055945259.JavaMail.root@ps36.mc.tiscali.sys>
Date: Wed, 14 Nov 2007 16:59:05 +0100 (GMT+01:00)
From: "martinpeterclarke@tiscali.co.uk" <martinpeterclarke@tiscali.co.uk>
Reply-To: "martinpeterclarke@tiscali.co.uk" <martinpeterclarke@tiscali.co.uk>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: IM Kernel Failure 12/11/07
Cc: martin.clarke@investmaster.com
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
xOriginalSenderIP: 80.229.39.194
X-Priority: 2 (High)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 5th attempt to email you!  I keep being Greylisted!  I've 
extracted the minimal info from a zip which may be failing.

I've had to send it from my personal Tiscali account.

Regards
Martin

[1.] One line summary of the problem:    

	System crashed the night of Monday Nov 12 at 22:01 

[2.] Full description of the problem/report:

	There is a cronjob at that time

	00 22 * * * . /usr/local/bin/backup_RCP_CVSROOT.sh > 
/usr/local/bin/cvs_backup.log 2>&1

[3.] Keywords (i.e., modules, networking, kernel):

	kernel

[4.] Kernel version (from /proc/version):

	Linux version 2.4.9-e.38smp (bhcompile@porky.devel.redhat.com) (gcc 
version 2.96 20000731 (Red Hat Linux 7.2 2.96-124.7.2)) #1 SMP Wed Feb 
11 00:09:01 EST 2004

[5.] Output of Oops.. message (if applicable) with symbolic 
information resolved (see Documentation/oops-tracing.txt)

	NO OOPS'ES !

		vi ./usr/src/linux-2.4.9-e.3/Documentation/oops-tracing.txt	
	
			will investigate ... not ... intuitive at first read!

[6.] A small shell script or example program which triggers the 
problem (if possible)

	N/A

[7.] Environment

	Er ... a Dell box I think!

[7.1.] Software (add the output of the ver_linux script here)

[root@pleco /]# sh ./usr/src/linux-2.4.9-e.3/scripts/ver_linux

If some fields are empty or look unusual you may have an old version.

Compare to the current minimal requirements in Documentation/Changes.

Linux pleco.investmaster.com 2.4.9-e.38smp #1 SMP Wed Feb 11 00:09:01 
EST 2004 i686 unknown

Gnu C                  2.96
Gnu make               3.79.1
binutils               2.11.90.0.8
util-linux             2.11f
mount                  2.11g
modutils               2.4.13
e2fsprogs              1.26
reiserfsprogs          3.x.0j
PPP                    2.4.1
isdn4k-utils           3.1pre1
Linux C Library        2.2.4
Dynamic linker (ldd)   2.2.4
Procps                 2.0.7
Net-tools              1.60
Console-tools          0.3.3
Sh-utils               2.0.11
Modules Loaded         soundcore ide-tape lp parport sr_mod ide-cd 
cdrom sg esm autofs nfs lockd sunrpc ppp_async ppp_generic slhc tg3 
ipchains st usb-ohci usbcore ext3 jbd aic7xxx sd_mod scsi_mod

[7.2.] Processor information (from vi /proc/cpuinfo):

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.40GHz
stepping        : 9
cpu MHz         : 2386.846
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
bogomips        : 4757.91

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.40GHz
stepping        : 9
cpu MHz         : 2386.846
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
bogomips        : 4771.02

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.40GHz
stepping        : 9
cpu MHz         : 2386.846
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
bogomips        : 4771.02

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.40GHz
stepping        : 9
cpu MHz         : 2386.846
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
bogomips        : 4771.02

[7.3.] Module information (from vi /proc/modules):

soundcore               7940   0 (autoclean)
ide-tape               61120   0 (autoclean)
lp                      8192   0 (autoclean)
parport                38144   0 (autoclean) [lp]
sr_mod                 17560   0 (autoclean) (unused)
ide-cd                 35296   0 (autoclean)
cdrom                  35520   0 (autoclean) [sr_mod ide-cd]
sg                     35076   0 (autoclean)
esm                    84239   1
autofs                 13796   0 (autoclean) (unused)
nfs                    98592   2 (autoclean)
lockd                  61184   1 (autoclean) [nfs]
sunrpc                 84432   1 (autoclean) [nfs lockd]
ppp_async               8480   1
ppp_generic            26664   3 [ppp_async]
slhc                    6776   0 [ppp_generic]
tg3                    50528   1
ipchains               47760   0
st                     30548   0
usb-ohci               23456   0 (unused)
usbcore                68864   1 [usb-ohci]
ext3                   70944   4
jbd                    55444   4 [ext3]
aic7xxx               127200   5
sd_mod                 13920   5
scsi_mod              126812   5 [sr_mod sg st aic7xxx sd_mod]

[7.4.] Loaded driver and hardware information (vi /proc/ioports, vi 
/proc/iomem)

0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0070-007f : rtc
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
02f8-02ff : serial(auto)
03c0-03df : vga+
03f6-03f6 : ide0
03f8-03ff : serial(auto)
08b0-08bf : ServerWorks CSB5 IDE Controller
08c0-08c7 : ServerWorks CSB5 IDE Controller
08c8-08cb : ServerWorks CSB5 IDE Controller
08d0-08d7 : ServerWorks CSB5 IDE Controller
08d8-08db : ServerWorks CSB5 IDE Controller
0cf8-0cff : PCI conf1
a000-afff : PCI Bus #05
  a800-a8ff : Adaptec 7899P (#2)
    a800-a8fe : aic7xxx
  ac00-acff : Adaptec 7899P
    ac00-acfe : aic7xxx
d800-d8ff : Adaptec 7899A (#2)
  d800-d8fe : aic7xxx
dc00-dcff : Adaptec 7899A
  dc00-dcfe : aic7xxx
e800-e8ff : ATI Technologies Inc Rage XL
ec80-ecbf : Dell Computer Corporation PowerEdge Expandable RAID 
Controller 3/Di
  ec80-ec87 : serial(set)
ece8-ecef : PCI device 1028:000c (Dell Computer Corporation)
ecf4-ecf7 : PCI device 1028:000d (Dell Computer Corporation)
ecf8-ecff : PCI device 1028:000c (Dell Computer Corporation)

[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: ServerWorks: Unknown device 0014 (rev 33)
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-

00:00.1 Host bridge: ServerWorks: Unknown device 0014
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-

00:00.2 Host bridge: ServerWorks: Unknown device 0014
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-

00:04.0 Class ff00: Dell Computer Corporation: Unknown device 000c
        Subsystem: Dell Computer Corporation: Unknown device 000c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, cache line size 10
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at feb80000 (32-bit, prefetchable) [size=4K]
        Region 1: I/O ports at ecf8 [size=8]
        Region 2: I/O ports at ece8 [size=8]
        Expansion ROM at fe000000 [disabled] [size=64K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,
D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:04.1 Class ff00: Dell Computer Corporation PowerEdge Expandable 
RAID Controller 3/Di
        Subsystem: Dell Computer Corporation PowerEdge Expandable RAID 
Controller 3/Di
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 23
        Region 0: Memory at fe102000 (32-bit, non-prefetchable) 
[size=4K]
        Region 1: I/O ports at ec80 [size=64]
        Region 2: Memory at feb00000 (32-bit, prefetchable) 
[size=512K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,
D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:04.2 Class ff00: Dell Computer Corporation: Unknown device 000d
        Subsystem: Dell Computer Corporation: Unknown device 000d
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 27
        Region 0: I/O ports at ecf4 [size=4]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,
D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0e.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 
27) (prog-if 00 [VGA])
        Subsystem: Dell Computer Corporation: Unknown device 0121
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ 
ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min), cache line size 10
        Region 0: Memory at fd000000 (32-bit, non-prefetchable) 
[size=16M]
        Region 1: I/O ports at e800 [size=256]
        Region 2: Memory at fe101000 (32-bit, non-prefetchable) 
[size=4K]
        Expansion ROM at <unassigned> [disabled] [size=128K]
        Capabilities: [5c] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,
D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0f.0 Host bridge: ServerWorks CSB5 South Bridge (rev 93)
        Subsystem: ServerWorks CSB5 South Bridge
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Latency: 32

00:0f.1 IDE interface: ServerWorks CSB5 IDE Controller (rev 93) (prog-
if 82 [Master PriP])
        Subsystem: ServerWorks CSB5 IDE Controller
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Region 0: I/O ports at 08c0 [size=8]
        Region 1: I/O ports at 08c8 [size=4]
        Region 2: I/O ports at 08d0 [size=8]
        Region 3: I/O ports at 08d8 [size=4]
        Region 4: I/O ports at 08b0 [size=16]

00:0f.2 USB Controller: ServerWorks OSB4/CSB5 OHCI USB Controller (rev 
05) (prog-if 10 [OHCI])
        Subsystem: ServerWorks OSB4/CSB5 OHCI USB Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (20000ns max)
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at fe100000 (32-bit, non-prefetchable) 
[size=4K]

00:0f.3 ISA bridge: ServerWorks: Unknown device 0225
        Subsystem: ServerWorks: Unknown device 0230
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:10.0 Host bridge: ServerWorks: Unknown device 0101 (rev 05)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Capabilities: [60] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=4
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

00:10.2 Host bridge: ServerWorks: Unknown device 0101 (rev 05)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Capabilities: [60] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=4
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

00:11.0 Host bridge: ServerWorks: Unknown device 0101 (rev 05)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Capabilities: [60] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=4
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

00:11.2 Host bridge: ServerWorks: Unknown device 0101 (rev 05)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Capabilities: [60] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=4
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

01:08.0 SCSI storage controller: Adaptec 7899A (rev 01)
        Subsystem: Adaptec: Unknown device f620
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (10000ns min, 6250ns max), cache line size 10
        Interrupt: pin A routed to IRQ 20
        BIST result: 00
        Region 0: I/O ports at dc00 [size=256]
        Region 1: Memory at fcf01000 (64-bit, non-prefetchable) 
[size=4K]
        Expansion ROM at fce00000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,
D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:08.1 SCSI storage controller: Adaptec 7899A (rev 01)
        Subsystem: Adaptec: Unknown device f620
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (10000ns min, 6250ns max), cache line size 10
        Interrupt: pin B routed to IRQ 21
        BIST result: 00
        Region 0: I/O ports at d800 [size=256]
        Region 1: Memory at fcf00000 (64-bit, non-prefetchable) 
[size=4K]
        Expansion ROM at fce00000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,
D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

03:06.0 Ethernet controller: BROADCOM Corporation: Unknown device 16a7 
(rev 02)
        Subsystem: Dell Computer Corporation: Unknown device 0121
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (16000ns min), cache line size 10
        Interrupt: pin A routed to IRQ 28
        Region 0: Memory at fcd10000 (64-bit, non-prefetchable) 
[size=64K]
        Capabilities: [40] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=0
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,
D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable+ DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: 64bit+ 
Queue=0/3 Enable-
                Address: 3ccb5f8345104190  Data: 2bd9

03:08.0 Ethernet controller: BROADCOM Corporation: Unknown device 16a7 
(rev 02)
        Subsystem: Dell Computer Corporation: Unknown device 0121
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (16000ns min), cache line size 10
        Interrupt: pin A routed to IRQ 29
        Region 0: Memory at fcd00000 (64-bit, non-prefetchable) 
[size=64K]
        Capabilities: [40] PCI-X non-bridge device.
                Command: DPERE- ERO+ RBC=0 OST=0
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,
D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: 64bit+ 
Queue=0/3 Enable-
                Address: 5cbcd7d402670c00  Data: e809

04:08.0 PCI bridge: Intel Corporation: Unknown device 0309 (rev 01) 
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, cache line size 10
        Bus: primary=04, secondary=05, subordinate=05, sec-latency=32
        I/O behind bridge: 0000a000-0000afff
        Memory behind bridge: fca00000-fcbfffff
        Prefetchable memory behind bridge: fff00000-000fffff
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,
D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:06.0 SCSI storage controller: Adaptec 7899P (rev 01)
        Subsystem: Dell Computer Corporation: Unknown device 0121
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (10000ns min, 6250ns max), cache line size 10
        Interrupt: pin A routed to IRQ 30
        BIST result: 00
        Region 0: I/O ports at ac00 [size=256]
        Region 1: Memory at fcaff000 (64-bit, non-prefetchable) 
[size=4K]
        Expansion ROM at fcb00000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,
D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:06.1 SCSI storage controller: Adaptec 7899P (rev 01)
        Subsystem: Dell Computer Corporation: Unknown device 0121
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (10000ns min, 6250ns max), cache line size 10
        Interrupt: pin B routed to IRQ 31
        BIST result: 00
        Region 0: I/O ports at a800 [size=256]
        Region 1: Memory at fcafe000 (64-bit, non-prefetchable) 
[size=4K]
        Expansion ROM at fcb00000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,
D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

[7.6.] SCSI information (from vi /proc/scsi/scsi)

Attached devices:
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: BNCHMARK Model: DLT1             Rev: 5538
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: MAXTOR   Model: ATLAS10K4_73SCA  Rev: DFM0
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 01 Lun: 00
  Vendor: MAXTOR   Model: ATLAS10K4_73SCA  Rev: DFM0
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 02 Lun: 00
  Vendor: MAXTOR   Model: ATLAS10K4_73SCA  Rev: DFM0
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 06 Lun: 00
  Vendor: PE/PV    Model: 1x5 SCSI BP      Rev: 1.1
  Type:   Processor                        ANSI SCSI revision: 02

[7.7.] Other information that might be relevant to the problem (please 
look in /proc and include all information that you think to be 
relevant):

	I dread to think!

[X.] Other notes, patches, fixes, workarounds:


extract from msgNov12.lis (attached) 

	[root@pleco sysconfig]# grep "Nov 12" /var/log/messages > msgNov12.
lis

Line no.

437	Nov  12	04:02:01  pleco	syslogd 1.4.1: restart.

1282	Nov  12	11:42:05  pleco	sshd(pam_unix)[18121]: session opened for 
user oracle by (uid=0)
1373	Nov  12	12:36:03  pleco	pam_rhosts_auth[18283]: allowed to 
jnijjar@bloater as wmfo
1374	Nov  12	12:36:03  pleco	rsh(pam_unix)[18283]: session opened for 
user wmfo by (uid=0)
1375	Nov  12	12:36:03  pleco	rsh(pam_unix)[18283]: session closed for 
user wmfo
1376	Nov  12	12:36:03  pleco	pam_rhosts_auth[18285]: allowed to 
jnijjar@bloater as wmfo
1377	Nov  12	12:36:03  pleco	rsh(pam_unix)[18285]: session opened for 
user wmfo by (uid=0)
1378	Nov  12	12:36:03  pleco	rsh(pam_unix)[18285]: session closed for 
user wmfo
1379	Nov  12	12:36:03  pleco	pam_rhosts_auth[18287]: allowed to 
jnijjar@bloater as wmfo
1380	Nov  12	12:36:03  pleco	rsh(pam_unix)[18287]: session opened for 
user wmfo by (uid=0)
1381	Nov  12	12:36:03  pleco	pam_rhosts_auth[18288]: allowed to 
jnijjar@bloater as wmfo
1382	Nov  12	12:36:03  pleco	rsh(pam_unix)[18288]: session opened for 
user wmfo by (uid=0)
1383	Nov  12	12:36:03  pleco	pam_rhosts_auth[18289]: allowed to 
jnijjar@bloater as wmfo
1384	Nov  12	12:36:03  pleco	rsh(pam_unix)[18289]: session opened for 
user wmfo by (uid=0)
1385	Nov  12	12:36:03  pleco	rsh(pam_unix)[18289]: session closed for 
user wmfo
1386	Nov  12	12:36:03  pleco	pam_rhosts_auth[18292]: allowed to 
jnijjar@bloater as wmfo
1387	Nov  12	12:36:03  pleco	rsh(pam_unix)[18292]: session opened for 
user wmfo by (uid=0)
1388	Nov  12	12:36:03  pleco	rsh(pam_unix)[18292]: session closed for 
user wmfo
1389	Nov  12	12:36:03  pleco	pam_rhosts_auth[18295]: allowed to 
jnijjar@bloater as wmfo
1390	Nov  12	12:36:04  pleco	rsh(pam_unix)[18295]: session opened for 
user wmfo by (uid=0)
1391	Nov  12	12:36:06  pleco	rsh(pam_unix)[18295]: session closed for 
user wmfo
1392	Nov  12	12:36:06  pleco	pam_rhosts_auth[18362]: allowed to 
jnijjar@bloater as wmfo
1393	Nov  12	12:36:06  pleco	rsh(pam_unix)[18362]: session opened for 
user wmfo by (uid=0)
1394	Nov  12	12:36:09  pleco	rsh(pam_unix)[18362]: session closed for 
user wmfo
1395	Nov  12	12:36:09  pleco	pam_rhosts_auth[18417]: allowed to 
jnijjar@bloater as wmfo
1396	Nov  12	12:36:09  pleco	rsh(pam_unix)[18417]: session opened for 
user wmfo by (uid=0)
1397	Nov  12	12:36:22  pleco	rsh(pam_unix)[18417]: session closed for 
user wmfo
1398	Nov  12	12:36:22  pleco	pam_rhosts_auth[18510]: allowed to 
jnijjar@bloater as wmfo
1399	Nov  12	12:36:22  pleco	rsh(pam_unix)[18510]: session opened for 
user wmfo by (uid=0)
1400	Nov  12	12:36:22  pleco	rsh(pam_unix)[18510]: session closed for 
user wmfo
1401	Nov  12	12:36:22  pleco	pam_rhosts_auth[18513]: allowed to 
jnijjar@bloater as wmfo
1402	Nov  12	12:36:22  pleco	rsh(pam_unix)[18513]: session opened for 
user wmfo by (uid=0)
1403	Nov  12	12:36:22  pleco	pam_rhosts_auth[18514]: allowed to 
jnijjar@bloater as wmfo
1404	Nov  12	12:36:22  pleco	rsh(pam_unix)[18514]: session opened for 
user wmfo by (uid=0)

1549	Nov  12	13:55:02  pleco	login(pam_unix)[18605]: authentication 
failure; logname= uid=0 euid=0 tty=pts/2 ruser= rhost=portwrinkle  
user=cvsadmin
1550	Nov  12	13:55:04  pleco	login[18605]: FAILED LOGIN 1 FROM 
portwrinkle FOR cvsadmin, Authentication failure
1551	Nov  12	13:55:16  pleco	login[18605]: FAILED LOGIN 2 FROM 
portwrinkle FOR cvsadmin, Authentication failure
1552	Nov  12	13:56:32  pleco	login(pam_unix)[18609]: session opened 
for user cvsadmin by (uid=0)
1553	Nov  12	13:56:32  pleco	-- cvsadmin[18609]: LOGIN ON pts/2 BY 
cvsadmin FROM portwrinkle

1788	Nov  12	15:59:30  pleco	su(pam_unix)[18908]: session opened for 
user root by oracle(uid=502)
1789	Nov  12	16:00:21  pleco	su(pam_unix)[18908]: session closed for 
user root
1790	Nov  12	16:00:44  pleco	su(pam_unix)[18978]: session opened for 
user root by oracle(uid=502)
1809	Nov  12	16:04:32  pleco	su(pam_unix)[19029]: session opened for 
user oracle by oracle(uid=0)
1810	Nov  12	16:04:32  pleco	su(pam_unix)[19029]: session closed for 
user oracle
1811	Nov  12	16:04:32  pleco	vncserver: vncserver shutdown failed
1812	Nov  12	16:04:42  pleco	su(pam_unix)[19051]: session opened for 
user oracle by oracle(uid=0)
1813	Nov  12	16:04:42  pleco	su: A VNC server is already running as :1
1814	Nov  12	16:04:42  pleco	su(pam_unix)[19051]: session closed for 
user oracle
1815	Nov  12	16:04:43  pleco	vncserver: vncserver start failed
1816	Nov  12	16:04:54  pleco	su(pam_unix)[19073]: session opened for 
user oracle by oracle(uid=0)
1817	Nov  12	16:04:54  pleco	su(pam_unix)[19073]: session closed for 
user oracle
1818	Nov  12	16:04:54  pleco	vncserver: vncserver shutdown failed
1819	Nov  12	16:04:55  pleco	su(pam_unix)[18978]: session closed for 
user root
1820	Nov  12	16:05:10  pleco	su(pam_unix)[19082]: session opened for 
user root by oracle(uid=502)
1821	Nov  12	16:05:14  pleco	su(pam_unix)[19124]: session opened for 
user oracle by oracle(uid=0)
1822	Nov  12	16:05:14  pleco	su(pam_unix)[19124]: session closed for 
user oracle
1823	Nov  12	16:05:14  pleco	vncserver: vncserver shutdown failed
1824	Nov  12	16:05:19  pleco	su(pam_unix)[19146]: session opened for 
user oracle by oracle(uid=0)
1825	Nov  12	16:05:20  pleco	su: A VNC server is already running as :1
1826	Nov  12	16:05:20  pleco	su(pam_unix)[19146]: session closed for 
user oracle
1827	Nov  12	16:05:20  pleco	vncserver: vncserver start failed
1828	Nov  12	16:05:26  pleco	su(pam_unix)[19082]: session closed for 
user root
1829	Nov  12	16:05:28  pleco	sshd(pam_unix)[18121]: session closed for 
user oracle

2014	Nov  12	17:29:37  pleco	sshd(pam_unix)[19263]: session opened for 
user oracle by (uid=0)

2059	Nov  12	17:47:10  pleco	su(pam_unix)[19329]: session opened for 
user root by oracle(uid=502)
2060	Nov  12	17:48:21  pleco	su(pam_unix)[19329]: session closed for 
user root
2071	Nov  12	17:52:02  pleco	gnome-name-server[19450]: starting
2072	Nov  12	17:52:02  pleco	gnome-name-server[19450]: name server 
starting
2077	Nov  12	17:52:04  pleco	gconfd (oracle-19457): starting (version 
1.0.4), pid 19457 user 'oracle'
2078	Nov  12	17:52:04  pleco	gconfd (oracle-19457): Successfully 
registered `OAFIID:gconfd:19991118'
2079	Nov  12	17:52:04  pleco	gconfd (oracle-19457): Unable to open 
saved state file '/usr/oracle/.gconfd/saved_state': No such file or 
directory
2080	Nov  12	17:52:04  pleco	xinetd[19469]: warning: can't get client 
address: Transport endpoint is not connected
2089	Nov  12	17:57:04  pleco	gconfd (oracle-19457): 1 items remain in 
the cache after cleaning already-synced items older than 300 seconds

2198	Nov  12	18:46:45  pleco	su(pam_unix)[19650]: session opened for 
user root by oracle(uid=502)
2199	Nov  12	18:46:54  pleco	su(pam_unix)[19650]: session closed for 
user root
2200	Nov  12	18:47:34  pleco	sshd(pam_unix)[19263]: session closed for 
user oracle

2247	Nov  12	19:06:54  pleco	sshd(pam_unix)[19997]: session opened for 
user oracle by (uid=0)

2272	Nov  12	19:13:26  pleco	su(pam_unix)[20050]: session opened for 
user root by oracle(uid=502)
2273	Nov  12	19:13:34  pleco	su(pam_unix)[20092]: session opened for 
user oracle by oracle(uid=0)
2274	Nov  12	19:13:34  pleco	gnome-name-server[19450]: input condition 
is: 0x11, exiting
2275	Nov  12	19:13:34  pleco	su(pam_unix)[20092]: session closed for 
user oracle
2276	Nov  12	19:13:34  pleco	vncserver: vncserver shutdown succeeded
2277	Nov  12	19:14:03  pleco	su(pam_unix)[20132]: session opened for 
user oracle by oracle(uid=0)
2278	Nov  12	19:14:06  pleco	su:	
2279	Nov  12	19:14:06  pleco	su: New 'X' desktop is pleco.investmaster.
com:2
2280	Nov  12	19:14:06  pleco	su:	
2281	Nov  12	19:14:06  pleco	su: Starting ap	plications specified in 
/usr/oracle/.vnc/xstartup
2282	Nov  12	19:14:06  pleco	su: Log file is/usr/oracle/.vnc/pleco.
investmaster.com:2.log
2283	Nov  12	19:14:06  pleco	su:	
2284	Nov  12	19:14:06  pleco	su(pam_unix)[20	132]: session closed for 
user oracle
2285	Nov  12	19:14:06  pleco	vncserver: vncserver startup succeeded
2286	Nov  12	19:14:09  pleco	gnome-name-server[20198]: starting
2287	Nov  12	19:14:09  pleco	gnome-name-server[20198]: name server 
starting
2288	Nov  12	19:14:12  pleco	su(pam_unix)[20050]: session closed for 
user root
2289	Nov  12	19:14:25  pleco	su(pam_unix)[20325]: session opened for 
user root by oracle(uid=502)
2290	Nov  12	19:14:33  pleco	su(pam_unix)[20325]: session closed for 
user root
2291	Nov  12	19:14:38  pleco	sshd(pam_unix)[19997]: session closed for 
user oracle
2292	Nov  12	19:17:04  pleco	gconfd (oracle-19457): 1 items remain in 
the cache after cleaning already-synced items older than 300 seconds

2639	Nov  12	22:01:37  pleco	kernel: Unable to handle kernel paging 
request at virtual address 1aaf2008
2640	Nov  12	22:01:37  pleco	kernel: printing eip:
2641	Nov  12	22:01:37  pleco	kernel: c01315df
2642	Nov  12	22:01:37  pleco	kernel: *pde = 0
2643	Nov  12	22:01:37  pleco	kernel: Oops: 00
2644	Nov  12	22:01:37  pleco	kernel: Kernel 2.4.9-e.38smp
2645	Nov  12	22:01:37  pleco	kernel: CPU: 0
2646	Nov  12	22:01:37  pleco	kernel: EIP: 0010:
[do_generic_file_read+463/1680]    Tainted: P
2647	Nov  12	22:01:37  pleco	kernel: EIP: 0010:[<c01315df>]    
Tainted: P
2648	Nov  12	22:01:37  pleco	kernel: EFLAGS:	10206
2649	Nov  12	22:01:37  pleco	kernel: EIP isat do_generic_file_read 
[kernel] 0x1cf
2650	Nov  12	22:01:37  pleco	kernel: eax: 1aaf2000   ebx: 00000001   
ecx: 00000013   edx: f77d5378
2651	Nov  12	22:01:37  pleco	kernel: esi: 00000000   edi: e43e8d38   
ebp: 00000000   esp: e2525ef8
2652	Nov  12	22:01:37  pleco	kernel: ds: 0018   es: 0018   ss: 0018
2653	Nov  12	22:01:37  pleco	kernel: Processtar (pid: 20836, 
stackpage=e2525000)
2654	Nov  12	22:01:37  pleco	kernel: Stack: 00001000 f77d537c 00000001 
00000000 00000000 e43e8c80 00000322 e43e8c80
2655	Nov  12	22:01:37  pleco	kernel:	00000004 00008001 00000000 
0806f528 00000000 00001600 c0131c27 cc263bc0
2656	Nov  12	22:01:37  pleco	kernel:	cc263be0 e2525f48 c0131aa0 
00000000 00000000 00001600 0806f528 00000000
2657	Nov  12	22:01:37  pleco	kernel: Call Trace: 
[generic_file_new_read+103/128] generic_file_new_read [kernel] 0x67 
(0xe2525f30)
2658	Nov  12	22:01:37  pleco	kernel: Call Trace: [<c0131c27>] 
generic_file_new_read [kernel] 0x67 (0xe2525f30)
2659	Nov  12	22:01:37  pleco	kernel: [file_read_actor+0/256] 
file_read_actor [kernel] 0x0 (0xe2525f40)
2660	Nov  12	22:01:37  pleco	kernel: [<c0131aa0>] file_read_actor 
[kernel] 0x0 (0xe2525f40)
2661	Nov  12	22:01:38  pleco	kernel: [generic_file_read+27/32] 
generic_file_read [kernel] 0x1b (0xe2525f64)
2662	Nov  12	22:01:38  pleco	kernel: [<c0131bbb>] generic_file_read 
[kernel] 0x1b (0xe2525f64)
2663	Nov  12	22:01:38  pleco	kernel: [sys_red+150/288] sys_read 
[kernel] 0x96 (0xe2525f7c)
2664	Nov  12	22:01:38  pleco	kernel: [<c0145cd6>] sys_read [kernel] 
0x96 (0xe2525f7c)
2665	Nov  12	22:01:38  pleco	kernel: [sys_open+149/224] sys_open 
[kernel] 0x95 (0xe2525fa4)
2666	Nov  12	22:01:38  pleco	kernel: [<c01456e5>] sys_open [kernel] 
0x95 (0xe2525fa4)
2667	Nov  12	22:01:38  pleco	kernel: [system_call+51/56] system_call 
[kernel] 0x33 (0xe2525fc0)
2668	Nov  12	22:01:38  pleco	kernel: [<c01073e3>] system_call [kernel] 
0x33 (0xe2525fc0)
2669	Nov  12	22:01:38  pleco	kernel:	
2670	Nov  12	22:01:38  pleco	kernel:	
2671	Nov  12	22:01:38  pleco	kernel: Code: 3	9 78 08 75 f4 39 68 0c 75 
ef 89 c6 85 f6 0f 84 8d 02 00 00

	Nov  13	14:36:33  pleco syslogd 1.4.1: restart.	

Martin Peter Clarke - Oracle DBA
Investmaster Group Ltd 
5 Granville Road 
Leicester 
LE1 7RU 

Direct Line: +44 (0)116 224 5033

Mob: +44 (0)7776 306523

Switchboard: +44 (0)116 233 5050
Fax:             +44 (0)116 255 0822 



__________________________________________________
Get an exclusive discount on Norton 360 from Tiscali 
http://www.tiscali.co.uk/products/securepc
