Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYLaJBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYLaJBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYLaJAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:00:44 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:48454 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbYLaJAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:00:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=PECuZPKh/zXUu9TZvk4ukCA09PRfhax3HB67DMC9mnBf6gcDt4LZQFBUJGD6Hm7Dwr
         dd65eDhDh7ip+3s9h9Q6ucSzd0Gu3X3aRSrCCsGcNze5djVsHFF6yC649WmD9V5A5k9N
         DUI8byCA3PpkUq166VWRksl1RoysSGaWV3Cbc=
Message-ID: <b681c62b0812310100j3f79de73nf3f24ce5672345b5@mail.gmail.com>
Date: Wed, 31 Dec 2008 14:30:36 +0530
From: "yogeshwar sonawane" <yogyas@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: PCI resource collision message
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <495B1C94.7040907@shaw.ca>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_190837_14077581.1230714036281"
References: <b681c62b0812302251p195debf5v360e1058de5c18e1@mail.gmail.com>
	 <495B1C94.7040907@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_190837_14077581.1230714036281
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Robert,

Currently card is inserted in PCI slot 06:00.0 & working fine. The
above said problem is observed very few times like 2 or 3. So, i am
sending today's lspci -vv output.
The lspci -vv output follows & it is attached also: -

00:00.0 Host bridge: Intel Corporation: Unknown device 4003 (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Interrupt: pin A routed to IRQ 169
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
		Address: fee00000  Data: 0000
	Capabilities: [6c] Express Root Port (Slot-) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 0
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [100] Advanced Error Reporting

00:01.0 PCI bridge: Intel Corporation: Unknown device 4021 (rev 20)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
		Address: fee00000  Data: 0000
	Capabilities: [6c] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x8, ASPM L0s L1, Port 4
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes Disabled CommClk- ExtSynch-
		Link: Speed unknown, Width x8
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd Off, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [b0] #0d [0000]
	Capabilities: [100] Advanced Error Reporting

00:03.0 PCI bridge: Intel Corporation: Unknown device 4023 (rev 20)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
		Address: fee00000  Data: 0000
	Capabilities: [6c] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x8, ASPM L0s L1, Port 6
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes Disabled CommClk- ExtSynch-
		Link: Speed unknown, Width x8
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd Off, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [b0] #0d [0000]
	Capabilities: [100] Advanced Error Reporting

00:05.0 PCI bridge: Intel Corporation: Unknown device 4025 (rev 20)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
		Address: fee00000  Data: 0000
	Capabilities: [6c] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x8, ASPM L0s L1, Port 8
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes Disabled CommClk- ExtSynch-
		Link: Speed unknown, Width x8
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd Off, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [b0] #0d [0000]
	Capabilities: [100] Advanced Error Reporting

00:07.0 PCI bridge: Intel Corporation: Unknown device 4027 (rev 20)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Bus: primary=00, secondary=04, subordinate=07, sec-latency=0
	Memory behind bridge: de000000-df0fffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000ddf00000
	Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
		Address: fee00000  Data: 0000
	Capabilities: [6c] Express Root Port (Slot-) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x8, ASPM L0s L1, Port 10
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed unknown, Width x8
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [b0] #0d [0000]
	Capabilities: [100] Advanced Error Reporting

00:09.0 PCI bridge: Intel Corporation: Unknown device 4029 (rev 20)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: df100000-df1fffff
	Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
		Address: fee00000  Data: 0000
	Capabilities: [6c] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x4, ASPM L0s L1, Port 12
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed unknown, Width x4
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd Off, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [b0] #0d [0000]
	Capabilities: [100] Advanced Error Reporting

00:0f.0 System peripheral: Intel Corporation: Unknown device 402f (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 217
	Region 0: Memory at fe700000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] MSI-X: Enable- Mask- TabSize=4
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [6c] Express Unknown type IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed unknown, Width x0

00:10.0 Host bridge: Intel Corporation: Unknown device 4030 (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:10.1 Host bridge: Intel Corporation: Unknown device 4030 (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:10.2 Host bridge: Intel Corporation: Unknown device 4030 (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:10.3 Host bridge: Intel Corporation: Unknown device 4030 (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:10.4 Host bridge: Intel Corporation: Unknown device 4030 (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:11.0 Host bridge: Intel Corporation: Unknown device 4031 (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:15.0 Host bridge: Intel Corporation: Unknown device 4035 (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:15.1 Host bridge: Intel Corporation: Unknown device 4035 (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:16.0 Host bridge: Intel Corporation: Unknown device 4036 (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:16.1 Host bridge: Intel Corporation: Unknown device 4036 (rev 20)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI
Express Root Port 1 (rev 09) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
	Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 1
		Link: Latency L0s <256ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #1 (rev 09) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 225
	Region 4: I/O ports at 1800 [size=32]

00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #2 (rev 09) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 233
	Region 4: I/O ports at 1820 [size=32]

00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #3 (rev 09) (prog-if 00 [UHCI])
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 50
	Region 4: I/O ports at 1840 [size=32]

00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
EHCI USB2 Controller (rev 09) (prog-if 20 [EHCI])
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 58
	Region 0: Memory at df504000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=32
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: df200000-df2fffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000d7f00000
	Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [50] #0d [0000]

00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC
Interface Controller (rev 09)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE
Controller (rev 09) (prog-if 8a [Master SecP PriP])
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 169
	Region 0: I/O ports at <unassigned>
	Region 1: I/O ports at <unassigned>
	Region 2: I/O ports at <unassigned>
	Region 3: I/O ports at <unassigned>
	Region 4: I/O ports at 1860 [size=16]

00:1f.2 IDE interface: Intel Corporation 631xESB/632xESB/3100 Chipset
SATA Storage Controller IDE (rev 09) (prog-if 8f [Master SecP SecO
PriP PriO])
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 66
	Region 0: I/O ports at 18a0 [size=8]
	Region 1: I/O ports at 1898 [size=4]
	Region 2: I/O ports at 1890 [size=8]
	Region 3: I/O ports at 1874 [size=4]
	Region 4: I/O ports at 1880 [size=16]
	Region 5: Memory at df504400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus
Controller (rev 09)
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin C routed to IRQ 74
	Region 4: I/O ports at 1100 [size=32]

04:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Upstream Port (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Bus: primary=04, secondary=05, subordinate=06, sec-latency=0
	Memory behind bridge: de000000-deffffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000ddf00000
	Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [44] Express Upstream Port IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: SlotPowerLimit 0.000000
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
		Link: Latency L0s unlimited, L1 unlimited
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] #0d [0000]
	Capabilities: [100] Advanced Error Reporting

04:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to
PCI-X Bridge (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 10
	Bus: primary=04, secondary=07, subordinate=07, sec-latency=64
	Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal+ Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 256 bytes, MaxReadReq 256 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
		Link: Latency L0s unlimited, L1 unlimited
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
	Capabilities: [6c] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] #0d [0000]
	Capabilities: [d8] PCI-X bridge device.
		Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=3
		Status: Bus=0 Dev=0 Func=3 64bit- 133MHz- SCD- USC-, SCO-, SRD-
		: Upstream: Capacity=65535, Commitment Limit=65535
		: Downstream: Capacity=65535, Commitment Limit=65535
	Capabilities: [100] Advanced Error Reporting

05:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E1 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Bus: primary=05, secondary=06, subordinate=06, sec-latency=0
	Memory behind bridge: de000000-deffffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000ddf00000
	Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [44] Express Downstream Port (Slot-) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 2048 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
		Link: Latency L0s unlimited, L1 unlimited
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
	Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] #0d [0000]
	Capabilities: [100] Advanced Error Reporting

06:00.0 Network controller: Centre for Development of Advanced
Computing: Unknown device 0102
	Subsystem: Centre for Development of Advanced Computing: Unknown device 0102
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Interrupt: pin A routed to IRQ 114
	Region 0: Memory at de000000 (64-bit, non-prefetchable) [size=16M]
	Region 2: Memory at d8000000 (64-bit, prefetchable) [size=64M]
	Region 4: Memory at dc000000 (64-bit, prefetchable) [size=32M]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
		Address: 00000000fee02000  Data: 4072
	Capabilities: [58] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 0
		Link: Latency L0s unlimited, L1 unlimited
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
	Capabilities: [100] Device Serial Number 00-00-00-00-00-00-00-00

08:00.0 Ethernet controller: Intel Corporation: Unknown device 10a7 (rev 02)
	Subsystem: Super Micro Computer Inc: Unknown device 10a7
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Interrupt: pin A routed to IRQ 98
	Region 0: Memory at df140000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at df120000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at 2000 [size=32]
	Region 3: Memory at df100000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4062
	Capabilities: [60] MSI-X: Enable- Mask- TabSize=10
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00002000
	Capabilities: [a0] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <64us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 12
		Link: Latency L0s <4us, L1 <64us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 6a-05-c2-ff-ff-48-30-00

08:00.1 Ethernet controller: Intel Corporation: Unknown device 10a7 (rev 02)
	Subsystem: Super Micro Computer Inc: Unknown device 10a7
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Interrupt: pin B routed to IRQ 106
	Region 0: Memory at df180000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at df160000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at 2020 [size=32]
	Region 3: Memory at df104000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
		Address: 00000000fee04000  Data: 406a
	Capabilities: [60] MSI-X: Enable- Mask- TabSize=10
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00002000
	Capabilities: [a0] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <64us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 12
		Link: Latency L0s <4us, L1 <64us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 6a-05-c2-ff-ff-48-30-00

0a:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev
02) (prog-if 00 [VGA])
	Subsystem: Super Micro Computer Inc: Unknown device a280
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping+ SERR- FastB2B+
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 66 (2000ns min), Cache Line Size 08
	Interrupt: pin A routed to IRQ 74
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at 3000 [size=256]
	Region 2: Memory at df200000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-


On Wed, Dec 31, 2008 at 12:47 PM, Robert Hancock <hancockr@shaw.ca> wrote:
> yogeshwar sonawane wrote:
>>
>> Hi all,
>>
>> I have seen the following message in /var/log/messages file :-
>>
>> PCI: Device 0000:01:00.0 not available because of resource collisions
>>
>> Whenever this msg comes, the PCI card which is present in 0000:01:00.0
>> is not useful/accessible.
>> While detection of card, pci_set_master() fails.
>> But after reboot, that msg goes & card is working fine.
>>
>> This card is a Network controller PCI-Express based card.
>> The above problem comes very rarely & not on all the test nodes. The
>> situation may be difficult to reproduce.
>>
>> So, my question is, what to interpret from the above message ?
>> PCI bios allocates the PCI resources. So where to look to remove this
>> error ?
>
> Is there something overlapping in the PCI resource allocations? Can you post
> the lspci -vv output?
>

------=_Part_190837_14077581.1230714036281
Content-Type: application/octet-stream; name=lspci_vv_log
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpdru7w40
Content-Disposition: attachment; filename=lspci_vv_log

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb246IFVua25vd24gZGV2aWNlIDQw
MDMgKHJldiAyMCkKCVN1YnN5c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBVbmtub3du
IGRldmljZSBhMjgwCglDb250cm9sOiBJL08tIE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1l
bVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVz
OiBDYXArIDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0g
PFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBT
aXplIDA4CglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTY5CglDYXBhYmlsaXRpZXM6
IFs1MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQx
LSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90KyxEM2NvbGQrKQoJCVN0
YXR1czogRDAgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczog
WzU4XSBNZXNzYWdlIFNpZ25hbGxlZCBJbnRlcnJ1cHRzOiA2NGJpdC0gUXVldWU9MC8xIEVuYWJs
ZS0KCQlBZGRyZXNzOiBmZWUwMDAwMCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbNmNdIEV4
cHJlc3MgUm9vdCBQb3J0IChTbG90LSkgSVJRIDAKCQlEZXZpY2U6IFN1cHBvcnRlZDogTWF4UGF5
bG9hZCAyNTYgYnl0ZXMsIFBoYW50RnVuYyAwLCBFeHRUYWctCgkJRGV2aWNlOiBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCURldmljZTogRXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFs
LSBGYXRhbC0gVW5zdXBwb3J0ZWQtCgkJRGV2aWNlOiBSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVu
Yy0gQXV4UHdyLSBOb1Nub29wLQoJCURldmljZTogTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJl
YWRSZXEgMTI4IGJ5dGVzCgkJTGluazogU3VwcG9ydGVkIFNwZWVkIDIuNUdiL3MsIFdpZHRoIHg0
LCBBU1BNIEwwcyBMMSwgUG9ydCAwCgkJTGluazogTGF0ZW5jeSBMMHMgPDF1cywgTDEgPDR1cwoJ
CUxpbms6IEFTUE0gRGlzYWJsZWQgUkNCIDY0IGJ5dGVzIENvbW1DbGsrIEV4dFN5bmNoLQoJCUxp
bms6IFNwZWVkIDIuNUdiL3MsIFdpZHRoIHg0CgkJUm9vdDogQ29ycmVjdGFibGUtIE5vbi1GYXRh
bC0gRmF0YWwtIFBNRS0KCUNhcGFiaWxpdGllczogWzEwMF0gQWR2YW5jZWQgRXJyb3IgUmVwb3J0
aW5nCgowMDowMS4wIFBDSSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9uOiBVbmtub3duIGRldmlj
ZSA0MDIxIChyZXYgMjApIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkKCUNvbnRyb2w6IEkv
TysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0g
U3RlcHBpbmctIFNFUlItIEZhc3RCMkItCglTdGF0dXM6IENhcCsgNjZNaHotIFVERi0gRmFzdEIy
Qi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0g
PFBFUlItCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemUgMDgKCUJ1czogcHJpbWFyeT0wMCwg
c2Vjb25kYXJ5PTAxLCBzdWJvcmRpbmF0ZT0wMSwgc2VjLWxhdGVuY3k9MAoJU2Vjb25kYXJ5IHN0
YXR1czogNjZNaHotIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9y
dC0gPE1BYm9ydC0gPFNFUlItIDxQRVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlItIE5vSVNB
KyBWR0EtIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJQ2FwYWJpbGl0aWVzOiBbNTBdIFBvd2Vy
IE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1
cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIFBN
RS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs1OF0gTWVzc2Fn
ZSBTaWduYWxsZWQgSW50ZXJydXB0czogNjRiaXQtIFF1ZXVlPTAvMSBFbmFibGUtCgkJQWRkcmVz
czogZmVlMDAwMDAgIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzZjXSBFeHByZXNzIFJvb3Qg
UG9ydCAoU2xvdCspIElSUSAwCgkJRGV2aWNlOiBTdXBwb3J0ZWQ6IE1heFBheWxvYWQgMjU2IGJ5
dGVzLCBQaGFudEZ1bmMgMCwgRXh0VGFnLQoJCURldmljZTogTGF0ZW5jeSBMMHMgPDY0bnMsIEwx
IDwxdXMKCQlEZXZpY2U6IEVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVu
c3VwcG9ydGVkLQoJCURldmljZTogUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0g
Tm9Tbm9vcC0KCQlEZXZpY2U6IE1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDEyOCBi
eXRlcwoJCUxpbms6IFN1cHBvcnRlZCBTcGVlZCB1bmtub3duLCBXaWR0aCB4OCwgQVNQTSBMMHMg
TDEsIFBvcnQgNAoJCUxpbms6IExhdGVuY3kgTDBzIDwxdXMsIEwxIDw0dXMKCQlMaW5rOiBBU1BN
IERpc2FibGVkIFJDQiA2NCBieXRlcyBEaXNhYmxlZCBDb21tQ2xrLSBFeHRTeW5jaC0KCQlMaW5r
OiBTcGVlZCB1bmtub3duLCBXaWR0aCB4OAoJCVNsb3Q6IEF0bkJ0bi0gUHdyQ3RybC0gTVJMLSBB
dG5JbmQtIFB3ckluZC0gSG90UGx1Zy0gU3VycGlzZS0KCQlTbG90OiBOdW1iZXIgMCwgUG93ZXJM
aW1pdCAwLjAwMDAwMAoJCVNsb3Q6IEVuYWJsZWQgQXRuQnRuLSBQd3JGbHQtIE1STC0gUHJlc0Rl
dC0gQ21kQ3BsdC0gSFBJcnEtCgkJU2xvdDogQXR0bkluZCBPZmYsIFB3ckluZCBPZmYsIFBvd2Vy
LQoJCVJvb3Q6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBQTUUtCglDYXBhYmlsaXRp
ZXM6IFtiMF0gIzBkIFswMDAwXQoJQ2FwYWJpbGl0aWVzOiBbMTAwXSBBZHZhbmNlZCBFcnJvciBS
ZXBvcnRpbmcKCjAwOjAzLjAgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb246IFVua25vd24g
ZGV2aWNlIDQwMjMgKHJldiAyMCkgKHByb2ctaWYgMDAgW05vcm1hbCBkZWNvZGVdKQoJQ29udHJv
bDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFy
RXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0KCVN0YXR1czogQ2FwKyA2Nk1oei0gVURGLSBG
YXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5T
RVJSLSA8UEVSUi0KCUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZSAwOAoJQnVzOiBwcmltYXJ5
PTAwLCBzZWNvbmRhcnk9MDIsIHN1Ym9yZGluYXRlPTAyLCBzZWMtbGF0ZW5jeT0wCglTZWNvbmRh
cnkgc3RhdHVzOiA2Nk1oei0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8
VEFib3J0LSA8TUFib3J0LSA8U0VSUi0gPFBFUlItCglCcmlkZ2VDdGw6IFBhcml0eS0gU0VSUi0g
Tm9JU0ErIFZHQS0gTUFib3J0LSA+UmVzZXQtIEZhc3RCMkItCglDYXBhYmlsaXRpZXM6IFs1MF0g
UG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0g
QXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czog
RDAgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzU4XSBN
ZXNzYWdlIFNpZ25hbGxlZCBJbnRlcnJ1cHRzOiA2NGJpdC0gUXVldWU9MC8xIEVuYWJsZS0KCQlB
ZGRyZXNzOiBmZWUwMDAwMCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbNmNdIEV4cHJlc3Mg
Um9vdCBQb3J0IChTbG90KykgSVJRIDAKCQlEZXZpY2U6IFN1cHBvcnRlZDogTWF4UGF5bG9hZCAy
NTYgYnl0ZXMsIFBoYW50RnVuYyAwLCBFeHRUYWctCgkJRGV2aWNlOiBMYXRlbmN5IEwwcyA8NjRu
cywgTDEgPDF1cwoJCURldmljZTogRXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRh
bC0gVW5zdXBwb3J0ZWQtCgkJRGV2aWNlOiBSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4
UHdyLSBOb1Nub29wLQoJCURldmljZTogTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEg
MTI4IGJ5dGVzCgkJTGluazogU3VwcG9ydGVkIFNwZWVkIHVua25vd24sIFdpZHRoIHg4LCBBU1BN
IEwwcyBMMSwgUG9ydCA2CgkJTGluazogTGF0ZW5jeSBMMHMgPDF1cywgTDEgPDR1cwoJCUxpbms6
IEFTUE0gRGlzYWJsZWQgUkNCIDY0IGJ5dGVzIERpc2FibGVkIENvbW1DbGstIEV4dFN5bmNoLQoJ
CUxpbms6IFNwZWVkIHVua25vd24sIFdpZHRoIHg4CgkJU2xvdDogQXRuQnRuLSBQd3JDdHJsLSBN
UkwtIEF0bkluZC0gUHdySW5kLSBIb3RQbHVnLSBTdXJwaXNlLQoJCVNsb3Q6IE51bWJlciAwLCBQ
b3dlckxpbWl0IDAuMDAwMDAwCgkJU2xvdDogRW5hYmxlZCBBdG5CdG4tIFB3ckZsdC0gTVJMLSBQ
cmVzRGV0LSBDbWRDcGx0LSBIUElycS0KCQlTbG90OiBBdHRuSW5kIE9mZiwgUHdySW5kIE9mZiwg
UG93ZXItCgkJUm9vdDogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFBNRS0KCUNhcGFi
aWxpdGllczogW2IwXSAjMGQgWzAwMDBdCglDYXBhYmlsaXRpZXM6IFsxMDBdIEFkdmFuY2VkIEVy
cm9yIFJlcG9ydGluZwoKMDA6MDUuMCBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbjogVW5r
bm93biBkZXZpY2UgNDAyNSAocmV2IDIwKSAocHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglD
b250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29w
LSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBDYXArIDY2TWh6LSBV
REYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9y
dC0gPlNFUlItIDxQRVJSLQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplIDA4CglCdXM6IHBy
aW1hcnk9MDAsIHNlY29uZGFyeT0wMywgc3Vib3JkaW5hdGU9MDMsIHNlYy1sYXRlbmN5PTAKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TWh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJv
cnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFyaXR5LSBT
RVJSLSBOb0lTQSsgVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCUNhcGFiaWxpdGllczog
WzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMwoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEt
IEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3Rh
dHVzOiBEMCBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBb
NThdIE1lc3NhZ2UgU2lnbmFsbGVkIEludGVycnVwdHM6IDY0Yml0LSBRdWV1ZT0wLzEgRW5hYmxl
LQoJCUFkZHJlc3M6IGZlZTAwMDAwICBEYXRhOiAwMDAwCglDYXBhYmlsaXRpZXM6IFs2Y10gRXhw
cmVzcyBSb290IFBvcnQgKFNsb3QrKSBJUlEgMAoJCURldmljZTogU3VwcG9ydGVkOiBNYXhQYXls
b2FkIDI1NiBieXRlcywgUGhhbnRGdW5jIDAsIEV4dFRhZy0KCQlEZXZpY2U6IExhdGVuY3kgTDBz
IDw2NG5zLCBMMSA8MXVzCgkJRGV2aWNlOiBFcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwt
IEZhdGFsLSBVbnN1cHBvcnRlZC0KCQlEZXZpY2U6IFJseGRPcmQtIEV4dFRhZy0gUGhhbnRGdW5j
LSBBdXhQd3ItIE5vU25vb3AtCgkJRGV2aWNlOiBNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVh
ZFJlcSAxMjggYnl0ZXMKCQlMaW5rOiBTdXBwb3J0ZWQgU3BlZWQgdW5rbm93biwgV2lkdGggeDgs
IEFTUE0gTDBzIEwxLCBQb3J0IDgKCQlMaW5rOiBMYXRlbmN5IEwwcyA8MXVzLCBMMSA8NHVzCgkJ
TGluazogQVNQTSBEaXNhYmxlZCBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQgQ29tbUNsay0gRXh0U3lu
Y2gtCgkJTGluazogU3BlZWQgdW5rbm93biwgV2lkdGggeDgKCQlTbG90OiBBdG5CdG4tIFB3ckN0
cmwtIE1STC0gQXRuSW5kLSBQd3JJbmQtIEhvdFBsdWctIFN1cnBpc2UtCgkJU2xvdDogTnVtYmVy
IDAsIFBvd2VyTGltaXQgMC4wMDAwMDAKCQlTbG90OiBFbmFibGVkIEF0bkJ0bi0gUHdyRmx0LSBN
UkwtIFByZXNEZXQtIENtZENwbHQtIEhQSXJxLQoJCVNsb3Q6IEF0dG5JbmQgT2ZmLCBQd3JJbmQg
T2ZmLCBQb3dlci0KCQlSb290OiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gUE1FLQoJ
Q2FwYWJpbGl0aWVzOiBbYjBdICMwZCBbMDAwMF0KCUNhcGFiaWxpdGllczogWzEwMF0gQWR2YW5j
ZWQgRXJyb3IgUmVwb3J0aW5nCgowMDowNy4wIFBDSSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9u
OiBVbmtub3duIGRldmljZSA0MDI3IChyZXYgMjApIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2Rl
XSkKCUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdB
U25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItCglTdGF0dXM6IENhcCsgNjZN
aHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8
TUFib3J0LSA+U0VSUi0gPFBFUlItCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemUgMDgKCUJ1
czogcHJpbWFyeT0wMCwgc2Vjb25kYXJ5PTA0LCBzdWJvcmRpbmF0ZT0wNywgc2VjLWxhdGVuY3k9
MAoJTWVtb3J5IGJlaGluZCBicmlkZ2U6IGRlMDAwMDAwLWRmMGZmZmZmCglQcmVmZXRjaGFibGUg
bWVtb3J5IGJlaGluZCBicmlkZ2U6IDAwMDAwMDAwZDgwMDAwMDAtMDAwMDAwMDBkZGYwMDAwMAoJ
U2Vjb25kYXJ5IHN0YXR1czogNjZNaHotIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRB
Ym9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPFNFUlItIDxQRVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHkt
IFNFUlItIE5vSVNBKyBWR0EtIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJQ2FwYWJpbGl0aWVz
OiBbNTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBE
MS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlT
dGF0dXM6IEQwIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6
IFs1OF0gTWVzc2FnZSBTaWduYWxsZWQgSW50ZXJydXB0czogNjRiaXQtIFF1ZXVlPTAvMSBFbmFi
bGUtCgkJQWRkcmVzczogZmVlMDAwMDAgIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzZjXSBF
eHByZXNzIFJvb3QgUG9ydCAoU2xvdC0pIElSUSAwCgkJRGV2aWNlOiBTdXBwb3J0ZWQ6IE1heFBh
eWxvYWQgMjU2IGJ5dGVzLCBQaGFudEZ1bmMgMCwgRXh0VGFnLQoJCURldmljZTogTGF0ZW5jeSBM
MHMgPDY0bnMsIEwxIDwxdXMKCQlEZXZpY2U6IEVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRh
bC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCURldmljZTogUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1
bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQlEZXZpY2U6IE1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhS
ZWFkUmVxIDEyOCBieXRlcwoJCUxpbms6IFN1cHBvcnRlZCBTcGVlZCB1bmtub3duLCBXaWR0aCB4
OCwgQVNQTSBMMHMgTDEsIFBvcnQgMTAKCQlMaW5rOiBMYXRlbmN5IEwwcyA8MXVzLCBMMSA8NHVz
CgkJTGluazogQVNQTSBEaXNhYmxlZCBSQ0IgNjQgYnl0ZXMgQ29tbUNsaysgRXh0U3luY2gtCgkJ
TGluazogU3BlZWQgdW5rbm93biwgV2lkdGggeDgKCQlSb290OiBDb3JyZWN0YWJsZS0gTm9uLUZh
dGFsLSBGYXRhbC0gUE1FLQoJQ2FwYWJpbGl0aWVzOiBbYjBdICMwZCBbMDAwMF0KCUNhcGFiaWxp
dGllczogWzEwMF0gQWR2YW5jZWQgRXJyb3IgUmVwb3J0aW5nCgowMDowOS4wIFBDSSBicmlkZ2U6
IEludGVsIENvcnBvcmF0aW9uOiBVbmtub3duIGRldmljZSA0MDI5IChyZXYgMjApIChwcm9nLWlm
IDAwIFtOb3JtYWwgZGVjb2RlXSkKCUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWND
eWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkIt
CglTdGF0dXM6IENhcCsgNjZNaHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+
VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItCglMYXRlbmN5OiAwLCBDYWNo
ZSBMaW5lIFNpemUgMDgKCUJ1czogcHJpbWFyeT0wMCwgc2Vjb25kYXJ5PTA4LCBzdWJvcmRpbmF0
ZT0wOCwgc2VjLWxhdGVuY3k9MAoJSS9PIGJlaGluZCBicmlkZ2U6IDAwMDAyMDAwLTAwMDAyZmZm
CglNZW1vcnkgYmVoaW5kIGJyaWRnZTogZGYxMDAwMDAtZGYxZmZmZmYKCVNlY29uZGFyeSBzdGF0
dXM6IDY2TWh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQt
IDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFyaXR5LSBTRVJSLSBOb0lTQSsg
VkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCUNhcGFiaWxpdGllczogWzUwXSBQb3dlciBN
YW5hZ2VtZW50IHZlcnNpb24gMwoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJy
ZW50PTBtQSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBQTUUt
RW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNThdIE1lc3NhZ2Ug
U2lnbmFsbGVkIEludGVycnVwdHM6IDY0Yml0LSBRdWV1ZT0wLzEgRW5hYmxlLQoJCUFkZHJlc3M6
IGZlZTAwMDAwICBEYXRhOiAwMDAwCglDYXBhYmlsaXRpZXM6IFs2Y10gRXhwcmVzcyBSb290IFBv
cnQgKFNsb3QrKSBJUlEgMAoJCURldmljZTogU3VwcG9ydGVkOiBNYXhQYXlsb2FkIDI1NiBieXRl
cywgUGhhbnRGdW5jIDAsIEV4dFRhZy0KCQlEZXZpY2U6IExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8
MXVzCgkJRGV2aWNlOiBFcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1
cHBvcnRlZC0KCQlEZXZpY2U6IFJseGRPcmQtIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5v
U25vb3AtCgkJRGV2aWNlOiBNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSAxMjggYnl0
ZXMKCQlMaW5rOiBTdXBwb3J0ZWQgU3BlZWQgdW5rbm93biwgV2lkdGggeDQsIEFTUE0gTDBzIEwx
LCBQb3J0IDEyCgkJTGluazogTGF0ZW5jeSBMMHMgPDF1cywgTDEgPDR1cwoJCUxpbms6IEFTUE0g
RGlzYWJsZWQgUkNCIDY0IGJ5dGVzIENvbW1DbGsrIEV4dFN5bmNoLQoJCUxpbms6IFNwZWVkIHVu
a25vd24sIFdpZHRoIHg0CgkJU2xvdDogQXRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0bkluZC0gUHdy
SW5kLSBIb3RQbHVnLSBTdXJwaXNlLQoJCVNsb3Q6IE51bWJlciAwLCBQb3dlckxpbWl0IDAuMDAw
MDAwCgkJU2xvdDogRW5hYmxlZCBBdG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0LSBDbWRDcGx0
LSBIUElycS0KCQlTbG90OiBBdHRuSW5kIE9mZiwgUHdySW5kIE9mZiwgUG93ZXItCgkJUm9vdDog
Q29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFBNRS0KCUNhcGFiaWxpdGllczogW2IwXSAj
MGQgWzAwMDBdCglDYXBhYmlsaXRpZXM6IFsxMDBdIEFkdmFuY2VkIEVycm9yIFJlcG9ydGluZwoK
MDA6MGYuMCBTeXN0ZW0gcGVyaXBoZXJhbDogSW50ZWwgQ29ycG9yYXRpb246IFVua25vd24gZGV2
aWNlIDQwMmYgKHJldiAyMCkKCVN1YnN5c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBV
bmtub3duIGRldmljZSBhMjgwCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3lj
bGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJ
U3RhdHVzOiBDYXArIDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRB
Ym9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoJTGF0ZW5jeTogMAoJSW50ZXJy
dXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDIxNwoJUmVnaW9uIDA6IE1lbW9yeSBhdCBmZTcwMDAw
MCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0xNktdCglDYXBhYmlsaXRpZXM6IFs1
MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBE
Mi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1
czogRDAgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzU4
XSBNU0ktWDogRW5hYmxlLSBNYXNrLSBUYWJTaXplPTQKCQlWZWN0b3IgdGFibGU6IEJBUj0wIG9m
ZnNldD0wMDAwMjAwMAoJCVBCQTogQkFSPTAgb2Zmc2V0PTAwMDAzMDAwCglDYXBhYmlsaXRpZXM6
IFs2Y10gRXhwcmVzcyBVbmtub3duIHR5cGUgSVJRIDAKCQlEZXZpY2U6IFN1cHBvcnRlZDogTWF4
UGF5bG9hZCAyNTYgYnl0ZXMsIFBoYW50RnVuYyAwLCBFeHRUYWctCgkJRGV2aWNlOiBMYXRlbmN5
IEwwcyA8NjRucywgTDEgPDF1cwoJCURldmljZTogRXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZh
dGFsLSBGYXRhbC0gVW5zdXBwb3J0ZWQtCgkJRGV2aWNlOiBSbHhkT3JkLSBFeHRUYWctIFBoYW50
RnVuYy0gQXV4UHdyLSBOb1Nub29wKwoJCURldmljZTogTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1h
eFJlYWRSZXEgMTI4IGJ5dGVzCgkJTGluazogU3VwcG9ydGVkIFNwZWVkIHVua25vd24sIFdpZHRo
IHgwLCBBU1BNIHVua25vd24sIFBvcnQgMAoJCUxpbms6IExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8
MXVzCgkJTGluazogQVNQTSBEaXNhYmxlZCBDb21tQ2xrLSBFeHRTeW5jaC0KCQlMaW5rOiBTcGVl
ZCB1bmtub3duLCBXaWR0aCB4MAoKMDA6MTAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRp
b246IFVua25vd24gZGV2aWNlIDQwMzAgKHJldiAyMCkKCVN1YnN5c3RlbTogU3VwZXIgTWljcm8g
Q29tcHV0ZXIgSW5jOiBVbmtub3duIGRldmljZSBhMjgwCglDb250cm9sOiBJL08tIE1lbS0gQnVz
TWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBDYXAtIDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0g
REVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoKMDA6
MTAuMSBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb246IFVua25vd24gZGV2aWNlIDQwMzAg
KHJldiAyMCkKCVN1YnN5c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBVbmtub3duIGRl
dmljZSBhMjgwCglDb250cm9sOiBJL08tIE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJ
TlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBD
YXAtIDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRB
Ym9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoKMDA6MTAuMiBIb3N0IGJyaWRnZTogSW50ZWwg
Q29ycG9yYXRpb246IFVua25vd24gZGV2aWNlIDQwMzAgKHJldiAyMCkKCVN1YnN5c3RlbTogU3Vw
ZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBVbmtub3duIGRldmljZSBhMjgwCglDb250cm9sOiBJL08t
IE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0
ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBDYXAtIDY2TWh6LSBVREYtIEZhc3RCMkIt
IFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQ
RVJSLQoKMDA6MTAuMyBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb246IFVua25vd24gZGV2
aWNlIDQwMzAgKHJldiAyMCkKCVN1YnN5c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBV
bmtub3duIGRldmljZSBhMjgwCglDb250cm9sOiBJL08tIE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3lj
bGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJ
U3RhdHVzOiBDYXAtIDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRB
Ym9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoKMDA6MTAuNCBIb3N0IGJyaWRn
ZTogSW50ZWwgQ29ycG9yYXRpb246IFVua25vd24gZGV2aWNlIDQwMzAgKHJldiAyMCkKCVN1YnN5
c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBVbmtub3duIGRldmljZSBhMjgwCglDb250
cm9sOiBJL08tIE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQ
YXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBDYXAtIDY2TWh6LSBVREYt
IEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0g
PlNFUlItIDxQRVJSLQoKMDA6MTEuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb246IFVu
a25vd24gZGV2aWNlIDQwMzEgKHJldiAyMCkKCVN1YnN5c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0
ZXIgSW5jOiBVbmtub3duIGRldmljZSBhMjgwCglDb250cm9sOiBJL08tIE1lbS0gQnVzTWFzdGVy
LSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBG
YXN0QjJCLQoJU3RhdHVzOiBDYXAtIDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VM
PWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoKMDA6MTUuMCBI
b3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb246IFVua25vd24gZGV2aWNlIDQwMzUgKHJldiAy
MCkKCVN1YnN5c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBVbmtub3duIGRldmljZSBh
MjgwCglDb250cm9sOiBJL08tIE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZH
QVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBDYXAtIDY2
TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0g
PE1BYm9ydC0gPlNFUlItIDxQRVJSLQoKMDA6MTUuMSBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9y
YXRpb246IFVua25vd24gZGV2aWNlIDQwMzUgKHJldiAyMCkKCVN1YnN5c3RlbTogU3VwZXIgTWlj
cm8gQ29tcHV0ZXIgSW5jOiBVbmtub3duIGRldmljZSBhMjgwCglDb250cm9sOiBJL08tIE1lbS0g
QnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5n
LSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBDYXAtIDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVy
ci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoK
MDA6MTYuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb246IFVua25vd24gZGV2aWNlIDQw
MzYgKHJldiAyMCkKCVN1YnN5c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBVbmtub3du
IGRldmljZSBhMjgwCglDb250cm9sOiBJL08tIE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1l
bVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVz
OiBDYXAtIDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0g
PFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoKMDA6MTYuMSBIb3N0IGJyaWRnZTogSW50
ZWwgQ29ycG9yYXRpb246IFVua25vd24gZGV2aWNlIDQwMzYgKHJldiAyMCkKCVN1YnN5c3RlbTog
U3VwZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBVbmtub3duIGRldmljZSBhMjgwCglDb250cm9sOiBJ
L08tIE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnIt
IFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBDYXAtIDY2TWh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlIt
IDxQRVJSLQoKMDA6MWMuMCBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2MzF4RVNCLzYz
MnhFU0IvMzEwMCBDaGlwc2V0IFBDSSBFeHByZXNzIFJvb3QgUG9ydCAxIChyZXYgMDkpIChwcm9n
LWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkKCUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNw
ZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RC
MkItCglTdGF0dXM6IENhcCsgNjZNaHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFz
dCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItCglMYXRlbmN5OiAwLCBD
YWNoZSBMaW5lIFNpemUgMDgKCUJ1czogcHJpbWFyeT0wMCwgc2Vjb25kYXJ5PTA5LCBzdWJvcmRp
bmF0ZT0wOSwgc2VjLWxhdGVuY3k9MAoJU2Vjb25kYXJ5IHN0YXR1czogNjZNaHotIEZhc3RCMkIt
IFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPFNFUlItIDxQ
RVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlItIE5vSVNBKyBWR0EtIE1BYm9ydC0gPlJlc2V0
LSBGYXN0QjJCLQoJQ2FwYWJpbGl0aWVzOiBbNDBdIEV4cHJlc3MgUm9vdCBQb3J0IChTbG90Kykg
SVJRIDAKCQlEZXZpY2U6IFN1cHBvcnRlZDogTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVu
YyAwLCBFeHRUYWcrCgkJRGV2aWNlOiBMYXRlbmN5IEwwcyB1bmxpbWl0ZWQsIEwxIHVubGltaXRl
ZAoJCURldmljZTogRXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gVW5zdXBw
b3J0ZWQtCgkJRGV2aWNlOiBSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nu
b29wLQoJCURldmljZTogTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVz
CgkJTGluazogU3VwcG9ydGVkIFNwZWVkIDIuNUdiL3MsIFdpZHRoIHg0LCBBU1BNIEwwcyBMMSwg
UG9ydCAxCgkJTGluazogTGF0ZW5jeSBMMHMgPDI1Nm5zLCBMMSA8NHVzCgkJTGluazogQVNQTSBE
aXNhYmxlZCBSQ0IgNjQgYnl0ZXMgQ29tbUNsaysgRXh0U3luY2gtCgkJTGluazogU3BlZWQgMi41
R2IvcywgV2lkdGggeDQKCQlTbG90OiBBdG5CdG4tIFB3ckN0cmwtIE1STC0gQXRuSW5kLSBQd3JJ
bmQtIEhvdFBsdWcrIFN1cnBpc2UrCgkJU2xvdDogTnVtYmVyIDAsIFBvd2VyTGltaXQgMC4wMDAw
MDAKCQlTbG90OiBFbmFibGVkIEF0bkJ0bi0gUHdyRmx0LSBNUkwtIFByZXNEZXQtIENtZENwbHQt
IEhQSXJxLQoJCVNsb3Q6IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLQoJ
CVJvb3Q6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBQTUUtCglDYXBhYmlsaXRpZXM6
IFs4MF0gTWVzc2FnZSBTaWduYWxsZWQgSW50ZXJydXB0czogNjRiaXQtIFF1ZXVlPTAvMCBFbmFi
bGUtCgkJQWRkcmVzczogMDAwMDAwMDAgIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzkwXSAj
MGQgWzAwMDBdCglDYXBhYmlsaXRpZXM6IFthMF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIK
CQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0s
RDItLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2Fs
ZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzEwMF0gVmlydHVhbCBDaGFubmVsCglDYXBhYmlsaXRp
ZXM6IFsxODBdIFVua25vd24gKDUpCgowMDoxZC4wIFVTQiBDb250cm9sbGVyOiBJbnRlbCBDb3Jw
b3JhdGlvbiA2MzF4RVNCLzYzMnhFU0IvMzEwMCBDaGlwc2V0IFVIQ0kgVVNCIENvbnRyb2xsZXIg
IzEgKHJldiAwOSkgKHByb2ctaWYgMDAgW1VIQ0ldKQoJU3Vic3lzdGVtOiBTdXBlciBNaWNybyBD
b21wdXRlciBJbmM6IFVua25vd24gZGV2aWNlIGEyODAKCUNvbnRyb2w6IEkvTysgTWVtLSBCdXNN
YXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNF
UlItIEZhc3RCMkItCglTdGF0dXM6IENhcC0gNjZNaHotIFVERi0gRmFzdEIyQisgUGFyRXJyLSBE
RVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0KCUxh
dGVuY3k6IDAKCUludGVycnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAyMjUKCVJlZ2lvbiA0OiBJ
L08gcG9ydHMgYXQgMTgwMCBbc2l6ZT0zMl0KCjAwOjFkLjEgVVNCIENvbnRyb2xsZXI6IEludGVs
IENvcnBvcmF0aW9uIDYzMXhFU0IvNjMyeEVTQi8zMTAwIENoaXBzZXQgVUhDSSBVU0IgQ29udHJv
bGxlciAjMiAocmV2IDA5KSAocHJvZy1pZiAwMCBbVUhDSV0pCglTdWJzeXN0ZW06IFN1cGVyIE1p
Y3JvIENvbXB1dGVyIEluYzogVW5rbm93biBkZXZpY2UgYTI4MAoJQ29udHJvbDogSS9PKyBNZW0t
IEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGlu
Zy0gU0VSUi0gRmFzdEIyQi0KCVN0YXR1czogQ2FwLSA2Nk1oei0gVURGLSBGYXN0QjJCKyBQYXJF
cnItIERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJS
LQoJTGF0ZW5jeTogMAoJSW50ZXJydXB0OiBwaW4gQiByb3V0ZWQgdG8gSVJRIDIzMwoJUmVnaW9u
IDQ6IEkvTyBwb3J0cyBhdCAxODIwIFtzaXplPTMyXQoKMDA6MWQuMiBVU0IgQ29udHJvbGxlcjog
SW50ZWwgQ29ycG9yYXRpb24gNjMxeEVTQi82MzJ4RVNCLzMxMDAgQ2hpcHNldCBVSENJIFVTQiBD
b250cm9sbGVyICMzIChyZXYgMDkpIChwcm9nLWlmIDAwIFtVSENJXSkKCVN1YnN5c3RlbTogU3Vw
ZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBVbmtub3duIGRldmljZSBhMjgwCglDb250cm9sOiBJL08r
IE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0
ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBDYXAtIDY2TWh6LSBVREYtIEZhc3RCMkIr
IFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0g
PFBFUlItCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBDIHJvdXRlZCB0byBJUlEgNTAKCVJl
Z2lvbiA0OiBJL08gcG9ydHMgYXQgMTg0MCBbc2l6ZT0zMl0KCjAwOjFkLjcgVVNCIENvbnRyb2xs
ZXI6IEludGVsIENvcnBvcmF0aW9uIDYzMXhFU0IvNjMyeEVTQi8zMTAwIENoaXBzZXQgRUhDSSBV
U0IyIENvbnRyb2xsZXIgKHJldiAwOSkgKHByb2ctaWYgMjAgW0VIQ0ldKQoJU3Vic3lzdGVtOiBT
dXBlciBNaWNybyBDb21wdXRlciBJbmM6IFVua25vd24gZGV2aWNlIGEyODAKCUNvbnRyb2w6IEkv
Ty0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0g
U3RlcHBpbmctIFNFUlItIEZhc3RCMkItCglTdGF0dXM6IENhcCsgNjZNaHotIFVERi0gRmFzdEIy
QisgUGFyRXJyLSBERVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJS
LSA8UEVSUi0KCUxhdGVuY3k6IDAKCUludGVycnVwdDogcGluIEQgcm91dGVkIHRvIElSUSA1OAoJ
UmVnaW9uIDA6IE1lbW9yeSBhdCBkZjUwNDAwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBb
c2l6ZT0xS10KCUNhcGFiaWxpdGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJ
CUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTM3NW1BIFBNRShEMCssRDEt
LEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIFBNRS1FbmFibGUtIERTZWw9MCBEU2Nh
bGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs1OF0gRGVidWcgcG9ydAoKMDA6MWUuMCBQQ0kgYnJp
ZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMSBQQ0kgQnJpZGdlIChyZXYgZDkpIChwcm9nLWlm
IDAxIFtTdWJ0cmFjdGl2ZSBkZWNvZGVdKQoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3Rlcisg
U3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFz
dEIyQi0KCVN0YXR1czogQ2FwKyA2Nk1oei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1m
YXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0KCUxhdGVuY3k6IDAK
CUJ1czogcHJpbWFyeT0wMCwgc2Vjb25kYXJ5PTBhLCBzdWJvcmRpbmF0ZT0wYSwgc2VjLWxhdGVu
Y3k9MzIKCUkvTyBiZWhpbmQgYnJpZGdlOiAwMDAwMzAwMC0wMDAwM2ZmZgoJTWVtb3J5IGJlaGlu
ZCBicmlkZ2U6IGRmMjAwMDAwLWRmMmZmZmZmCglQcmVmZXRjaGFibGUgbWVtb3J5IGJlaGluZCBi
cmlkZ2U6IDAwMDAwMDAwZDAwMDAwMDAtMDAwMDAwMDBkN2YwMDAwMAoJU2Vjb25kYXJ5IHN0YXR1
czogNjZNaHotIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0
LSA8TUFib3J0KyA8U0VSUi0gPFBFUlItCglCcmlkZ2VDdGw6IFBhcml0eS0gU0VSUi0gTm9JU0Er
IFZHQSsgTUFib3J0LSA+UmVzZXQtIEZhc3RCMkItCglDYXBhYmlsaXRpZXM6IFs1MF0gIzBkIFsw
MDAwXQoKMDA6MWYuMCBJU0EgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2MzF4RVNCLzYzMnhF
U0IvMzEwMCBDaGlwc2V0IExQQyBJbnRlcmZhY2UgQ29udHJvbGxlciAocmV2IDA5KQoJU3Vic3lz
dGVtOiBTdXBlciBNaWNybyBDb21wdXRlciBJbmM6IFVua25vd24gZGV2aWNlIGEyODAKCUNvbnRy
b2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBh
ckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItCglTdGF0dXM6IENhcC0gNjZNaHotIFVERi0g
RmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQt
ID5TRVJSLSA8UEVSUi0KCUxhdGVuY3k6IDAKCjAwOjFmLjEgSURFIGludGVyZmFjZTogSW50ZWwg
Q29ycG9yYXRpb24gNjMxeEVTQi82MzJ4RVNCIElERSBDb250cm9sbGVyIChyZXYgMDkpIChwcm9n
LWlmIDhhIFtNYXN0ZXIgU2VjUCBQcmlQXSkKCVN1YnN5c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0
ZXIgSW5jOiBVbmtub3duIGRldmljZSBhMjgwCglDb250cm9sOiBJL08rIE1lbS0gQnVzTWFzdGVy
KyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBG
YXN0QjJCLQoJU3RhdHVzOiBDYXAtIDY2TWh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VM
PW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItCglMYXRlbmN5
OiAwCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTY5CglSZWdpb24gMDogSS9PIHBv
cnRzIGF0IDx1bmFzc2lnbmVkPgoJUmVnaW9uIDE6IEkvTyBwb3J0cyBhdCA8dW5hc3NpZ25lZD4K
CVJlZ2lvbiAyOiBJL08gcG9ydHMgYXQgPHVuYXNzaWduZWQ+CglSZWdpb24gMzogSS9PIHBvcnRz
IGF0IDx1bmFzc2lnbmVkPgoJUmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCAxODYwIFtzaXplPTE2XQoK
MDA6MWYuMiBJREUgaW50ZXJmYWNlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2MzF4RVNCLzYzMnhFU0Iv
MzEwMCBDaGlwc2V0IFNBVEEgU3RvcmFnZSBDb250cm9sbGVyIElERSAocmV2IDA5KSAocHJvZy1p
ZiA4ZiBbTWFzdGVyIFNlY1AgU2VjTyBQcmlQIFByaU9dKQoJU3Vic3lzdGVtOiBTdXBlciBNaWNy
byBDb21wdXRlciBJbmM6IFVua25vd24gZGV2aWNlIGEyODAKCUNvbnRyb2w6IEkvTysgTWVtKyBC
dXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmct
IFNFUlItIEZhc3RCMkItCglTdGF0dXM6IENhcCsgNjZNaHorIFVERi0gRmFzdEIyQisgUGFyRXJy
LSBERVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0K
CUxhdGVuY3k6IDAKCUludGVycnVwdDogcGluIEIgcm91dGVkIHRvIElSUSA2NgoJUmVnaW9uIDA6
IEkvTyBwb3J0cyBhdCAxOGEwIFtzaXplPThdCglSZWdpb24gMTogSS9PIHBvcnRzIGF0IDE4OTgg
W3NpemU9NF0KCVJlZ2lvbiAyOiBJL08gcG9ydHMgYXQgMTg5MCBbc2l6ZT04XQoJUmVnaW9uIDM6
IEkvTyBwb3J0cyBhdCAxODc0IFtzaXplPTRdCglSZWdpb24gNDogSS9PIHBvcnRzIGF0IDE4ODAg
W3NpemU9MTZdCglSZWdpb24gNTogTWVtb3J5IGF0IGRmNTA0NDAwICgzMi1iaXQsIG5vbi1wcmVm
ZXRjaGFibGUpIFtzaXplPTFLXQoJQ2FwYWJpbGl0aWVzOiBbNzBdIFBvd2VyIE1hbmFnZW1lbnQg
dmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBN
RShEMC0sRDEtLEQyLSxEM2hvdCssRDNjb2xkLSkKCQlTdGF0dXM6IEQwIFBNRS1FbmFibGUtIERT
ZWw9MCBEU2NhbGU9MCBQTUUtCgowMDoxZi4zIFNNQnVzOiBJbnRlbCBDb3Jwb3JhdGlvbiA2MzF4
RVNCLzYzMnhFU0IvMzEwMCBDaGlwc2V0IFNNQnVzIENvbnRyb2xsZXIgKHJldiAwOSkKCVN1YnN5
c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBVbmtub3duIGRldmljZSBhMjgwCglDb250
cm9sOiBJL08rIE1lbS0gQnVzTWFzdGVyLSBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQ
YXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBDYXAtIDY2TWh6LSBVREYt
IEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0
LSA+U0VSUi0gPFBFUlItCglJbnRlcnJ1cHQ6IHBpbiBDIHJvdXRlZCB0byBJUlEgNzQKCVJlZ2lv
biA0OiBJL08gcG9ydHMgYXQgMTEwMCBbc2l6ZT0zMl0KCjA0OjAwLjAgUENJIGJyaWRnZTogSW50
ZWwgQ29ycG9yYXRpb24gNjMxMUVTQi82MzIxRVNCIFBDSSBFeHByZXNzIFVwc3RyZWFtIFBvcnQg
KHJldiAwMSkgKHByb2ctaWYgMDAgW05vcm1hbCBkZWNvZGVdKQoJQ29udHJvbDogSS9PKyBNZW0r
IEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGlu
Zy0gU0VSUi0gRmFzdEIyQi0KCVN0YXR1czogQ2FwKyA2Nk1oei0gVURGLSBGYXN0QjJCLSBQYXJF
cnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0K
CUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZSAwOAoJQnVzOiBwcmltYXJ5PTA0LCBzZWNvbmRh
cnk9MDUsIHN1Ym9yZGluYXRlPTA2LCBzZWMtbGF0ZW5jeT0wCglNZW1vcnkgYmVoaW5kIGJyaWRn
ZTogZGUwMDAwMDAtZGVmZmZmZmYKCVByZWZldGNoYWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTog
MDAwMDAwMDBkODAwMDAwMC0wMDAwMDAwMGRkZjAwMDAwCglTZWNvbmRhcnkgc3RhdHVzOiA2Nk1o
ei0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0
KyA8U0VSUi0gPFBFUlItCglCcmlkZ2VDdGw6IFBhcml0eS0gU0VSUi0gTm9JU0ErIFZHQS0gTUFi
b3J0LSA+UmVzZXQtIEZhc3RCMkItCglDYXBhYmlsaXRpZXM6IFs0NF0gRXhwcmVzcyBVcHN0cmVh
bSBQb3J0IElSUSAwCgkJRGV2aWNlOiBTdXBwb3J0ZWQ6IE1heFBheWxvYWQgMjU2IGJ5dGVzLCBQ
aGFudEZ1bmMgMCwgRXh0VGFnLQoJCURldmljZTogTGF0ZW5jeSBMMHMgPDY0bnMsIEwxIDwxdXMK
CQlEZXZpY2U6IEF0bkJ0bi0gQXRuSW5kLSBQd3JJbmQtCgkJRGV2aWNlOiBTbG90UG93ZXJMaW1p
dCAwLjAwMDAwMAoJCURldmljZTogRXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRh
bC0gVW5zdXBwb3J0ZWQtCgkJRGV2aWNlOiBSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4
UHdyLSBOb1Nub29wLQoJCURldmljZTogTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEg
NDA5NiBieXRlcwoJCUxpbms6IFN1cHBvcnRlZCBTcGVlZCAyLjVHYi9zLCBXaWR0aCB4OCwgQVNQ
TSBMMHMsIFBvcnQgMAoJCUxpbms6IExhdGVuY3kgTDBzIHVubGltaXRlZCwgTDEgdW5saW1pdGVk
CgkJTGluazogQVNQTSBEaXNhYmxlZCBDb21tQ2xrLSBFeHRTeW5jaC0KCQlMaW5rOiBTcGVlZCAy
LjVHYi9zLCBXaWR0aCB4OAoJQ2FwYWJpbGl0aWVzOiBbNzBdIFBvd2VyIE1hbmFnZW1lbnQgdmVy
c2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShE
MCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIFBNRS1FbmFibGUtIERTZWw9
MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs4MF0gIzBkIFswMDAwXQoJQ2FwYWJpbGl0
aWVzOiBbMTAwXSBBZHZhbmNlZCBFcnJvciBSZXBvcnRpbmcKCjA0OjAwLjMgUENJIGJyaWRnZTog
SW50ZWwgQ29ycG9yYXRpb24gNjMxMUVTQi82MzIxRVNCIFBDSSBFeHByZXNzIHRvIFBDSS1YIEJy
aWRnZSAocmV2IDAxKSAocHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08r
IE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0
ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBDYXArIDY2TWh6LSBVREYtIEZhc3RCMkIt
IFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQ
RVJSLQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplIDEwCglCdXM6IHByaW1hcnk9MDQsIHNl
Y29uZGFyeT0wNywgc3Vib3JkaW5hdGU9MDcsIHNlYy1sYXRlbmN5PTY0CglTZWNvbmRhcnkgc3Rh
dHVzOiA2Nk1oeisgRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJv
cnQtIDxNQWJvcnQrIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFyaXR5LSBTRVJSLSBOb0lT
QSsgVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCUNhcGFiaWxpdGllczogWzQ0XSBFeHBy
ZXNzIFBDSS9QQ0ktWCBCcmlkZ2UgSVJRIDAKCQlEZXZpY2U6IFN1cHBvcnRlZDogTWF4UGF5bG9h
ZCAyNTYgYnl0ZXMsIFBoYW50RnVuYyAwLCBFeHRUYWctCgkJRGV2aWNlOiBMYXRlbmN5IEwwcyA8
NjRucywgTDEgPDF1cwoJCURldmljZTogQXRuQnRuLSBBdG5JbmQtIFB3ckluZC0KCQlEZXZpY2U6
IEVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwrIFVuc3VwcG9ydGVkLQoJCURl
dmljZTogUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQlEZXZp
Y2U6IE1heFBheWxvYWQgMjU2IGJ5dGVzLCBNYXhSZWFkUmVxIDI1NiBieXRlcwoJCUxpbms6IFN1
cHBvcnRlZCBTcGVlZCAyLjVHYi9zLCBXaWR0aCB4OCwgQVNQTSBMMHMsIFBvcnQgMAoJCUxpbms6
IExhdGVuY3kgTDBzIHVubGltaXRlZCwgTDEgdW5saW1pdGVkCgkJTGluazogQVNQTSBEaXNhYmxl
ZCBDb21tQ2xrLSBFeHRTeW5jaC0KCQlMaW5rOiBTcGVlZCAyLjVHYi9zLCBXaWR0aCB4OAoJQ2Fw
YWJpbGl0aWVzOiBbNmNdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNs
ay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNj
b2xkKykKCQlTdGF0dXM6IEQwIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBh
YmlsaXRpZXM6IFs4MF0gIzBkIFswMDAwXQoJQ2FwYWJpbGl0aWVzOiBbZDhdIFBDSS1YIGJyaWRn
ZSBkZXZpY2UuCgkJU2Vjb25kYXJ5IFN0YXR1czogNjRiaXQrLCAxMzNNSHorLCBTQ0QtLCBVU0Mt
LCBTQ08tLCBTUkQtIEZyZXE9MwoJCVN0YXR1czogQnVzPTAgRGV2PTAgRnVuYz0zIDY0Yml0LSAx
MzNNSHotIFNDRC0gVVNDLSwgU0NPLSwgU1JELQoJCTogVXBzdHJlYW06IENhcGFjaXR5PTY1NTM1
LCBDb21taXRtZW50IExpbWl0PTY1NTM1CgkJOiBEb3duc3RyZWFtOiBDYXBhY2l0eT02NTUzNSwg
Q29tbWl0bWVudCBMaW1pdD02NTUzNQoJQ2FwYWJpbGl0aWVzOiBbMTAwXSBBZHZhbmNlZCBFcnJv
ciBSZXBvcnRpbmcKCjA1OjAwLjAgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gNjMxMUVT
Qi82MzIxRVNCIFBDSSBFeHByZXNzIERvd25zdHJlYW0gUG9ydCBFMSAocmV2IDAxKSAocHJvZy1p
ZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVj
Q3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJC
LQoJU3RhdHVzOiBDYXArIDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3Qg
PlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoJTGF0ZW5jeTogMCwgQ2Fj
aGUgTGluZSBTaXplIDA4CglCdXM6IHByaW1hcnk9MDUsIHNlY29uZGFyeT0wNiwgc3Vib3JkaW5h
dGU9MDYsIHNlYy1sYXRlbmN5PTAKCU1lbW9yeSBiZWhpbmQgYnJpZGdlOiBkZTAwMDAwMC1kZWZm
ZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9yeSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGQ4MDAwMDAw
LTAwMDAwMDAwZGRmMDAwMDAKCVNlY29uZGFyeSBzdGF0dXM6IDY2TWh6LSBGYXN0QjJCLSBQYXJF
cnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQrIDxTRVJSLSA8UEVSUi0K
CUJyaWRnZUN0bDogUGFyaXR5LSBTRVJSLSBOb0lTQSsgVkdBLSBNQWJvcnQtID5SZXNldC0gRmFz
dEIyQi0KCUNhcGFiaWxpdGllczogWzQ0XSBFeHByZXNzIERvd25zdHJlYW0gUG9ydCAoU2xvdC0p
IElSUSAwCgkJRGV2aWNlOiBTdXBwb3J0ZWQ6IE1heFBheWxvYWQgMjU2IGJ5dGVzLCBQaGFudEZ1
bmMgMCwgRXh0VGFnLQoJCURldmljZTogTGF0ZW5jeSBMMHMgPDY0bnMsIEwxIDwxdXMKCQlEZXZp
Y2U6IEVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJ
CURldmljZTogUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQlE
ZXZpY2U6IE1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDIwNDggYnl0ZXMKCQlMaW5r
OiBTdXBwb3J0ZWQgU3BlZWQgMi41R2IvcywgV2lkdGggeDgsIEFTUE0gTDBzLCBQb3J0IDAKCQlM
aW5rOiBMYXRlbmN5IEwwcyB1bmxpbWl0ZWQsIEwxIHVubGltaXRlZAoJCUxpbms6IEFTUE0gRGlz
YWJsZWQgQ29tbUNsay0gRXh0U3luY2gtCgkJTGluazogU3BlZWQgMi41R2IvcywgV2lkdGggeDgK
CUNhcGFiaWxpdGllczogWzYwXSBNZXNzYWdlIFNpZ25hbGxlZCBJbnRlcnJ1cHRzOiA2NGJpdCsg
UXVldWU9MC8wIEVuYWJsZS0KCQlBZGRyZXNzOiAwMDAwMDAwMDAwMDAwMDAwICBEYXRhOiAwMDAw
CglDYXBhYmlsaXRpZXM6IFs3MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczog
UE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90
KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0K
CUNhcGFiaWxpdGllczogWzgwXSAjMGQgWzAwMDBdCglDYXBhYmlsaXRpZXM6IFsxMDBdIEFkdmFu
Y2VkIEVycm9yIFJlcG9ydGluZwoKMDY6MDAuMCBOZXR3b3JrIGNvbnRyb2xsZXI6IENlbnRyZSBm
b3IgRGV2ZWxvcG1lbnQgb2YgQWR2YW5jZWQgQ29tcHV0aW5nOiBVbmtub3duIGRldmljZSAwMTAy
CglTdWJzeXN0ZW06IENlbnRyZSBmb3IgRGV2ZWxvcG1lbnQgb2YgQWR2YW5jZWQgQ29tcHV0aW5n
OiBVbmtub3duIGRldmljZSAwMTAyCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVj
Q3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJC
LQoJU3RhdHVzOiBDYXArIDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3Qg
PlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoJTGF0ZW5jeTogMCwgQ2Fj
aGUgTGluZSBTaXplIDA4CglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTE0CglSZWdp
b24gMDogTWVtb3J5IGF0IGRlMDAwMDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXpl
PTE2TV0KCVJlZ2lvbiAyOiBNZW1vcnkgYXQgZDgwMDAwMDAgKDY0LWJpdCwgcHJlZmV0Y2hhYmxl
KSBbc2l6ZT02NE1dCglSZWdpb24gNDogTWVtb3J5IGF0IGRjMDAwMDAwICg2NC1iaXQsIHByZWZl
dGNoYWJsZSkgW3NpemU9MzJNXQoJQ2FwYWJpbGl0aWVzOiBbNDBdIFBvd2VyIE1hbmFnZW1lbnQg
dmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBN
RShEMC0sRDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIFBNRS1FbmFibGUtIERT
ZWw9MCBEU2NhbGU9MSBQTUUtCglDYXBhYmlsaXRpZXM6IFs0OF0gTWVzc2FnZSBTaWduYWxsZWQg
SW50ZXJydXB0czogNjRiaXQrIFF1ZXVlPTAvMCBFbmFibGUrCgkJQWRkcmVzczogMDAwMDAwMDBm
ZWUwMjAwMCAgRGF0YTogNDA3MgoJQ2FwYWJpbGl0aWVzOiBbNThdIEV4cHJlc3MgRW5kcG9pbnQg
SVJRIDAKCQlEZXZpY2U6IFN1cHBvcnRlZDogTWF4UGF5bG9hZCA1MTIgYnl0ZXMsIFBoYW50RnVu
YyAwLCBFeHRUYWctCgkJRGV2aWNlOiBMYXRlbmN5IEwwcyB1bmxpbWl0ZWQsIEwxIHVubGltaXRl
ZAoJCURldmljZTogQXRuQnRuLSBBdG5JbmQtIFB3ckluZC0KCQlEZXZpY2U6IEVycm9yczogQ29y
cmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCURldmljZTogUmx4ZE9y
ZCsgRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcCsKCQlEZXZpY2U6IE1heFBheWxv
YWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDUxMiBieXRlcwoJCUxpbms6IFN1cHBvcnRlZCBTcGVl
ZCAyLjVHYi9zLCBXaWR0aCB4NCwgQVNQTSBMMHMsIFBvcnQgMAoJCUxpbms6IExhdGVuY3kgTDBz
IHVubGltaXRlZCwgTDEgdW5saW1pdGVkCgkJTGluazogQVNQTSBEaXNhYmxlZCBSQ0IgNjQgYnl0
ZXMgQ29tbUNsay0gRXh0U3luY2gtCgkJTGluazogU3BlZWQgMi41R2IvcywgV2lkdGggeDQKCUNh
cGFiaWxpdGllczogWzEwMF0gRGV2aWNlIFNlcmlhbCBOdW1iZXIgMDAtMDAtMDAtMDAtMDAtMDAt
MDAtMDAKCjA4OjAwLjAgRXRoZXJuZXQgY29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb246IFVu
a25vd24gZGV2aWNlIDEwYTcgKHJldiAwMikKCVN1YnN5c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0
ZXIgSW5jOiBVbmtub3duIGRldmljZSAxMGE3CglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVy
KyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBG
YXN0QjJCLQoJU3RhdHVzOiBDYXArIDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VM
PWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoJTGF0ZW5jeTog
MCwgQ2FjaGUgTGluZSBTaXplIDA4CglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgOTgK
CVJlZ2lvbiAwOiBNZW1vcnkgYXQgZGYxNDAwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkg
W3NpemU9MTI4S10KCVJlZ2lvbiAxOiBNZW1vcnkgYXQgZGYxMjAwMDAgKDMyLWJpdCwgbm9uLXBy
ZWZldGNoYWJsZSkgW3NpemU9MTI4S10KCVJlZ2lvbiAyOiBJL08gcG9ydHMgYXQgMjAwMCBbc2l6
ZT0zMl0KCVJlZ2lvbiAzOiBNZW1vcnkgYXQgZGYxMDAwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNo
YWJsZSkgW3NpemU9MTZLXQoJQ2FwYWJpbGl0aWVzOiBbNDBdIFBvd2VyIE1hbmFnZW1lbnQgdmVy
c2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJKyBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShE
MCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIFBNRS1FbmFibGUtIERTZWw9
MCBEU2NhbGU9MSBQTUUtCglDYXBhYmlsaXRpZXM6IFs1MF0gTWVzc2FnZSBTaWduYWxsZWQgSW50
ZXJydXB0czogNjRiaXQrIFF1ZXVlPTAvMCBFbmFibGUrCgkJQWRkcmVzczogMDAwMDAwMDBmZWUw
MDAwMCAgRGF0YTogNDA2MgoJQ2FwYWJpbGl0aWVzOiBbNjBdIE1TSS1YOiBFbmFibGUtIE1hc2st
IFRhYlNpemU9MTAKCQlWZWN0b3IgdGFibGU6IEJBUj0zIG9mZnNldD0wMDAwMDAwMAoJCVBCQTog
QkFSPTMgb2Zmc2V0PTAwMDAyMDAwCglDYXBhYmlsaXRpZXM6IFthMF0gRXhwcmVzcyBFbmRwb2lu
dCBJUlEgMAoJCURldmljZTogU3VwcG9ydGVkOiBNYXhQYXlsb2FkIDI1NiBieXRlcywgUGhhbnRG
dW5jIDAsIEV4dFRhZy0KCQlEZXZpY2U6IExhdGVuY3kgTDBzIDw1MTJucywgTDEgPDY0dXMKCQlE
ZXZpY2U6IEF0bkJ0bi0gQXRuSW5kLSBQd3JJbmQtCgkJRGV2aWNlOiBFcnJvcnM6IENvcnJlY3Rh
YmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQlEZXZpY2U6IFJseGRPcmQrIEV4
dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3ArCgkJRGV2aWNlOiBNYXhQYXlsb2FkIDEy
OCBieXRlcywgTWF4UmVhZFJlcSA1MTIgYnl0ZXMKCQlMaW5rOiBTdXBwb3J0ZWQgU3BlZWQgMi41
R2IvcywgV2lkdGggeDQsIEFTUE0gTDBzIEwxLCBQb3J0IDEyCgkJTGluazogTGF0ZW5jeSBMMHMg
PDR1cywgTDEgPDY0dXMKCQlMaW5rOiBBU1BNIERpc2FibGVkIFJDQiA2NCBieXRlcyBDb21tQ2xr
LSBFeHRTeW5jaC0KCQlMaW5rOiBTcGVlZCAyLjVHYi9zLCBXaWR0aCB4NAoJQ2FwYWJpbGl0aWVz
OiBbMTAwXSBBZHZhbmNlZCBFcnJvciBSZXBvcnRpbmcKCUNhcGFiaWxpdGllczogWzE0MF0gRGV2
aWNlIFNlcmlhbCBOdW1iZXIgNmEtMDUtYzItZmYtZmYtNDgtMzAtMDAKCjA4OjAwLjEgRXRoZXJu
ZXQgY29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb246IFVua25vd24gZGV2aWNlIDEwYTcgKHJl
diAwMikKCVN1YnN5c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBVbmtub3duIGRldmlj
ZSAxMGE3CglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYt
IFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLQoJU3RhdHVzOiBDYXAr
IDY2TWh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9y
dC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplIDA4
CglJbnRlcnJ1cHQ6IHBpbiBCIHJvdXRlZCB0byBJUlEgMTA2CglSZWdpb24gMDogTWVtb3J5IGF0
IGRmMTgwMDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTEyOEtdCglSZWdpb24g
MTogTWVtb3J5IGF0IGRmMTYwMDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTEy
OEtdCglSZWdpb24gMjogSS9PIHBvcnRzIGF0IDIwMjAgW3NpemU9MzJdCglSZWdpb24gMzogTWVt
b3J5IGF0IGRmMTA0MDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTE2S10KCUNh
cGFiaWxpdGllczogWzQwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVD
bGstIERTSSsgRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQz
Y29sZCspCgkJU3RhdHVzOiBEMCBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTEgUE1FLQoJQ2Fw
YWJpbGl0aWVzOiBbNTBdIE1lc3NhZ2UgU2lnbmFsbGVkIEludGVycnVwdHM6IDY0Yml0KyBRdWV1
ZT0wLzAgRW5hYmxlKwoJCUFkZHJlc3M6IDAwMDAwMDAwZmVlMDQwMDAgIERhdGE6IDQwNmEKCUNh
cGFiaWxpdGllczogWzYwXSBNU0ktWDogRW5hYmxlLSBNYXNrLSBUYWJTaXplPTEwCgkJVmVjdG9y
IHRhYmxlOiBCQVI9MyBvZmZzZXQ9MDAwMDAwMDAKCQlQQkE6IEJBUj0zIG9mZnNldD0wMDAwMjAw
MAoJQ2FwYWJpbGl0aWVzOiBbYTBdIEV4cHJlc3MgRW5kcG9pbnQgSVJRIDAKCQlEZXZpY2U6IFN1
cHBvcnRlZDogTWF4UGF5bG9hZCAyNTYgYnl0ZXMsIFBoYW50RnVuYyAwLCBFeHRUYWctCgkJRGV2
aWNlOiBMYXRlbmN5IEwwcyA8NTEybnMsIEwxIDw2NHVzCgkJRGV2aWNlOiBBdG5CdG4tIEF0bklu
ZC0gUHdySW5kLQoJCURldmljZTogRXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRh
bC0gVW5zdXBwb3J0ZWQtCgkJRGV2aWNlOiBSbHhkT3JkKyBFeHRUYWctIFBoYW50RnVuYy0gQXV4
UHdyLSBOb1Nub29wKwoJCURldmljZTogTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEg
NTEyIGJ5dGVzCgkJTGluazogU3VwcG9ydGVkIFNwZWVkIDIuNUdiL3MsIFdpZHRoIHg0LCBBU1BN
IEwwcyBMMSwgUG9ydCAxMgoJCUxpbms6IExhdGVuY3kgTDBzIDw0dXMsIEwxIDw2NHVzCgkJTGlu
azogQVNQTSBEaXNhYmxlZCBSQ0IgNjQgYnl0ZXMgQ29tbUNsay0gRXh0U3luY2gtCgkJTGluazog
U3BlZWQgMi41R2IvcywgV2lkdGggeDQKCUNhcGFiaWxpdGllczogWzEwMF0gQWR2YW5jZWQgRXJy
b3IgUmVwb3J0aW5nCglDYXBhYmlsaXRpZXM6IFsxNDBdIERldmljZSBTZXJpYWwgTnVtYmVyIDZh
LTA1LWMyLWZmLWZmLTQ4LTMwLTAwCgowYTowMS4wIFZHQSBjb21wYXRpYmxlIGNvbnRyb2xsZXI6
IEFUSSBUZWNobm9sb2dpZXMgSW5jIEVTMTAwMCAocmV2IDAyKSAocHJvZy1pZiAwMCBbVkdBXSkK
CVN1YnN5c3RlbTogU3VwZXIgTWljcm8gQ29tcHV0ZXIgSW5jOiBVbmtub3duIGRldmljZSBhMjgw
CglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNu
b29wLSBQYXJFcnItIFN0ZXBwaW5nKyBTRVJSLSBGYXN0QjJCKwoJU3RhdHVzOiBDYXArIDY2TWh6
LSBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8
TUFib3J0LSA+U0VSUi0gPFBFUlItCglMYXRlbmN5OiA2NiAoMjAwMG5zIG1pbiksIENhY2hlIExp
bmUgU2l6ZSAwOAoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDc0CglSZWdpb24gMDog
TWVtb3J5IGF0IGQwMDAwMDAwICgzMi1iaXQsIHByZWZldGNoYWJsZSkgW3NpemU9MTI4TV0KCVJl
Z2lvbiAxOiBJL08gcG9ydHMgYXQgMzAwMCBbc2l6ZT0yNTZdCglSZWdpb24gMjogTWVtb3J5IGF0
IGRmMjAwMDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTY0S10KCUNhcGFiaWxp
dGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERT
SS0gRDErIEQyKyBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNob3QtLEQzY29sZC0p
CgkJU3RhdHVzOiBEMCBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoK
------=_Part_190837_14077581.1230714036281--
