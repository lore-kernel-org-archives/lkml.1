Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZAKViy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZAKViy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZAKVip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:38:45 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:39957 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZAKVik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:38:40 -0500
From: "Jesse F. Hughes" <jesse@phiwumbda.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Various problems with new AMD 64 HP Pavilion Desktop machine. (REPOST)
References: <87r63ci7nb.fsf@phiwumbda.org>
	<20090110153014.GA19704@electric-eye.fr.zoreil.com>
Organization: The Eternal (and Int'l) Order of Palsy-Walsies -- President
Content-Type: text/plain; charset=US-ASCII
Date: Sun, 11 Jan 2009 16:38:23 -0500
In-Reply-To: <20090110153014.GA19704@electric-eye.fr.zoreil.com> (Francois Romieu's message of "Sat, 10 Jan 2009 16:30:14 +0100")
Message-ID: <87tz85cyls.fsf_-_@phiwumbda.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


****** [My mailer split up this message in a funky way.  Sorry about
that.  I think I fixed that problem.]

Hello.

I seem to be having a whole slew of problems with my new (refurbished)
computer and I'm bumfuzzled about how to solve them.  A poster on
comp.os.linux.hardware suggested I post a message here.

Symptoms:

* My r8168 driver (latest available from realtek site) acts flaky.
The ethernet card works for a while, but then just craps out,
receiving and sending no packets at all.  This usually happens during
a sizeable download.  Removing and reloading the driver fixes the
problem for a short while.

* My Hauppauge 1800 (?) tv card seems to be acting up.  Sometimes when
I lspci -vvv, I see

  !!! Unknown header type 7f

Other times, it reports the card properly.  In any case, dmesg shows
"no eeprom present (err=-5)?" when loading tveeprom.

* I bought a PCI wireless card, but returned it.  It was unable to
connect to my network regularly.  Moreover, when it was plugged in,
and endless stream of error messages from the cx23885 tv card driver
was sent to the console.  I have no idea why a wireless card would
interfere with a TV card like that.

* I bought a USB wireless card to replace it.  Again, it is behaving
oddly, sometimes working for hours at a time, other times unable to
connect to my wireless access point at all and reporting that
"Interface doesn't support scanning : Network is down"

I'm more than a wee bit clueless about all this.  I hope that someone
can help me out here.  Is it a hardware issue?  Does it have something
to do with ACPI, as the colh poster suggested?  Is my refurbished box
a lemon?

I would appreciate a CC with any replies, but I will also keep an eye
on the mailing list archives.  Please let me know if I omitted any
relevant information.

Here's the output of lspci -vvv:

00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI Express Root Port (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fa000000-feafffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Intel Corporation Device 0000
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0f00c  Data: 4161
	Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM L0s, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  0, PowerLimit 75.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [140] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at b400 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at b480 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 02) (prog-if 20)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f9cfec00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at f9cf4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0f00c  Data: 4169
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 2a6f
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 02)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f9e00000-f9ffffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0f00c  Data: 4171
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 2a6f
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 3 (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: feb00000-febfffff
	Prefetchable memory behind bridge: 00000000f8f00000-00000000f8ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0f00c  Data: 4179
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 2a6f
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at b800 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at b880 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at bc00 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at c000 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 02) (prog-if 20)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f9cff800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 01)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f9d00000-f9dfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Hewlett-Packard Company Device 2a6f

00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface Controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt

00:1f.2 RAID bus controller: Intel Corporation 82801 SATA RAID Controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 2299
	Region 0: I/O ports at c880 [size=8]
	Region 1: I/O ports at c800 [size=4]
	Region 2: I/O ports at c480 [size=8]
	Region 3: I/O ports at c400 [size=4]
	Region 4: I/O ports at c080 [size=32]
	Region 5: Memory at f9cff000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/4 Enable+
		Address: fee0f00c  Data: 4199
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA <?>
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 10
	Region 0: Memory at f9cffc00 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 0400 [size=32]
	Kernel modules: i2c-i801

