Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYC0T0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYC0T0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbYC0T0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:26:05 -0400
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:48449
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138AbYC0T0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:26:00 -0400
X-Greylist: delayed 1629 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2008 15:26:00 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=nEcXshQ7B13QMFyem3iXlaVn08wCgyZAECXeaNeEBt78C7U8adLQQ1kzKNphiKLJ;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <47EBEE68.1020901@earthlink.net>
Date: Thu, 27 Mar 2008 14:58:48 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: iTCO watchdog timer
References: <47CDAC9D.6020505@seclark.us> <20080304135548.b7b88ee4.akpm@linux-foundation.org> <20080306212820.GA2866@infomag.infomag.iguana.be> <47EBE751.1090803@earthlink.net> <20080327183437.GA15490@infomag.infomag.iguana.be>
In-Reply-To: <20080327183437.GA15490@infomag.infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79a275af852fd4d1f15a3a9dd987d6f187350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 24.144.77.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim Van Sebroeck wrote:
> Hi Steve,
> 
>> Just wondered if you had any more thoughts or if you have any test you 
>> would like me to run.
> 
> Didn't had any time yet. Could you run the following watchdog test-program first and sent me the output?
> Just compile it with: gcc -o watchdog watchdog.c and then run the watchdog program.
> 
> Thanks,
> Wim.
> 
> 

[root@joker20 ~]# ./testwdog
The GETSUPPORT call reported (-1):
   options         : ?
   firmware_version: ?
   identity        : ?
The GETSTATUS call reported 0 (0)
The GETBOOTSTATUS call reported 0 (0)
The GETTEMP call reported 0°F = -17°C (ret=-1)
The SETOPTIONS (DISABLECARD) call returned=0
The SETOPTIONS (ENABLECARD) call returned=0
The timeout is 30 seconds (0)
The timeout is now set to 34 seconds (0)
The timeout is 34 seconds (0)
The GETTIMELEFT call reported 33 seconds (0x0021) (0)
The GETTIMELEFT call reported 19 seconds (0x0013) (0)
The GETTIMELEFT call reported 20 seconds (0x0014) (0)
The GETTIMELEFT call reported 21 seconds (0x0015) (0)
The GETTIMELEFT call reported 22 seconds (0x0016) (0)
The GETTIMELEFT call reported 22 seconds (0x0016) (0)

[root@joker20 ~]# lspci -vvv
00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM 
Controller (rev 02)
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
         Latency: 0
         Capabilities: [e0] Vendor Specific Information <?>
         Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express 
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 16
         Region 0: Memory at e0400000 (32-bit, non-prefetchable) [size=512K]
         Region 1: I/O ports at 3430 [size=8]
         Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
         Region 3: Memory at e0300000 (32-bit, non-prefetchable) [size=1M]
         Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                 Address: 00000000  Data: 0000
         Capabilities: [d0] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:03.0 Communication controller: Intel Corporation 82G33/G31/P35/P31 
Express MEI Controller (rev 02)
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at e04a6100 (64-bit, non-prefetchable) [size=16]
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [8c] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000

00:19.0 Ethernet controller: Intel Corporation 82566DC-2 Gigabit Network 
Connection (rev 02)
         Subsystem: Intel Corporation Unknown device 0001
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 20
         Region 0: Memory at e0480000 (32-bit, non-prefetchable) [size=128K]
         Region 1: Memory at e04a4000 (32-bit, non-prefetchable) [size=4K]
         Region 2: I/O ports at 3400 [size=32]
         Capabilities: [c8] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                 Address: 00000000fee0f00c  Data: 41b9
         Capabilities: [e0] Vendor Specific Information <?>
         Kernel driver in use: e1000e
         Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #4 (rev 02) (prog-if 00 [UHCI])
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 18
         Region 4: I/O ports at 30e0 [size=32]
         Capabilities: [50] Vendor Specific Information <?>
         Kernel driver in use: uhci_hcd
         Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #5 (rev 02) (prog-if 00 [UHCI])
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin B routed to IRQ 21
         Region 4: I/O ports at 30c0 [size=32]
         Capabilities: [50] Vendor Specific Information <?>
         Kernel driver in use: uhci_hcd
         Kernel modules: uhci-hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #6 (rev 02) (prog-if 00 [UHCI])
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin C routed to IRQ 17
         Region 4: I/O ports at 30a0 [size=32]
         Capabilities: [50] Vendor Specific Information <?>
         Kernel driver in use: uhci_hcd
         Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #2 (rev 02) (prog-if 20 [EHCI])
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin C routed to IRQ 17
         Region 0: Memory at e04a5c00 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Debug port: BAR=1 offset=00a0
         Capabilities: [98] Vendor Specific Information <?>
         Kernel driver in use: ehci_hcd
         Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio 
