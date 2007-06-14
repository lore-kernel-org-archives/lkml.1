Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbXFNWQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbXFNWQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbXFNWOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:14:10 -0400
Received: from webmail.aksakovo.net ([88.203.138.66]:40621 "EHLO
	webmail.aksakovo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbXFNWOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:14:06 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 18:14:04 EDT
X-Antivirus-Aksakovo.net-Mail-From: casper@aksakovo.net via twister
X-Antivirus-Aksakovo.net: 1.22-st-qms (Clear:RC:1(127.0.0.1):. Processed in 8.140974 secs Process 25806)
Message-ID: <4272.88.203.138.254.1181858752.squirrel@mail.aksakovo.net>
Date: Fri, 15 Jun 2007 01:05:52 +0300 (EEST)
Subject: SATAII+ICH7 Device Restart
From: "Martin Diakov" <casper@aksakovo.net>
To: linux-kernel@vger.kernel.org
Reply-To: casper@aksakovo.net
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=windows-1251
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there.
First sorry for my bad english.
Now i have a problem with ICH7 and my 2x160GB WD SATA300 16Mb Cache.

I have bought intel server board s3000ah for my new web site i have
installed Slackware 11.0 and upgrade my kernel to 2.6.21.1 and everything
is working fine to the moment when i reach a big number users and my linux
pc is dieing.

My problem is that with alot number of users and big number of requests to
the harddrive (mysql, apache, gd, php and etc...) my linux is freeze for
one - five minutes.
I have saw this problem when i coping big file like 2GB or 700Mb from one
location to another and my speed of coping is starting from 90mb/sec and
then is slowing down to 2-3 mb/sec. and my hard drives is reseting.
The problem is not with the drives becouse i testet with another couple
with hard drives in the case were seagate baracuda 80GB sata300 16mb cache
and the problem is still online.

Now i will paste information about the linux that you are request from
http://kernel.org/pub/linux/docs/lkml/reporting-bugs.html

1 - Linux version 2.6.21.1 (root@www) (gcc version 4.1.2) #4 SMP Tue May 1
02:11:58 EEST 2007

2 - ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA stat 0x24)
ata1.00: cmd c8/00:88:7f:23:e8/00:00:00:00:00/e2 tag 0 cdb 0x0 data 69632 in
         res 51/40:00:ff:23:e8/00:00:00:00:00/e2 Emask 0x9 (media error)
ata1.00: configured for UDMA/133
ata1: EH complete

3 - processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            3050  @ 2.13GHz
stepping        : 6
cpu MHz         : 2133.486
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
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4270.09
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            3050  @ 2.13GHz
stepping        : 6
cpu MHz         : 2133.486
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
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4267.11
clflush size    : 64


4 - 0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.2
  0170-0177 : libata
01f0-01f7 : 0000:00:1f.2
  01f0-01f7 : libata
0376-0376 : 0000:00:1f.2
  0376-0376 : libata
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.2
  03f6-03f6 : libata
0400-047f : 0000:00:1f.0
  0400-047f : pnp 00:06
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-0420 : ACPI PM2_CNT_BLK
    0428-042f : ACPI GPE0_BLK
0500-053f : 0000:00:1f.0
  0500-053f : pnp 00:06
0680-06ff : pnp 00:06
0779-0780 : pnp 00:01
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus #04
  1000-10ff : 0000:04:04.0
  1100-113f : 0000:04:05.0
    1100-113f : e1000
2000-2fff : PCI Bus #03
  2000-201f : 0000:03:00.0
    2000-201f : e1000
3000-301f : 0000:00:1f.3
3020-303f : 0000:00:1d.3
3040-305f : 0000:00:1d.2
3060-307f : 0000:00:1d.1
3080-309f : 0000:00:1d.0
30a0-30af : 0000:00:1f.2
  30a0-30af : libata

