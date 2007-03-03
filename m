Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbXCCLKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbXCCLKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 06:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbXCCLKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 06:10:51 -0500
Received: from vsmtp2.tin.it ([212.216.176.222]:45602 "EHLO vsmtp2.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbXCCLKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 06:10:50 -0500
Subject: Re: Problem with libata-pata, ATAPI DVD reader and a
	"copy-protected" audio cd
From: GhePeU <ghepeu@virgilio.it>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1172919624.23576.31.camel@KazeNoTani>
References: <1172919624.23576.31.camel@KazeNoTani>
Content-Type: text/plain
Date: Sat, 03 Mar 2007 12:10:25 +0100
Message-Id: <1172920248.23576.35.camel@KazeNoTani>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno sab, 03/03/2007 alle 12.00 +0100, GhePeU ha scritto:
> Hello,
> 
> when kernel 2.6.20 was released I switched to the new libata-pata
> infrastructure for my EIDE hard disk and ATAPI dvd-reader. 
> 
> ...
>
> Thank you in advance
> 
> Giacomo
> 
> PS. I'm not subscribed to the list. I'm going to regularly check the
> archives in the next days to see if there are responses, CC me if you
> can. Thank you.
> 

I forgot the lspci -vv output:

00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2) (prog-if 8a
[Master SecP PriP])
        Subsystem: Unknown device f47b:1c28
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at e800 [size=16]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller
(rev f3) (prog-if 85 [Master SecO PriO])
        Subsystem: ABIT Computer Corp. Unknown device 1c28
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 09f0 [size=8]
        Region 1: I/O ports at 0bf0 [size=4]
        Region 2: I/O ports at 0970 [size=8]
        Region 3: I/O ports at 0b70 [size=4]
        Region 4: I/O ports at d400 [size=16]
        Region 5: Memory at fe02c000 (32-bit, non-prefetchable)
[size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller
(rev f3) (prog-if 85 [Master SecO PriO])
        Subsystem: ABIT Computer Corp. Unknown device 1c28
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: I/O ports at 09e0 [size=8]
        Region 1: I/O ports at 0be0 [size=4]
        Region 2: I/O ports at 0960 [size=8]
        Region 3: I/O ports at 0b60 [size=4]
        Region 4: I/O ports at c000 [size=16]
        Region 5: Memory at fe02b000 (32-bit, non-prefetchable)
[size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