Controller (rev 02)
         Subsystem: Intel Corporation Unknown device 0002
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 22
         Region 0: Memory at e04a0000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [70] Express (v1) Root Complex Integrated 
Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE- FLReset+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, 
Latency L0 <64ns, L1 <1us
                         ClockPM- Suprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
         Kernel driver in use: HDA Intel
         Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 1 (rev 02) (prog-if 00 [Normal decode])
         Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: fff00000-000fffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE+ FLReset-
                 DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <4us
                         ClockPM- Suprise- LLActRep+ BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surpise+
                         Slot #  1, PowerLimit 10.000000; Interlock- 
NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
                         Changed: MRL- PresDet- LinkState-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                 Address: fee0f00c  Data: 4169
         Capabilities: [90] Subsystem: Intel Corporation Optiplex 755
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: pcieport-driver
         Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 2 (rev 02) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
         I/O behind bridge: 00002000-00002fff
         Memory behind bridge: e0200000-e02fffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE+ FLReset-
                 DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
                         ClockPM- Suprise- LLActRep+ BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surpise+
                         Slot #  2, PowerLimit 10.000000; Interlock- 
NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet+ LinkState+
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                 Address: fee0f00c  Data: 4171
         Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9 
Family) PCI Express Port 2
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: pcieport-driver
         Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 3 (rev 02) (prog-if 00 [Normal decode])
         Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: fff00000-000fffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE+ FLReset-
                 DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <4us
                         ClockPM- Suprise- LLActRep+ BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surpise+
                         Slot #  3, PowerLimit 10.000000; Interlock- 
NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
                         Changed: MRL- PresDet- LinkState-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                 Address: fee0f00c  Data: 4179
         Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9 
Family) PCI Express Port 3
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: pcieport-driver
         Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 4 (rev 02) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
         I/O behind bridge: 00001000-00001fff
         Memory behind bridge: e0100000-e01fffff
         Prefetchable memory behind bridge: 
00000000e0500000-00000000e05fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE+ FLReset-
                 DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
                         ClockPM- Suprise- LLActRep+ BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surpise+
                         Slot #  4, PowerLimit 10.000000; Interlock- 
NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet+ LinkState+
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                 Address: fee0f00c  Data: 4181
         Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9 
Family) PCI Express Port 4
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: pcieport-driver
         Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 5 (rev 02) (prog-if 00 [Normal decode])
         Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: fff00000-000fffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE+ FLReset-
                 DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <4us
                         ClockPM- Suprise- LLActRep+ BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surpise+
                         Slot #  5, PowerLimit 10.000000; Interlock- 
NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
                         Changed: MRL- PresDet- LinkState-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                 Address: fee0f00c  Data: 4189
         Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9 
