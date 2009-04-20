Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZDTJ3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZDTJ3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZDTJ3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:29:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56730 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbZDTJ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=IOUMtX/UT0rfhOUal7inmvnP1VYHceHBGYr7WQEHaZ45enCX32EHbfNHiSEZ44PeAF
         1BuGoh3VDLILQLPKUaydxUzQRng7RUUFwLl8whO/McrQdVYt96e9XvhyN/iH7xFTIirK
         fOIiQQO326iWGAGp314eAumroEm3LrwcIOx9s=
Subject: SDHCI driver runnining in aspire one, allows to write to R/O SD
 cards
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: sdhci-devel@lists.ossman.eu
Cc: pierre@ossman.eu, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-qrwdei6XITsSeokX7rtv"
Date: Mon, 20 Apr 2009 12:29:24 +0300
Message-Id: <1240219764.13640.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qrwdei6XITsSeokX7rtv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

I am an owner of aspire one, and it has a card reader.
when I take a sd card, and pull down the protection tab, it still allows
to write to the card (I tested with my main notebook that indeed, it did
write there).

My main notebook, acer aspire 5720, doesn't have this problem.
Kernel version in use is 2.6.28 vanilla, but this did happen in former
version as well.


Attached lspci, on acer one.



--=-qrwdei6XITsSeokX7rtv
Content-Disposition: attachment; filename="tmpfile.txt"
Content-Type: text/plain; name="tmpfile.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

04:00.0 System peripheral [0880]: JMicron Technologies, Inc. SD/MMC Host Controller [197b:2382]
	Subsystem: Acer Incorporated [ALI] Device [1025:015b]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at 54100300 (32-bit, non-prefetchable) [size=256]
	[virtual] Expansion ROM at 53100000 [disabled] [size=32K]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: fffffffc  Data: 0000
	Kernel driver in use: sdhci-pci

04:00.2 SD Host controller [0805]: JMicron Technologies, Inc. Standard SD Host Controller [197b:2381] (prog-if 01)
	Subsystem: Acer Incorporated [ALI] Device [1025:015b]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at 54100200 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: fffffffc  Data: 0000

04:00.3 System peripheral [0880]: JMicron Technologies, Inc. MS Host Controller [197b:2383]
	Subsystem: Acer Incorporated [ALI] Device [1025:015b]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at 54100100 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: fffffffc  Data: 0000
	Kernel driver in use: jmb38x_ms
	Kernel modules: jmb38x_ms

04:00.4 System peripheral [0880]: JMicron Technologies, Inc. xD Host Controller [197b:2384]
	Subsystem: Acer Incorporated [ALI] Device [1025:015b]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 54100000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: fffffffc  Data: 0000



--=-qrwdei6XITsSeokX7rtv--

