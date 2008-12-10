Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYLJHy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYLJHy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 02:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbYLJHyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 02:54:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56672 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbYLJHys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 02:54:48 -0500
Date: Wed, 10 Dec 2008 08:56:25 +0100
From: Pavel Machek <pavel@suse.cz>
To: Michael Chan <mchan@broadcom.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Benjamin Li <benli@broadcom.com>
Subject: Re: bnx2: fs_sync_timeout, reset code = 1020002
Message-ID: <20081210075624.GC20166@elf.ucw.cz>
References: <20081204105550.GA2429@elf.ucw.cz> <1228411378.9156.52.camel@HP1> <20081208145442.GA23820@atrey.karlin.mff.cuni.cz> <1228756345.11235.2.camel@HP1>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
In-Reply-To: <1228756345.11235.2.camel@HP1>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


On Mon 2008-12-08 09:12:25, Michael Chan wrote:
> 
> On Mon, 2008-12-08 at 06:54 -0800, Pavel Machek wrote:
> > > 
> > > On Thu, 2008-12-04 at 02:55 -0800, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > I'm getting `subj` (with different numbers, 1020002, 1020004,
> > > > sometimes 102006). ifconfig eth0 up fails, network is completely
> > > > broken.
> > > 
> > > Which kernel are you using?  If it used to work before 2.6.26 or so,
> > > it
> > 
> > I'm using 2.6.28-rc7. I did not try any previous kernels.
> 
> Please provide ethtool -i eth0
> 
> and lspci -xxx on the Broadcom device.

Attached. It actually has eth0 & eth1, both seem to be same broadcom...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="toonie.1"

00:00.0 Host bridge: ATI Technologies Inc Unknown device 5a10
	Subsystem: ATI Technologies Inc Unknown device 1234
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: [f0] HyperTransport: MSI Mapping
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=20 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency 0: [b]
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [9c] HyperTransport: #1a
	Capabilities: [70] Message Signalled Interrupts: Mask- 64bit- Queue=0/2 Enable-
		Address: 00000000  Data: 0000
00: 02 10 10 5a 07 00 18 20 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 34 12
30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00
40: 08 54 00 c0 c1 00 00 00 00 00 00 00 42 20 05 00
50: 02 10 34 12 08 9c 00 90 08 10 00 00 00 00 00 00
60: 80 00 00 00 8e 01 00 00 00 02 00 40 60 48 00 78
70: 05 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 10 00 00 03 20 00 30 00 31 20 00 00
90: 00 00 00 c8 30 01 00 00 01 00 00 38 08 70 3c d0
a0: 26 00 00 00 00 00 00 83 00 00 00 00 f9 01 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 80 08 40 80 02 20 20 11 11 d0 00 00 00
d0: 60 0b f5 7f 13 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 05 00 ff ff ff ff 00 00 00 00 00 00 00 00
f0: 08 c4 03 a8 00 80 80 00 01 00 00 00 08 00 00 c8

00:04.0 PCI bridge: ATI Technologies Inc Unknown device 5a18 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: ca000000-cdffffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x4, ASPM L0s L1, Port 0
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed unknown, Width x4
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 4, PowerLimit 75.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [b0] Subsystem: ATI Technologies Inc Unknown device 1234
	Capabilities: [b8] HyperTransport: MSI Mapping
	Capabilities: [100] Unknown (11)
	Capabilities: [190] Unknown (13)