5 - 00000000-0009fbff : System RAM
000a0000-000bffff : Video RAM area
000c0000-000c8fff : Video ROM
000f0000-000fffff : System ROM
00100000-7fc0dfff : System RAM
  00100000-002c3870 : Kernel code
  002c3871-003a3fd3 : Kernel data
7fc0e000-7fc5efff : reserved
7fc5f000-7fcdcfff : System RAM
7fcdd000-7fedefff : ACPI Non-volatile Storage
7fedf000-7fef1fff : System RAM
7fef2000-7fefefff : ACPI Tables
7feff000-7fefffff : System RAM
80000000-87ffffff : PCI Bus #04
  80000000-87ffffff : 0000:04:04.0
88000000-880fffff : PCI Bus #04
  88000000-8801ffff : 0000:04:05.0
    88000000-8801ffff : e1000
  88020000-8803ffff : 0000:04:05.0
    88020000-8803ffff : e1000
  88040000-8804ffff : 0000:04:04.0
  88060000-8807ffff : 0000:04:05.0
88100000-881fffff : PCI Bus #03
  88100000-8811ffff : 0000:03:00.0
    88100000-8811ffff : e1000
88200000-882003ff : 0000:00:1f.2
88200400-882007ff : 0000:00:1d.7
f0000000-f3ffffff : pnp 00:01
fed13000-fed13fff : pnp 00:01
fed14000-fed17fff : pnp 00:01
fed18000-fed18fff : pnp 00:01
fffc0000-fffcffff : reserved
fffe0000-ffffffff : 0000:04:04.0


6 - 00:00.0 Host bridge: Intel Corporation E7230 Memory Controller Hub
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 1
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 1, PowerLimit 25.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0
Enable+
                Address: fee0300c  Data: 41b9
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.4 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI
Express Port 5 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 5
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 5, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0
Enable+
                Address: fee0300c  Data: 41c1
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.5 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI
Express Port 6 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: 88100000-881fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 6
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 6, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0
Enable+
                Address: fee0300c  Data: 41c9
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1
(rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 10
        Region 4: I/O ports at 3080 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2
(rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 11
        Region 4: I/O ports at 3060 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3
(rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 11
        Region 4: I/O ports at 3040 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4
(rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 11
        Region 4: I/O ports at 3020 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
Controller (rev 01) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at 88200400 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if
01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: 88000000-880fffff
        Prefetchable memory behind bridge: 0000000080000000-0000000087f00000
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [50] #0d [0000]

00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC
Interface Bridge (rev 01)
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
Serial ATA Storage Controller IDE (rev 01) (prog-if 8a [Master SecP PriP])
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 30a0 [size=16]
        Region 5: Memory at 88200000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
(rev 01)
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 11
        Region 4: I/O ports at 3000 [size=32]

03:00.0 Ethernet controller: Intel Corporation 82573V Gigabit Ethernet
Controller (Copper) (rev 03)
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 220
        Region 0: Memory at 88100000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at 2000 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0
Enable+
                Address: 00000000fee0200c  Data: 41e1
        Capabilities: [e0] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <512ns, L1 <64us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
                Link: Latency L0s <128ns, L1 <64us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

04:04.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
(prog-if 00 [VGA])
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping+ SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at 80000000 (32-bit, prefetchable) [size=128M]
        Region 1: I/O ports at 1000 [size=256]
        Region 2: Memory at 88040000 (32-bit, non-prefetchable) [size=64K]
        Expansion ROM at fffe0000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

04:05.0 Ethernet controller: Intel Corporation 82541GI/PI Gigabit Ethernet
Controller (rev 05)
        Subsystem: Intel Corporation Unknown device 348f
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (63750ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at 88020000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at 88000000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at 1100 [size=64]
        Expansion ROM at 88060000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [e4] PCI-X non-bridge device
                Command: DPERE- ERO+ RBC=512 OST=1
                Status: Dev=00:00.0 64bit- 133MHz- SCD- USC- DC=simple
DMMRBC=2048 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-





Thats it from me...
Please help me.
If you have any other questions please ask.
Thanks to all for now.