Family) PCI Express Port 5
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: pcieport-driver
         Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #1 (rev 02) (prog-if 00 [UHCI])
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 23
         Region 4: I/O ports at 3080 [size=32]
         Capabilities: [50] Vendor Specific Information <?>
         Kernel driver in use: uhci_hcd
         Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #2 (rev 02) (prog-if 00 [UHCI])
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin B routed to IRQ 19
         Region 4: I/O ports at 3060 [size=32]
         Capabilities: [50] Vendor Specific Information <?>
         Kernel driver in use: uhci_hcd
         Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #3 (rev 02) (prog-if 00 [UHCI])
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin C routed to IRQ 18
         Region 4: I/O ports at 3040 [size=32]
         Capabilities: [50] Vendor Specific Information <?>
         Kernel driver in use: uhci_hcd
         Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #1 (rev 02) (prog-if 20 [EHCI])
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 23
         Region 0: Memory at e04a5800 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Debug port: BAR=1 offset=00a0
         Capabilities: [98] Vendor Specific Information <?>
         Kernel driver in use: ehci_hcd
         Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 
01 [Subtractive decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Bus: primary=00, secondary=06, subordinate=06, sec-latency=32
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: e0000000-e00fffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] Subsystem: Intel Corporation Unknown device 5044

00:1f.0 ISA bridge: Intel Corporation 82801IH (ICH9DH) LPC Interface 
Controller (rev 02)
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Capabilities: [e0] Vendor Specific Information <?>
         Kernel modules: iTCO_wdt

00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 
port SATA AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 2298
         Region 0: I/O ports at 3428 [size=8]
         Region 1: I/O ports at 343c [size=4]
         Region 2: I/O ports at 3420 [size=8]
         Region 3: I/O ports at 3438 [size=4]
         Region 4: I/O ports at 3020 [size=32]
         Region 5: Memory at e04a5000 (32-bit, non-prefetchable) [size=2K]
         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/4 Enable+
                 Address: fee0a00c  Data: 41a1
         Capabilities: [70] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [a8] SATA HBA <?>
         Capabilities: [b0] Vendor Specific Information <?>
         Kernel driver in use: ahci
         Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller 
(rev 02)
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Interrupt: pin B routed to IRQ 18
         Region 0: Memory at e04a6000 (64-bit, non-prefetchable) [size=256]
         Region 4: I/O ports at 3000 [size=32]
         Kernel driver in use: i801_smbus
         Kernel modules: i2c-i801

02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101 
single-port PATA133 interface (rev b2) (prog-if 8f [Master SecP SecO 
PriP PriO])
         Subsystem: Marvell Technology Group Ltd. 88SE6101 single-port 
PATA133 interface
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 17
         Region 0: I/O ports at 2018 [size=8]
         Region 1: I/O ports at 2024 [size=4]
         Region 2: I/O ports at 2010 [size=8]
         Region 3: I/O ports at 2020 [size=4]
         Region 4: I/O ports at 2000 [size=16]
         Region 5: Memory at e0200000 (32-bit, non-prefetchable) [size=512]
         Capabilities: [48] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                 Address: 00000000  Data: 0000
         Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, 
Latency L0 <256ns, L1 unlimited
                         ClockPM- Suprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         Kernel driver in use: pata_marvell
         Kernel modules: pata_acpi, ata_generic, pata_marvell

04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E 
Gigabit Ethernet Controller (rev 20)
         Subsystem: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit 
Ethernet Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 2297
         Region 0: Memory at e0100000 (64-bit, non-prefetchable) [size=16K]
         Region 2: I/O ports at 1000 [size=256]
         Expansion ROM at e0500000 [disabled] [size=128K]
         Capabilities: [48] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [50] Vital Product Data <?>
         Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable+
                 Address: 00000000fee0400c  Data: 41a9
         Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ 
AuxPwr+ TransPend+
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, 
Latency L0 <256ns, L1 unlimited
                         ClockPM- Suprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         Kernel driver in use: sky2
         Kernel modules: sky2

06:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A 
IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
         Subsystem: Intel Corporation Unknown device 5044
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 19
         Region 0: Memory at e0004000 (32-bit, non-prefetchable) [size=2K]
         Region 1: Memory at e0000000 (32-bit, non-prefetchable) [size=16K]
         Capabilities: [44] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME+
         Kernel driver in use: firewire_ohci
         Kernel modules: firewire-ohci



-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