01:05.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 70) (prog-if 10)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (3000ns min, 6000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at f9dff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ohci1394
	Kernel modules: ohci1394

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 2a6f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 2298
	Region 0: I/O ports at e800 [size=256]
	Region 2: Memory at febff000 (64-bit, non-prefetchable) [size=4K]
	Region 4: Memory at f8ff0000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at febc0000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0f00c  Data: 41a1
	Capabilities: [70] Express (v1) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data <?>
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 81-68-10-ec-00-00-00-00
	Kernel driver in use: r8169
	Kernel modules: r8169, r8168

***********[ As Francois points out, at this time I had the 8169
driver loaded, not the 8168.  In either case, the behavior is the same.]

03:00.0 Multimedia video controller: Conexant Systems, Inc. Device 8880 (rev 0f)
	Subsystem: Hauppauge computer works Inc. Device 7801
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at f9e00000 (64-bit, non-prefetchable) [disabled] [size=2M]
	Capabilities: [40] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Vital Product Data <?>
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: cx23885
	Kernel modules: cx23885

05:00.0 VGA compatible controller: nVidia Corporation GeForce 8400 GS (rev a1)
	Subsystem: ASUSTeK Computer Inc. Device 050a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at dc00 [size=128]
	Expansion ROM at feae0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information <?>
	Kernel driver in use: nvidia
	Kernel modules: nvidiafb, nvidia


And here's the output of dmesg:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.27-7-generic (buildd@crested) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #1 SMP Tue Nov 4 19:33:06 UTC 2008 (Ubuntu 2.6.27-7.16-generic)
[    0.000000] Command line: root=UUID=2a2d2a56-a053-4a69-8a34-4e538f88257a ro quiet splash 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000097000 (usable)
[    0.000000]  BIOS-e820: 0000000000097000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffb0000 - 00000000bffbe000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffbe000 - 00000000bfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] last_pfn = 0xbffb0 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bffb0000 page 4k
[    0.000000] kernel direct mapping tables up to bffb0000 @ 8000-d000
[    0.000000] last_map_addr: bffb0000 end: bffb0000
[    0.000000] RAMDISK: 377aa000 - 37fef48e
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FC430, 0014 (r0 HPQOEM)
[    0.000000] ACPI: RSDT BFFB0000, 0044 (r1 HPQOEM SLIC-CPC 20080421 MSFT       97)
[    0.000000] ACPI: FACP BFFB0200, 0084 (r2 HPQOEM SLIC-CPC 20080421 MSFT       97)
[    0.000000] ACPI: DSDT BFFB0440, 4E91 (r1 HPQOEM SLIC-CPC        0 INTL 20051117)
[    0.000000] ACPI: FACS BFFBE000, 0040
[    0.000000] ACPI: APIC BFFB0390, 006C (r1 HPQOEM SLIC-CPC 20080421 MSFT       97)
[    0.000000] ACPI: MCFG BFFB0400, 003C (r1 HPQOEM SLIC-CPC 20080421 MSFT       97)
[    0.000000] ACPI: OEMB BFFBE040, 0072 (r1 HPQOEM SLIC-CPC 20080421 MSFT       97)
[    0.000000] ACPI: HPET BFFB52E0, 0038 (r1 HPQOEM SLIC-CPC 20080421 MSFT       97)
[    0.000000] ACPI: GSCI BFFBE0C0, 2024 (r1 HPQOEM SLIC-CPC 20080421 MSFT       97)
[    0.000000] ACPI: SLIC BFFC00F0, 0176 (r1 HPQOEM SLIC-CPC        1 MSFT        1)
[    0.000000] ACPI: SSDT BFFC14B0, 082F (r1 HPQOEM SLIC-CPC       12 INTL 20051117)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000000bffb0000
[    0.000000] Bootmem setup node 0 0000000000000000-00000000bffb0000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000005fff]
[    0.000000]   bootmap [000000000000b000 -  0000000000022ff7] pages 18
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 00bffb0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00008b8f9c]    TEXT DATA BSS ==> [0000200000 - 00008b8f9c]
[    0.000000]   #3 [00377aa000 - 0037fef48e]          RAMDISK ==> [00377aa000 - 0037fef48e]
[    0.000000]   #4 [0000097000 - 0000100000]    BIOS reserved ==> [0000097000 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] 000ff780
[    0.000000]  [ffffe20000000000-ffffe20002ffffff] PMD -> [ffff880001200000-ffff8800041fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000097
[    0.000000]     0: 0x00000100 -> 0x000bffb0
[    0.000000] On node 0 totalpages: 786247
[    0.000000]   DMA zone: 2094 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 770033 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000097000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:3ee00000)
[    0.000000] PERCPU: Allocating 64928 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 772127
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=UUID=2a2d2a56-a053-4a69-8a34-4e538f88257a ro quiet splash 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC: PIT calibration confirmed by PMTIMER.
[    0.000000] TSC: using PMTIMER calibration value
[    0.000000] Detected 2399.905 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 3079996k/3145408k available (3112k kernel code, 64992k reserved, 1575k data, 536k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4799.81 BogoMIPS (lpj=9599620)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] AppArmor: AppArmor initialized
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004570] Mount-cache hash table entries: 256
[    0.004762] Initializing cgroup subsys ns
[    0.004767] Initializing cgroup subsys cpuacct
[    0.004769] Initializing cgroup subsys memory
[    0.004784] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004786] CPU: L2 cache: 4096K
[    0.004788] CPU 0/0 -> Node 0
[    0.004790] CPU: Physical Processor ID: 0
[    0.004791] CPU: Processor Core ID: 0
[    0.004797] CPU0: Thermal monitoring enabled (TM2)
[    0.004799] using mwait in idle threads.
[    0.006692] ACPI: Core revision 20080609
[    0.008381] ACPI: Checking initramfs for custom DSDT
[    0.328470] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.368920] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.368923] Using local APIC timer interrupts.
[    0.372024] APIC timer calibration result 16666077
[    0.372025] Detected 16.666 MHz APIC timer.
[    0.372135] Booting processor 1/1 ip 6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 9119.68 BogoMIPS (lpj=18239377)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.460625] CPU1: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.460646] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.464144] Booting processor 2/2 ip 6000
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 4799.89 BogoMIPS (lpj=9599796)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 2/2 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 2
[    0.004000] CPU2: Thermal monitoring enabled (TM2)
[    0.552650] CPU2: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.552670] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.556116] Booting processor 3/3 ip 6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 4799.90 BogoMIPS (lpj=9599815)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 3/3 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 3
[    0.004000] CPU3: Thermal monitoring enabled (TM2)
[    0.644625] CPU3: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.644646] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.648049] Brought up 4 CPUs
[    0.648052] Total of 4 processors activated (23519.30 BogoMIPS).
[    0.648118] CPU0 attaching sched-domain:
[    0.648121]  domain 0: span 0-1 level MC
[    0.648122]   groups: 0 1
[    0.648125]   domain 1: span 0-3 level CPU
[    0.648127]    groups: 0-1 2-3
[    0.648130]    domain 2: span 0-3 level NODE
[    0.648131]     groups: 0-3
[    0.648135] CPU1 attaching sched-domain:
[    0.648136]  domain 0: span 0-1 level MC
[    0.648138]   groups: 1 0
[    0.648140]   domain 1: span 0-3 level CPU
[    0.648142]    groups: 0-1 2-3
[    0.648144]    domain 2: span 0-3 level NODE
[    0.648146]     groups: 0-3
[    0.648148] CPU2 attaching sched-domain:
[    0.648150]  domain 0: span 2-3 level MC
[    0.648151]   groups: 2 3
[    0.648153]   domain 1: span 0-3 level CPU
[    0.648155]    groups: 2-3 0-1
[    0.648157]    domain 2: span 0-3 level NODE
[    0.648159]     groups: 0-3
[    0.648162] CPU3 attaching sched-domain:
[    0.648163]  domain 0: span 2-3 level MC
[    0.648165]   groups: 3 2
[    0.648167]   domain 1: span 0-3 level CPU
[    0.648169]    groups: 2-3 0-1
[    0.648171]    domain 2: span 0-3 level NODE
[    0.648172]     groups: 0-3
[    0.648306] net_namespace: 1552 bytes
[    0.648306] Booting paravirtualized kernel on bare hardware
[    0.648306] Time: 19:05:42  Date: 01/09/09
[    0.648306] NET: Registered protocol family 16
[    0.648314] ACPI: bus type pci registered
[    0.648314] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.648314] PCI: Not using MMCONFIG.
[    0.648314] PCI: Using configuration type 1 for base access
[    0.652064] ACPI: EC: Look up EC in DSDT
[    0.659343] ACPI: Interpreter enabled
[    0.659345] ACPI: (supports S0 S1 S3 S4 S5)
[    0.659364] ACPI: Using IOAPIC for interrupt routing
[    0.659417] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.661637] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.668446] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.676174] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.676174] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.676174] pci 0000:00:01.0: PME# disabled
[    0.676186] PCI: 0000:00:1a.0 reg 20 io port: [b400, b41f]
[    0.676252] PCI: 0000:00:1a.1 reg 20 io port: [b480, b49f]
[    0.676320] PCI: 0000:00:1a.7 reg 10 32bit mmio: [f9cfec00, f9cfefff]
[    0.676366] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.676370] pci 0000:00:1a.7: PME# disabled
[    0.676406] PCI: 0000:00:1b.0 reg 10 64bit mmio: [f9cf4000, f9cf7fff]
[    0.676447] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.676451] pci 0000:00:1b.0: PME# disabled
[    0.676508] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.676512] pci 0000:00:1c.0: PME# disabled
[    0.676565] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.676569] pci 0000:00:1c.1: PME# disabled
[    0.676623] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.676626] pci 0000:00:1c.2: PME# disabled
[    0.676677] PCI: 0000:00:1d.0 reg 20 io port: [b800, b81f]
[    0.676743] PCI: 0000:00:1d.1 reg 20 io port: [b880, b89f]
[    0.676809] PCI: 0000:00:1d.2 reg 20 io port: [bc00, bc1f]
[    0.676876] PCI: 0000:00:1d.3 reg 20 io port: [c000, c01f]
[    0.676941] PCI: 0000:00:1d.7 reg 10 32bit mmio: [f9cff800, f9cffbff]
[    0.676988] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.676991] pci 0000:00:1d.7: PME# disabled
[    0.677100] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.677104] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.677158] PCI: 0000:00:1f.2 reg 10 io port: [c880, c887]
[    0.677164] PCI: 0000:00:1f.2 reg 14 io port: [c800, c803]
[    0.677170] PCI: 0000:00:1f.2 reg 18 io port: [c480, c487]
[    0.677176] PCI: 0000:00:1f.2 reg 1c io port: [c400, c403]
[    0.677182] PCI: 0000:00:1f.2 reg 20 io port: [c080, c09f]
[    0.677188] PCI: 0000:00:1f.2 reg 24 32bit mmio: [f9cff000, f9cff7ff]
[    0.677216] pci 0000:00:1f.2: PME# supported from D3hot
[    0.677219] pci 0000:00:1f.2: PME# disabled
[    0.677240] PCI: 0000:00:1f.3 reg 10 64bit mmio: [f9cffc00, f9cffcff]
[    0.677255] PCI: 0000:00:1f.3 reg 20 io port: [400, 41f]
[    0.677298] PCI: 0000:05:00.0 reg 10 32bit mmio: [fd000000, fdffffff]
[    0.677303] PCI: 0000:05:00.0 reg 14 32bit mmio: [d0000000, dfffffff]
[    0.677313] PCI: 0000:05:00.0 reg 1c 64bit mmio: [fa000000, fbffffff]
[    0.677318] PCI: 0000:05:00.0 reg 24 io port: [dc00, dc7f]
[    0.677322] PCI: 0000:05:00.0 reg 30 32bit mmio: [feae0000, feafffff]
[    0.677372] PCI: bridge 0000:00:01.0 io port: [d000, dfff]
[    0.677374] PCI: bridge 0000:00:01.0 32bit mmio: [fa000000, feafffff]
[    0.677378] PCI: bridge 0000:00:01.0 64bit mmio pref: [d0000000, dfffffff]
[    0.677482] PCI: 0000:03:00.0 reg 10 64bit mmio: [0, 1fffff]
[    0.677561] pci 0000:03:00.0: supports D1
[    0.677562] pci 0000:03:00.0: supports D2
[    0.677563] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot
[    0.677569] pci 0000:03:00.0: PME# disabled
[    0.677611] PCI: bridge 0000:00:1c.1 32bit mmio: [f9e00000, f9ffffff]
[    0.677768] PCI: 0000:02:00.0 reg 10 io port: [e800, e8ff]
[    0.677840] PCI: 0000:02:00.0 reg 18 64bit mmio: [febff000, febfffff]
[    0.677866] PCI: 0000:02:00.0 reg 20 32bit mmio: [f8ff0000, f8ffffff]
[    0.677915] PCI: 0000:02:00.0 reg 30 32bit mmio: [febc0000, febdffff]
[    0.678018] pci 0000:02:00.0: supports D1
[    0.678019] pci 0000:02:00.0: supports D2
[    0.678020] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.678034] pci 0000:02:00.0: PME# disabled
[    0.678073] PCI: bridge 0000:00:1c.2 io port: [e000, efff]
[    0.678077] PCI: bridge 0000:00:1c.2 32bit mmio: [feb00000, febfffff]
[    0.678083] PCI: bridge 0000:00:1c.2 64bit mmio pref: [f8f00000, f8ffffff]
[    0.678122] PCI: 0000:01:05.0 reg 10 32bit mmio: [f9dff000, f9dfffff]
[    0.678162] pci 0000:01:05.0: supports D1
[    0.678163] pci 0000:01:05.0: supports D2
[    0.678165] pci 0000:01:05.0: PME# supported from D0 D1 D2 D3hot
[    0.678168] pci 0000:01:05.0: PME# disabled
[    0.678200] pci 0000:00:1e.0: transparent bridge
[    0.678206] PCI: bridge 0000:00:1e.0 32bit mmio: [f9d00000, f9dfffff]
[    0.678238] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.678449] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.678577] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.678675] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.680052] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.692862] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.692862] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.692862] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.696143] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.696265] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 5 6 7 10 11 12 14 15)
[    0.696385] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.696506] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.696628] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
[    0.696827] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.696842] pnp: PnP ACPI init
[    0.696842] ACPI: bus type pnp registered
[    0.700316] pnp 00:0f: mem resource (0x0-0x9ffff) overlaps 0000:03:00.0 BAR 0 (0x0-0x1fffff), disabling
[    0.700319] pnp 00:0f: mem resource (0xc0000-0xcffff) overlaps 0000:03:00.0 BAR 0 (0x0-0x1fffff), disabling
[    0.700321] pnp 00:0f: mem resource (0xe0000-0xfffff) overlaps 0000:03:00.0 BAR 0 (0x0-0x1fffff), disabling
[    0.700324] pnp 00:0f: mem resource (0x100000-0xbfffffff) overlaps 0000:03:00.0 BAR 0 (0x0-0x1fffff), disabling
[    0.700372] pnp: PnP ACPI: found 16 devices
[    0.700374] ACPI: ACPI bus type pnp unregistered
[    0.700394] PCI: Using ACPI for IRQ routing
[    0.716044] NET: Registered protocol family 8
[    0.716047] NET: Registered protocol family 20
[    0.716065] NetLabel: Initializing
[    0.716065] NetLabel:  domain hash size = 128
[    0.716065] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.716065] NetLabel:  unlabeled traffic allowed by default
[    0.716075] PCI-GART: No AMD northbridge found.
[    0.716082] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.716087] hpet0: 4 64-bit timers, 14318180 Hz
[    0.719200] tracer: 1286 pages allocated for 65536 entries of 80 bytes
[    0.719201]    actual entries 65586
[    0.719278] AppArmor: AppArmor Filesystem Enabled
[    0.719296] ACPI: RTC can wake from S4
[    0.720039] Switched to high resolution mode on CPU 0
[    0.720685] Switched to high resolution mode on CPU 1
[    0.721129] Switched to high resolution mode on CPU 3
[    0.721162] Switched to high resolution mode on CPU 2
[    0.732044] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.732055] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    0.732058] system 00:06: ioport range 0x800-0x87f has been reserved
[    0.732061] system 00:06: ioport range 0x480-0x4bf has been reserved
[    0.732064] system 00:06: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.732067] system 00:06: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.732074] system 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.732077] system 00:08: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.732085] system 00:0b: ioport range 0xa00-0xadf has been reserved
[    0.732092] system 00:0d: iomem range 0xffc00000-0xffefffff has been reserved
[    0.732098] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[    0.737406] pci 0000:00:01.0: PCI bridge, secondary bus 0000:05
[    0.737408] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.737411] pci 0000:00:01.0:   MEM window: 0xfa000000-0xfeafffff
[    0.737414] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.737418] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.737419] pci 0000:00:1c.0:   IO window: disabled
[    0.737424] pci 0000:00:1c.0:   MEM window: disabled
[    0.737427] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.737443] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.737444] pci 0000:00:1c.1:   IO window: disabled
[    0.737449] pci 0000:00:1c.1:   MEM window: 0xf9e00000-0xf9ffffff
[    0.737453] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.737459] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:02
[    0.737462] pci 0000:00:1c.2:   IO window: 0xe000-0xefff
[    0.737466] pci 0000:00:1c.2:   MEM window: 0xfeb00000-0xfebfffff
[    0.737470] pci 0000:00:1c.2:   PREFETCH window: 0x000000f8f00000-0x000000f8ffffff
[    0.737477] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
[    0.737478] pci 0000:00:1e.0:   IO window: disabled
[    0.737483] pci 0000:00:1e.0:   MEM window: 0xf9d00000-0xf9dfffff
[    0.737486] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.737499] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.737502] pci 0000:00:01.0: setting latency timer to 64
[    0.737509] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.737513] pci 0000:00:1c.0: setting latency timer to 64
[    0.737524] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.737532] pci 0000:00:1c.1: setting latency timer to 64
[    0.737539] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.737543] pci 0000:00:1c.2: setting latency timer to 64
[    0.737549] pci 0000:00:1e.0: setting latency timer to 64
[    0.737552] bus: 00 index 0 io port: [0, ffff]
[    0.737554] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.737555] bus: 05 index 0 io port: [d000, dfff]
[    0.737557] bus: 05 index 1 mmio: [fa000000, feafffff]
[    0.737558] bus: 05 index 2 mmio: [d0000000, dfffffff]
[    0.737559] bus: 05 index 3 mmio: [0, 0]
[    0.737561] bus: 04 index 0 mmio: [0, 0]
[    0.737562] bus: 04 index 1 mmio: [0, 0]
[    0.737563] bus: 04 index 2 mmio: [0, 0]
[    0.737564] bus: 04 index 3 mmio: [0, 0]
[    0.737565] bus: 03 index 0 mmio: [0, 0]
[    0.737567] bus: 03 index 1 mmio: [f9e00000, f9ffffff]
[    0.737568] bus: 03 index 2 mmio: [0, 0]
[    0.737569] bus: 03 index 3 mmio: [0, 0]
[    0.737571] bus: 02 index 0 io port: [e000, efff]
[    0.737572] bus: 02 index 1 mmio: [feb00000, febfffff]
[    0.737573] bus: 02 index 2 mmio: [f8f00000, f8ffffff]
[    0.737575] bus: 02 index 3 mmio: [0, 0]
[    0.737576] bus: 01 index 0 mmio: [0, 0]
[    0.737577] bus: 01 index 1 mmio: [f9d00000, f9dfffff]
[    0.737578] bus: 01 index 2 mmio: [0, 0]
[    0.737580] bus: 01 index 3 io port: [0, ffff]
[    0.737581] bus: 01 index 4 mmio: [0, ffffffffffffffff]
[    0.737589] NET: Registered protocol family 2
[    0.780193] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.781308] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.785658] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.786310] TCP: Hash tables configured (established 524288 bind 65536)
[    0.786312] TCP reno registered
[    0.796150] NET: Registered protocol family 1
[    0.796250] checking if image is initramfs... it is
[    1.441429] Freeing initrd memory: 8469k freed
[    1.445957] audit: initializing netlink socket (disabled)
[    1.445974] type=2000 audit(1231527942.444:1): initialized
[    1.451100] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.454488] VFS: Disk quotas dquot_6.5.1
[    1.454579] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.454702] msgmni has been set to 6032
[    1.454846] io scheduler noop registered
[    1.454849] io scheduler anticipatory registered
[    1.454851] io scheduler deadline registered
[    1.455011] io scheduler cfq registered (default)
[    1.455170] pci 0000:05:00.0: Boot video device
[    1.455306] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.455345] pcieport-driver 0000:00:01.0: found MSI capability
[    1.455375] pci_express 0000:00:01.0:pcie00: allocate port service
[    1.455430] pci_express 0000:00:01.0:pcie03: allocate port service
[    1.455531] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.455578] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.455615] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.455671] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.455735] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.455851] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.455893] pcieport-driver 0000:00:1c.1: found MSI capability
[    1.455935] pci_express 0000:00:1c.1:pcie00: allocate port service
[    1.456001] pci_express 0000:00:1c.1:pcie02: allocate port service
[    1.456061] pci_express 0000:00:1c.1:pcie03: allocate port service
[    1.456176] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    1.456218] pcieport-driver 0000:00:1c.2: found MSI capability
[    1.456260] pci_express 0000:00:1c.2:pcie00: allocate port service
[    1.456329] pci_express 0000:00:1c.2:pcie02: allocate port service
[    1.456388] pci_express 0000:00:1c.2:pcie03: allocate port service
[    1.495267] hpet_resources: 0xfed00000 is busy
[    1.495364] Linux agpgart interface v0.103
[    1.495369] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.497634] brd: module loaded
[    1.497689] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    1.497785] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.499794] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.499799] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.525693] mice: PS/2 mouse device common for all mice
[    1.525847] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.525876] rtc0: alarms up to one month, y3k, hpet irqs
[    1.525930] cpuidle: using governor ladder
[    1.525932] cpuidle: using governor menu
[    1.526248] TCP cubic registered
[    1.526483] registered taskstats version 1
[    1.526622]   Magic number: 9:173:91
[    1.526752] rtc_cmos 00:03: setting system clock to 2009-01-09 19:05:42 UTC (1231527942)
[    1.526755] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.526756] EDD information not available.
[    1.526788] Freeing unused kernel memory: 536k freed
[    1.526955] Write protecting the kernel read-only data: 4348k
[    1.564687] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.636693] fuse init (API version 7.9)
[    1.652733] ACPI: SSDT BFFC0270, 0277 (r1 HPQOEM SLIC-CPC       11 INTL 20051117)
[    1.653018] processor ACPI0007:00: registered as cooling_device0
[    1.653391] ACPI: SSDT BFFC0700, 0277 (r1 HPQOEM SLIC-CPC       12 INTL 20051117)
[    1.653657] processor ACPI0007:01: registered as cooling_device1
[    1.654036] ACPI: SSDT BFFC0B90, 0277 (r1 HPQOEM SLIC-CPC       12 INTL 20051117)
[    1.654307] processor ACPI0007:02: registered as cooling_device2
[    1.654681] ACPI: SSDT BFFC1020, 0277 (r1 HPQOEM SLIC-CPC       12 INTL 20051117)
[    1.654946] processor ACPI0007:03: registered as cooling_device3
[    1.785365] usbcore: registered new interface driver usbfs
[    1.785389] usbcore: registered new interface driver hub
[    1.791041] usbcore: registered new device driver usb
[    1.793603] USB Universal Host Controller Interface driver v3.0
[    1.793706] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.793717] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.793720] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.795179] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.795227] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b400
[    1.795357] usb usb1: configuration #1 chosen from 1 choice
[    1.795377] hub 1-0:1.0: USB hub found
[    1.795383] hub 1-0:1.0: 2 ports detected
[    1.804339] No dock devices found.
[    1.813433] SCSI subsystem initialized
[    1.830895] libata version 3.00 loaded.
[    1.897736] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.897745] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.897748] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.897769] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    1.897806] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b480
[    1.897881] usb usb2: configuration #1 chosen from 1 choice
[    1.897901] hub 2-0:1.0: USB hub found
[    1.897906] hub 2-0:1.0: 2 ports detected
[    2.001957] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.001969] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.001972] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.001992] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 3
[    2.005910] ehci_hcd 0000:00:1a.7: debug port 1
[    2.005916] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    2.005931] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf9cfec00
[    2.021618] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.021720] usb usb3: configuration #1 chosen from 1 choice
[    2.021743] hub 3-0:1.0: USB hub found
[    2.021750] hub 3-0:1.0: 4 ports detected
[    2.125931] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.125940] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.125945] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.125972] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    2.126023] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b800
[    2.126112] usb usb4: configuration #1 chosen from 1 choice
[    2.126139] hub 4-0:1.0: USB hub found
[    2.126147] hub 4-0:1.0: 2 ports detected
[    2.228298] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.228311] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.228314] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.228334] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    2.228365] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b880
[    2.228441] usb usb5: configuration #1 chosen from 1 choice
[    2.228462] hub 5-0:1.0: USB hub found
[    2.228467] hub 5-0:1.0: 2 ports detected
[    2.334417] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.334423] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.334426] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.334448] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    2.334470] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000bc00
[    2.334537] usb usb6: configuration #1 chosen from 1 choice
[    2.334557] hub 6-0:1.0: USB hub found
[    2.334562] hub 6-0:1.0: 2 ports detected
[    2.542402] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    2.542412] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.542416] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.542437] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 7
[    2.542472] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000c000
[    2.542547] usb usb7: configuration #1 chosen from 1 choice
[    2.542567] hub 7-0:1.0: USB hub found
[    2.542573] hub 7-0:1.0: 2 ports detected
[    2.652015] usb 6-2: new full speed USB device using uhci_hcd and address 2
[    2.749085] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.749097] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.749100] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.749121] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    2.753008] ehci_hcd 0000:00:1d.7: debug port 1
[    2.753013] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.753018] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9cff800
[    2.776032] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.776119] usb usb8: configuration #1 chosen from 1 choice
[    2.776150] hub 8-0:1.0: USB hub found
[    2.776161] hub 8-0:1.0: 8 ports detected
[    2.986140] ahci 0000:00:1f.2: version 3.0
[    2.986155] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.986275] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
[    2.986278] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems 
[    2.986283] ahci 0000:00:1f.2: setting latency timer to 64
[    2.986820] scsi0 : ahci
[    2.986947] scsi1 : ahci
[    2.987025] scsi2 : ahci
[    2.987104] scsi3 : ahci
[    2.987181] scsi4 : ahci
[    2.987257] scsi5 : ahci
[    2.987368] ata1: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff100 irq 2299
[    2.987371] ata2: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff180 irq 2299
[    2.987374] ata3: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff200 irq 2299
[    2.987377] ata4: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff280 irq 2299
[    2.987379] ata5: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff300 irq 2299
[    2.987382] ata6: SATA max UDMA/133 abar m2048@0xf9cff000 port 0xf9cff380 irq 2299
[    3.172054] usb 6-2: device not accepting address 2, error -71
[    3.228571] hub 6-0:1.0: unable to enumerate USB device on port 2
[    3.304033] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.304727] ata1.00: ATA-8: WDC WD5000AAKS-65A7B0, 01.03B01, max UDMA/133
[    3.304732] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.305516] ata1.00: configured for UDMA/133
[    3.468045] usb 8-6: new high speed USB device using ehci_hcd and address 2
[    3.602500] usb 8-6: configuration #1 chosen from 1 choice
[    3.716023] usb 8-8: new high speed USB device using ehci_hcd and address 3
[    3.856073] usb 8-8: configuration #1 chosen from 1 choice
[    4.044044] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.047495] ata2.00: ATAPI: HL-DT-ST DVD-RW GSA-H60L, DC08, max UDMA/100
[    4.052091] ata2.00: configured for UDMA/100
[    4.792053] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.820615] ata3.00: ATA-8: ST31000333AS, SD35, max UDMA/133
[    4.820618] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.862390] ata3.00: configured for UDMA/133
[    5.196029] ata4: SATA link down (SStatus 0 SControl 300)
[    5.532043] ata5: SATA link down (SStatus 0 SControl 300)
[    5.872030] ata6: SATA link down (SStatus 0 SControl 300)
[    5.884132] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-6 01.0 PQ: 0 ANSI: 5
[    5.888197] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-RW GSA-H60L  DC08 PQ: 0 ANSI: 5
[    5.888379] scsi 2:0:0:0: Direct-Access     ATA      ST31000333AS     SD35 PQ: 0 ANSI: 5
[    5.888480] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.888516] r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    5.888556] r8169 0000:02:00.0: setting latency timer to 64
[    5.888981] eth0: RTL8168c/8111c at 0xffffc20000642000, 00:1e:8c:4d:00:a8, XID 3c2000c0 IRQ 2298
[    5.890636] ohci1394 0000:01:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.942354] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[20]  MMIO=[f9dff000-f9dff7ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    5.950856] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    5.950890] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    5.950919] scsi 2:0:0:0: Attached scsi generic sg2 type 0
[    5.953374] usbcore: registered new interface driver libusual
[    5.958266] Initializing USB Mass Storage driver...
[    5.958378] scsi6 : SCSI emulation for USB Mass Storage devices
[    5.958459] usb-storage: device found at 2
[    5.958461] usb-storage: waiting for device to settle before scanning
[    5.958471] usbcore: registered new interface driver usb-storage
[    5.958474] USB Mass Storage support registered.
[    5.970823] Driver 'sd' needs updating - please use bus_type methods
[    5.970914] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    5.970929] sd 0:0:0:0: [sda] Write Protect is off
[    5.970931] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.970953] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.971023] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    5.971036] sd 0:0:0:0: [sda] Write Protect is off
[    5.971037] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.971059] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.971062]  sda:<4>Driver 'sr' needs updating - please use bus_type methods
[    5.977073]  sda1 sda2 < sda5 >
[    6.004317] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.004477] sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
[    6.004493] sd 2:0:0:0: [sdb] Write Protect is off
[    6.004495] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    6.004527] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.004585] sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
[    6.004598] sd 2:0:0:0: [sdb] Write Protect is off
[    6.004600] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    6.004624] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.004627]  sdb: unknown partition table
[    6.014875] sd 2:0:0:0: [sdb] Attached SCSI disk
[    6.230779] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    6.230785] Uniform CD-ROM driver Revision: 3.20
[    6.230893] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    6.922012] PM: Starting manual resume from disk
[    6.922015] PM: Resume from partition 8:5
[    6.922016] PM: Checking hibernation image.
[    6.922143] PM: Resume from disk failed.
[    6.939402] EXT3-fs: INFO: recovery required on readonly filesystem.
[    6.939405] EXT3-fs: write access will be enabled during recovery.
[    7.229160] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001e8c00000d4497]
[    7.243639] kjournald starting.  Commit interval 5 seconds
[    7.243658] EXT3-fs: recovery complete.
[    7.244165] EXT3-fs: mounted filesystem with ordered data mode.
[   10.956185] usb-storage: device scan complete
[   10.956223] isa bounce pool size: 16 pages
[   10.956758] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[   10.957388] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[   10.957890] scsi 6:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[   10.958528] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[   10.959698] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[   10.959785] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   10.960552] sd 6:0:0:1: [sdd] Attached SCSI removable disk
[   10.960594] sd 6:0:0:1: Attached scsi generic sg4 type 0
[   10.961300] sd 6:0:0:2: [sde] Attached SCSI removable disk
[   10.961345] sd 6:0:0:2: Attached scsi generic sg5 type 0
[   10.962075] sd 6:0:0:3: [sdf] Attached SCSI removable disk
[   10.962111] sd 6:0:0:3: Attached scsi generic sg6 type 0
[   13.937433] udevd version 124 started
[   14.291502] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   14.313033] ACPI: Power Button (FF) [PWRF]
[   14.313136] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
[   14.321344] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   14.325068] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   14.345060] ACPI: Power Button (CM) [PWRB]
[   14.534852] iTCO_vendor_support: vendor-support=0
[   14.554105] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   14.570873] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   14.580177] iTCO_wdt: Found a ICH9R TCO device (Version=2, TCOBASE=0x0860)
[   14.580281] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   14.690359] Linux video capture interface: v2.00
[   14.747472] logips2pp: Detected unknown logitech mouse model 127
[   14.841548] cx23885 driver version 0.0.1 loaded
[   14.841599] cx23885 0000:03:00.0: enabling device (0000 -> 0002)
[   14.841607] cx23885 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.841673] CORE cx23885[0]: subsystem: 0070:7801, board: Hauppauge WinTV-HVR1800 [card=2,autodetected]
[   15.036879] cx23885[0]: i2c bus 0 registered
[   15.036900] cx23885[0]: i2c bus 1 registered
[   15.036913] cx23885[0]: i2c bus 2 registered
[   15.037018] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   15.037047] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.039084] tveeprom 0-0050: Huh, no eeprom present (err=-5)?
[   15.039086] tveeprom 0-0050: Encountered bad packet header [00]. Corrupt or not a Hauppauge eeprom.
[   15.039088] cx23885[0]: warning: unknown hauppauge model #0
[   15.039089] cx23885[0]: hauppauge eeprom: model=0
[   15.050932] cx23885[0]/0: registered device video0 [v4l2]
[   15.050962] cx23885[0]: registered device video1 [mpeg]
[   15.050964] cx23885[0]: cx23885 based dvb card
[   15.074276] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   15.116142] s5h1409_readreg: readreg error (ret == -5)
[   15.116197] cx23885[0]: frontend initialization failed
[   15.116199] cx23885_dvb_register() dvb_register failed err = -1
[   15.116201] cx23885_dev_setup() Failed to register dvb on VID_C
[   15.116205] cx23885_dev_checkrevision() New hardware revision found 0x0
[   15.116207] cx23885_dev_checkrevision() Hardware revision unknown 0x0
[   15.116214] cx23885[0]/0: found at 0000:03:00.0, rev: 15, irq: 17, latency: 0, mmio: 0xf9e00000
[   15.116224] cx23885 0000:03:00.0: setting latency timer to 64
[   15.204611] input: ImExPS/2 Logitech Explorer Mouse as /devices/platform/i8042/serio1/input/input5
[   15.252323] rtl8187: 8187B chip detected. Support is EXPERIMENTAL, and could damage your
[   15.252325]          hardware, use at your own risk
[   15.252675] phy0: Selected rate control algorithm 'pid'
[   15.424428] phy0: hwaddr 00:14:d1:54:15:4e, RTL8187BvE V0 + rtl8225z2
[   15.424450] usbcore: registered new interface driver rtl8187
[   15.432099] udev: renamed network interface wlan0 to wlan1
[   15.713682] lp: driver loaded but no devices found
[   15.990581] Adding 9044552k swap on /dev/sda5.  Priority:-1 extents:1 across:9044552k
[   16.539767] EXT3 FS on sda1, internal journal
[   16.730958] device-mapper: uevent: version 1.0.3
[   16.733075] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   17.644717] type=1505 audit(1231527959.087:2): operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" name2="default" pid=4808
[   17.756225] type=1505 audit(1231527959.195:3): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=4813
[   17.756392] type=1505 audit(1231527959.199:4): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=4813
[   17.794484] type=1505 audit(1231527959.235:5): operation="profile_load" name="/usr/sbin/mysqld" name2="default" pid=4817
[   17.904339] ip_tables: (C) 2000-2006 Netfilter Core Team
[   18.903118] ACPI: WMI: Mapper loaded
[   19.675170] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   20.020689] NET: Registered protocol family 10
[   20.021137] lo: Disabled Privacy Extensions
[   23.212176] ppdev: user-space parallel port driver
[   53.057317] nvidia: module license 'NVIDIA' taints kernel.
[   53.310120] nvidia 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   53.310131] nvidia 0000:05:00.0: setting latency timer to 64
[   53.310221] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  177.82  Tue Nov  4 16:50:05 PST 2008
[  122.724734] Bluetooth: Core ver 2.13
[  122.725270] NET: Registered protocol family 31
[  122.725276] Bluetooth: HCI device and connection manager initialized
[  122.725279] Bluetooth: HCI socket layer initialized
[  122.734516] Bluetooth: L2CAP ver 2.11
[  122.734523] Bluetooth: L2CAP socket layer initialized
[  122.769182] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[  122.769189] Bluetooth: BNEP filters: protocol multicast
[  122.777808] Bridge firewalling registered
[  122.777972] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
[  122.787061] Bluetooth: SCO (Voice Link) ver 0.6
[  122.787068] Bluetooth: SCO socket layer initialized
[  123.027199] Bluetooth: RFCOMM socket layer initialized
[  123.027761] Bluetooth: RFCOMM TTY layer initialized
[  123.027766] Bluetooth: RFCOMM ver 1.10
[  127.188535] r8169: eth0: link down
[  127.189440] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  143.571131] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  143.707142] NET: Registered protocol family 17
[  146.460824] wlan1: authenticate with AP 00:18:39:02:f0:ff
[  146.465455] wlan1: authenticated
[  146.465463] wlan1: associate with AP 00:18:39:02:f0:ff
[  146.467461] wlan1: RX AssocResp from 00:18:39:02:f0:ff (capab=0x401 status=0 aid=3)
[  146.467467] wlan1: associated
[  146.468403] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  146.468520] wlan1: disassociating by local choice (reason=3)
[  156.868009] wlan1: no IPv6 routers present
[  219.150186] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  219.319068] wlan1: authenticate with AP 00:0c:41:cc:53:2d
[  219.320696] wlan1: authenticated
[  219.320703] wlan1: associate with AP 00:0c:41:cc:53:2d
[  219.322699] wlan1: RX AssocResp from 00:0c:41:cc:53:2d (capab=0x401 status=12 aid=0)
[  219.322704] wlan1: AP denied association (code=12)
[  219.520023] wlan1: associate with AP 00:0c:41:cc:53:2d
[  219.526085] wlan1: RX AssocResp from 00:0c:41:cc:53:2d (capab=0x401 status=12 aid=0)
[  219.526090] wlan1: AP denied association (code=12)
[  219.721008] wlan1: associate with AP 00:0c:41:cc:53:2d
[  219.722970] wlan1: RX AssocResp from 00:0c:41:cc:53:2d (capab=0x401 status=12 aid=0)
[  219.722974] wlan1: AP denied association (code=12)
[  219.921010] wlan1: association with AP 00:0c:41:cc:53:2d timed out
[  223.331057] wlan1: authenticate with AP 00:0c:41:cc:53:2d
[  238.977242] wlan1: authenticate with AP 00:18:39:02:f0:ff
[  239.025371] wlan1: authenticated
[  239.025378] wlan1: associate with AP 00:18:39:02:f0:ff
[  239.027502] wlan1: RX AssocResp from 00:18:39:02:f0:ff (capab=0x401 status=0 aid=3)
[  239.027509] wlan1: associated
[  239.028428] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  249.860010] wlan1: no IPv6 routers present
[  287.175053] wlan1: deauthenticating by local choice (reason=3)
[  287.361272] wlan1: authenticate with AP 00:18:39:02:f0:ff
-- 
"[I]f I could go back, [...] I would tell myself not to step into a position
where the fate of the entire world could rest in my hands.  I would [avoid
this] path to a nightmarish and surreal world, a topsy-turvy world, where
everything changes." -- James S. Harris cannot escape his destiny.
