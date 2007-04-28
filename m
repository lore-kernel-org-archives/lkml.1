Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbXD1LFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbXD1LFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbXD1LFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:05:20 -0400
Received: from aun.it.uu.se ([130.238.12.36]:60502 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbXD1LFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:05:18 -0400
Date: Sat, 28 Apr 2007 13:05:07 +0200 (MEST)
Message-Id: <200704281105.l3SB57ZY005672@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org, shemminger@linux-foundation.org
Subject: Re: sky2 regression in 2.6.21: Asus P5B-E Plus ethernet adapter no more supported
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 15:50:50 -0700, Stephen Hemminger wrote:
>On Thu, 26 Apr 2007 23:24:18 +0200
>Francois SIMOND <curio@free.fr> wrote:
>
>> Hello,
>> 
>> Lastest sky2 update between 2.6.21-rc7 and 2.6.21 final disables the support of the integrated ethernet adapter build on the Asus P5B-E Plus motherboard.
>
>
>But the same hardware dies horribly on Gigabyte GA-965P motherboards.
>Could you send me full lspci -vvx output. I'll re-enable it for Asus and add a block
>for the Gigabyte boards. (sigh)

Same thing on my ASUS P5B-E Plus. sky2 worked with 2.6.20/2.6.21-rc[1-7]
but 2.6.21 final killed it.

Regarding the alleged data corruption issues: I regularly do
multi-gigabyte data transfers over my lan to my P5B-E Plus,
followed by md5sum integrity checks, and I've never seen the
P5B-E Plus' sky2 cause any problems.

lspci -vvx -n:

02:00.0 Class 0200: 11ab:4364 (rev 12)
	Subsystem: 1043:81f8
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 08
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at ff8fc000 (64-bit, non-prefetchable) [size=16K]
	Region 2: I/O ports at a800 [size=256]
	Expansion ROM at ff8c0000 [disabled] [size=128K]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express Legacy Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
		Link: Latency L0s <256ns, L1 unlimited
		Link: ASPM Disabled RCB 128 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
00: ab 11 64 43 07 00 10 00 12 00 00 02 08 00 00 00
10: 04 c0 8f ff 00 00 00 00 01 a8 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 f8 81
30: 00 00 8c ff 48 00 00 00 00 00 00 00 0a 01 00 00

/Mikael