00: 02 10 18 5a 07 00 10 00 00 00 04 06 08 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 f1 01 00 20
20: 00 ca f0 cd f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 03 01 04 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 03 c8 00 00 00 00 10 a0 42 01 20 80 00 00
60: 10 08 00 00 42 0c 30 00 42 00 42 f0 80 25 24 00
70: 00 00 48 01 00 00 01 00 00 00 00 00 3f 00 00 00
80: 06 00 00 00 00 00 00 00 42 00 01 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 05 b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 0d b8 00 00 02 10 34 12 08 00 03 a8 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 50 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:11.0 SATA controller: ATI Technologies Inc Unknown device 4391 (prog-if 01 [AHCI 1.0])
	Subsystem: ATI Technologies Inc Unknown device 4391
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at 2430 [size=8]
	Region 1: I/O ports at 2424 [size=4]
	Region 2: I/O ports at 2428 [size=8]
	Region 3: I/O ports at 2420 [size=4]
	Region 4: I/O ports at 2400 [size=16]
	Region 5: Memory at c800c000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] #12 [0010]
00: 02 10 91 43 07 00 30 02 00 01 06 01 00 40 00 00
10: 31 24 00 00 25 24 00 00 29 24 00 00 21 24 00 00
20: 01 24 00 00 00 c0 00 c8 00 00 00 00 02 10 91 43
30: 00 00 00 00 60 00 00 00 00 00 00 00 0b 01 00 00
40: 10 00 00 00 01 00 10 00 80 bf 00 00 00 00 00 00
50: 05 70 84 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 50 22 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 12 00 10 00 0f 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 06 00 00 2c 16 80 b4 01 16 80 b4 01
90: 16 80 b4 01 16 80 b4 01 16 80 b4 01 16 80 b4 01
a0: 7a a0 7a a0 7a a0 7a a0 7a a0 7a a0 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 20 00 00
e0: 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:12.0 USB Controller: ATI Technologies Inc Unknown device 4397 (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc Unknown device 4397
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at c800d000 (32-bit, non-prefetchable) [size=4K]
00: 02 10 97 43 17 00 a0 02 00 10 03 0c 08 40 80 00
10: 00 d0 00 c8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 97 43
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 00 00
40: 80 03 00 00 11 00 00 00 00 00 00 00 00 00 00 00
50: 40 13 01 f0 00 00 00 00 ff ff ff ff 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 ff 00 00 80 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:12.1 USB Controller: ATI Technologies Inc Unknown device 4398 (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc Unknown device 4398
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at c800e000 (32-bit, non-prefetchable) [size=4K]
00: 02 10 98 43 17 00 a0 02 00 10 03 0c 08 40 00 00
10: 00 e0 00 c8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 98 43
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:12.2 USB Controller: ATI Technologies Inc Unknown device 4396 (prog-if 20 [EHCI])
	Subsystem: ATI Technologies Inc Unknown device 4396
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at c800c400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port
00: 02 10 96 43 17 00 b0 02 00 20 03 0c 10 40 00 00
10: 00 c4 00 c8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 96 43
30: 00 00 00 00 c0 00 00 00 00 00 00 00 07 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 40 00 9e 98 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 00 01 00 00 08 80 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 e4 02 7e 00 00 40 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 0a 00 e0 20 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.0 USB Controller: ATI Technologies Inc Unknown device 4397 (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc Unknown device 4397
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at c800f000 (32-bit, non-prefetchable) [size=4K]
00: 02 10 97 43 17 00 a0 02 00 10 03 0c 08 40 80 00
10: 00 f0 00 c8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 97 43
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 01 00 00
40: 80 1f 00 00 11 00 00 00 00 00 00 00 00 00 00 00
50: 40 13 01 f0 00 00 00 00 ff ff ff ff 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 ff 00 00 80 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.1 USB Controller: ATI Technologies Inc Unknown device 4398 (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc Unknown device 4398
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at c8010000 (32-bit, non-prefetchable) [size=4K]
00: 02 10 98 43 17 00 a0 02 00 10 03 0c 08 40 00 00
10: 00 00 01 c8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 98 43
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.2 USB Controller: ATI Technologies Inc Unknown device 4396 (prog-if 20 [EHCI])
	Subsystem: ATI Technologies Inc Unknown device 4396
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at c800c800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port
00: 02 10 96 43 17 00 b0 02 00 20 03 0c 10 40 00 00
10: 00 c8 00 c8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 96 43
30: 00 00 00 00 c0 00 00 00 00 00 00 00 04 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 40 00 9e 98 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 00 01 00 00 08 80 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 e4 02 7e 00 00 40 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 0a 00 e0 20 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.0 SMBus: ATI Technologies Inc SB600 SMBus (rev 3b)
	Subsystem: ATI Technologies Inc SB600 SMBus
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [b0] HyperTransport: MSI Mapping
00: 02 10 85 43 03 00 30 02 3b 00 05 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 85 43
30: 00 00 00 00 b0 00 00 00 00 00 00 00 00 00 00 00
40: 44 69 00 fc 00 00 00 00 0f ff 00 00 00 00 00 80
50: f0 01 f0 08 f0 03 f0 07 61 20 f0 0f 00 00 00 00
60: 01 00 24 20 bf fc 9e 03 ff 90 00 00 20 00 00 00
70: 00 00 00 00 08 00 c0 fe ff 6e 00 00 00 00 f0 07
80: 70 02 f0 0f 00 00 00 00 00 00 00 00 00 00 00 00
90: 41 20 00 00 f9 ce ff 00 00 00 00 00 00 00 00 00
a0: 00 00 ff ff 7f ff f0 09 00 ff 39 06 06 49 20 18
b0: 08 00 02 a8 00 00 d0 fe 00 00 00 00 f0 0f 08 1a
c0: ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 20 b9 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: d8 0c 00 00 7f 08 00 00 04 00 00 00 fe 3f 01 00

00:14.1 IDE interface: ATI Technologies Inc Unknown device 439c (prog-if 8a [Master SecP PriP])
	Subsystem: ATI Technologies Inc Unknown device 439c
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 2410 [size=16]
	Capabilities: [70] Message Signalled Interrupts: Mask- 64bit- Queue=0/1 Enable-
		Address: 00000000  Data: 0000
00: 02 10 9c 43 15 00 30 02 00 8a 01 01 00 40 00 00
10: f1 01 00 00 f5 03 00 00 71 01 00 00 75 03 00 00
20: 11 24 00 00 00 00 00 00 00 00 00 00 02 10 9c 43
30: 00 00 00 00 70 00 00 00 00 00 00 00 ff 01 00 00
40: 5d 5d 99 99 ff ff ff ff 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 40 26 10 2c 01 07 01 00 00 00 ff ff 0f 00
70: 05 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.3 ISA bridge: ATI Technologies Inc Unknown device 439d
	Subsystem: ATI Technologies Inc Unknown device 439d
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
00: 02 10 9d 43 0f 00 20 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 9d 43
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 04 00 00 00 d5 ff 03 ff 47 ff 60 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 a0 0c 00 00 0e 00 0f 00 f0 ff ff ff
70: 67 45 23 00 01 00 00 00 1d 00 00 00 05 0b 00 00
80: 08 00 03 a8 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 00
a0: 02 00 c1 fe 2f 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 e9 f2 ff 00 00
c0: 00 00 00 00 00 00 08 00 f7 ff ff fe 00 00 00 78
d0: 00 ff ff 00 00 00 00 ff ff ff ff 00 00 00 00 0c
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.4 PCI bridge: ATI Technologies Inc SB600 PCI to PCI Bridge (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: ce000000-ce0fffff
	Prefetchable memory behind bridge: d0000000-d7ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
00: 02 10 84 43 07 00 a0 02 00 01 04 06 00 40 81 00
10: 00 00 00 00 00 00 00 00 00 02 02 40 30 30 80 22
20: 00 ce 00 ce 00 d0 f0 d7 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08 00
40: 26 00 3c ff 00 00 00 00 0c 0f 3d d1 00 01 00 00
50: 01 00 00 00 08 00 03 a8 00 00 00 00 85 00 ff ff
60: ca 0e 17 00 ba d8 10 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 02 06
e0: 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.5 USB Controller: ATI Technologies Inc Unknown device 4399 (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc Unknown device 4399
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at c8011000 (32-bit, non-prefetchable) [size=4K]
00: 02 10 99 43 17 00 a0 02 00 10 03 0c 08 40 00 00
10: 00 10 01 c8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 99 43
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 03 00 00
40: 80 01 00 00 11 00 00 00 00 00 00 00 00 00 00 00
50: 40 13 1f f0 00 00 00 00 ff ff ff ff 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 ff 00 00 80 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.0 Host bridge: Advanced Micro Devices [AMD] Unknown device 1200
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [b]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-
	Capabilities: [a0] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [b]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-
	Capabilities: [c0] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [b]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-
00: 22 10 00 12 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 01 02 0c 00 02 04 04 00 01 02 04 00 01 02 04 00
50: 01 02 04 00 01 02 04 00 01 02 04 00 01 02 04 00
60: 10 00 07 00 e0 02 00 00 20 c8 4e 00 00 08 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 a0 01 21 20 20 11 11 60 0b f5 ff 13 00 00 00
90: 44 99 8a 04 00 00 00 00 03 00 00 00 00 00 00 00
a0: 08 c0 01 21 20 20 11 11 60 0b f5 ff 13 00 00 00
b0: 44 99 8a 04 00 00 00 00 03 00 00 00 00 00 00 00
c0: 08 00 01 21 20 20 11 11 60 0b f5 ff 13 00 00 00
d0: d1 01 84 82 00 00 00 00 07 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.1 Host bridge: Advanced Micro Devices [AMD] Unknown device 1201
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
00: 22 10 01 12 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 7f 00 03 00 80 00 01 00 37 01
50: 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00
60: 00 00 00 00 04 00 00 00 00 00 00 00 05 00 00 00
70: 00 00 00 00 06 00 00 00 00 00 00 00 07 00 00 00
80: 03 00 c8 00 20 0f ce 00 03 00 d0 00 20 ff d7 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 23 10 00 00 20 30 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 02 00 ff 00 00 00 00 00 00 00 00 00 00 00 00
f0: 02 00 00 c8 01 20 00 00 00 00 00 00 00 00 00 00

00:18.2 Host bridge: Advanced Micro Devices [AMD] Unknown device 1202
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
00: 22 10 02 12 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 60 3f 38 00 60 3f 38 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 06 00 48 13 00 00 00 00
80: 22 00 00 00 00 00 00 00 24 ca 69 cf 34 63 92 00
90: 10 01 08 00 0a 80 48 6f 2a 00 00 80 00 00 00 00
a0: 00 02 00 00 00 00 00 00 02 00 00 00 00 00 00 00
b0: 28 22 35 d4 97 00 00 00 9e ff 7e cf 00 08 de c7
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 7d 8e e5 ba f4 e9 f9 61 5d 5a 8a 59 cb 27 c3 cf
e0: ee 1f be db cd 71 ff c9 21 1b cf 48 68 66 c0 9f
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.3 Host bridge: Advanced Micro Devices [AMD] Unknown device 1203
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [f0] #0f [0010]
00: 22 10 03 12 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00
40: 00 01 00 00 5c 00 70 4a 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 04 00 7f 32 00 00 00 30 52 80 01 10
70: 54 11 14 10 01 01 18 00 14 0c 20 00 18 09 09 00
80: 81 e6 00 e6 e6 41 e6 01 08 00 00 00 00 40 40 00
90: 00 00 00 00 e3 32 00 00 10 57 94 c3 00 00 00 00
a0: 00 28 00 a0 80 18 8c 13 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 26 0f 31 c3 16 0e 00 03 38 63 47 01
e0: 00 00 00 00 30 1e 00 00 1f 7f f0 02 00 00 00 00
f0: 0f 00 10 00 00 00 00 00 00 00 00 00 41 0f 10 00

00:18.4 Host bridge: Advanced Micro Devices [AMD] Unknown device 1204
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
00: 22 10 04 12 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:19.0 Host bridge: Advanced Micro Devices [AMD] Unknown device 1200
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [b]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-
	Capabilities: [a0] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [b]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-
	Capabilities: [c0] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=N/C DwFcInEn- LWO=N/C DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: 200MHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-
00: 22 10 00 12 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 04 08 04 00 01 02 14 00 01 02 04 00 01 02 04 00
50: 01 02 04 00 01 02 04 00 01 02 04 00 01 02 04 00
60: 11 00 07 00 e0 00 00 00 20 c8 4e 00 04 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 a0 01 21 20 20 11 11 60 0b f5 ff 13 00 00 00
90: 44 99 8a 04 00 00 00 00 03 00 00 00 00 00 00 00
a0: 08 c0 01 21 20 20 11 11 60 0b f5 ff 13 00 00 00
b0: 44 99 8a 04 00 00 00 00 03 00 00 00 00 00 00 00
c0: 08 00 01 21 c0 20 00 77 60 00 f5 ff 13 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:19.1 Host bridge: Advanced Micro Devices [AMD] Unknown device 1201
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
00: 22 10 01 12 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 7f 00 03 00 80 00 01 00 37 01
50: 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00
60: 00 00 00 00 04 00 00 00 00 00 00 00 05 00 00 00
70: 00 00 00 00 06 00 00 00 00 00 00 00 07 00 00 00
80: 03 00 c8 00 20 0f ce 00 03 00 d0 00 20 ff d7 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 23 10 00 00 20 30 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 02 00 ff 00 00 00 00 00 00 00 00 00 00 00 00
f0: 03 b8 00 c8 01 20 00 00 00 00 00 00 00 00 00 00

00:19.2 Host bridge: Advanced Micro Devices [AMD] Unknown device 1202
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
00: 22 10 02 12 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 60 3f 38 00 60 3f 38 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 06 00 48 13 00 00 00 00
80: 22 00 00 00 00 00 00 00 24 ca 69 cf 34 63 92 00
90: 10 01 08 00 0a 80 48 6f 2a 00 00 80 00 00 00 00
a0: 00 02 00 00 00 00 00 00 02 00 00 00 00 00 00 00
b0: 8a dc 6a d4 97 00 00 00 54 3c 8c c7 93 88 e4 63
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 4b f8 65 27 11 b4 77 db b2 fd 5f b5 b6 d7 50 78
e0: d5 1b be bd 5d 62 ae 4f db 69 7c 55 19 17 c4 94
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:19.3 Host bridge: Advanced Micro Devices [AMD] Unknown device 1203
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [f0] #0f [0010]
00: 22 10 03 12 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00
40: 00 01 00 00 5c 00 70 4a 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80
60: 00 00 00 00 04 00 7f 32 00 00 00 30 52 80 01 00
70: 53 11 04 00 11 11 08 00 14 0c 20 00 14 09 09 00
80: 81 e6 00 e6 e6 41 e6 01 08 00 00 00 00 40 40 00
90: 00 00 00 00 0b 07 00 00 f0 cf 95 b2 00 00 00 00
a0: 00 28 00 a0 80 18 0c 11 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 26 0f 31 c3 16 0e 00 03 38 63 47 01
e0: 00 00 00 00 30 1e 00 00 1f 7f f0 02 00 00 00 00
f0: 0f 00 10 00 00 00 00 00 00 00 00 00 41 0f 10 00

00:19.4 Host bridge: Advanced Micro Devices [AMD] Unknown device 1204
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [c0] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=N/C DwFcInEn- LWO=N/C DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: 200MHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-
00: 22 10 04 12 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 08 00 01 21 c0 00 00 77 60 00 f5 ff 13 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:00.0 Ethernet controller: Broadcom Corporation Unknown device 1639
	Subsystem: Broadcom Corporation Unknown device 1639
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at ca000000 (64-bit, non-prefetchable) [size=32M]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [a0] MSI-X: Enable- Mask- TabSize=9
		Vector table: BAR=0 offset=0000c000
		PBA: BAR=0 offset=0000e000
	Capabilities: [ac] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <4us, L1 <64us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed unknown, Width x4, ASPM L0s L1, Port 0
		Link: Latency L0s <2us, L1 <2us
		Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed unknown, Width x4
	Capabilities: [100] Device Serial Number 00-00-00-00-00-00-00-00
	Capabilities: [110] Advanced Error Reporting
	Capabilities: [150] Power Budgeting
	Capabilities: [160] Virtual Channel
00: e4 14 39 16 06 00 10 00 00 00 00 02 08 00 80 00
10: 04 00 00 ca 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 e4 14 39 16
30: 00 00 00 00 48 00 00 00 00 00 00 00 03 01 00 00
40: 00 00 00 00 00 00 00 00 01 50 03 c8 08 20 00 00
50: 03 58 00 00 00 00 00 00 05 a0 86 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 88 00 00 92 01 00 00 00
70: 00 00 00 00 00 00 00 00 68 ff 16 00 00 00 00 00
80: 10 00 55 aa 00 00 04 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 11 ac 08 00 00 c0 00 00 00 e0 00 00 10 00 02 00
b0: 82 8d 2c 01 10 2c 19 00 42 dc 00 00 42 00 42 10
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:00.1 Ethernet controller: Broadcom Corporation Unknown device 1639
	Subsystem: Broadcom Corporation Unknown device 1639
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 45
	Region 0: Memory at cc000000 (64-bit, non-prefetchable) [size=32M]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [a0] MSI-X: Enable- Mask- TabSize=1
		Vector table: BAR=0 offset=00000000
		PBA: BAR=0 offset=00000000
	Capabilities: [ac] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <4us, L1 <64us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed unknown, Width x4, ASPM L0s L1, Port 0
		Link: Latency L0s <2us, L1 <2us
		Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed unknown, Width x4
	Capabilities: [100] Device Serial Number 00-00-00-00-00-00-00-00
	Capabilities: [110] Advanced Error Reporting
	Capabilities: [150] Power Budgeting
	Capabilities: [160] Virtual Channel
00: e4 14 39 16 06 00 10 00 00 00 00 02 08 00 80 00
10: 04 00 00 cc 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 e4 14 39 16
30: 00 00 00 00 48 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 01 50 03 c8 08 20 00 00
50: 03 58 00 00 00 00 00 00 05 a0 86 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 88 00 00 92 01 00 00 00
70: 00 00 00 00 00 00 00 00 68 fb 16 00 00 00 00 00
80: 10 00 55 aa 00 00 04 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 11 ac 00 00 00 00 00 00 00 00 00 00 10 00 02 00
b0: 82 8d 2c 01 10 2c 19 00 42 dc 00 00 42 00 42 10
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:06.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE] (prog-if 00 [VGA])
	Subsystem: ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 66 (2000ns min), Cache Line Size: 32 bytes
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at 3000 [size=256]
	Region 2: Memory at ce000000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at ce020000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 02 10 59 51 87 02 90 02 00 00 00 03 08 42 00 00
10: 08 00 00 d0 01 30 00 00 00 00 00 ce 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 59 51
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 08 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 59 51
50: 01 00 02 06 00 00 00 00 02 50 20 00 00 02 00 2f
60: 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="toonie.2"

driver: bnx2
version: 1.8.1
firmware-version: 4.4.14
bus-info: 0000:01:00.0

--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="toonie.3"

driver: bnx2
version: 1.8.1
firmware-version: 4.4.14
bus-info: 0000:01:00.1

--6zdv2QT/q3FMhpsV--
