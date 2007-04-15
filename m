Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbXDOVDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbXDOVDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 17:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbXDOVDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 17:03:32 -0400
Received: from mail.cavein.org ([66.245.249.51]:43667 "EHLO mail.cavein.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbXDOVDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 17:03:31 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Apr 2007 17:03:31 EDT
Date: Sun, 15 Apr 2007 13:54:49 -0700 (PDT)
From: Richard A Nelson <cowboy@cavein.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc6, ASUS M2V 1.01G, ALSA detection/non-support
Message-ID: <alpine.DEB.0.98.0704151341250.12045@hygvzn-guhyr.pnirva.bet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


My son has an earlier version of the M2V & BIOS (0901) and his gets full 6ch
sound.

The 1.01G, and related BIOS (1304 or 1701) do not properly handle the
onboard sound:
hda_codec: Unknown model for ALC660VD/ALC861VD, trying auto-probe from BIOS...

it seems to truely be a BIOS issue, as I don't see a difference in lspci
-vvxxx between our systems:

80:01.0 Audio device: VIA Technologies, Inc. VIA High Definition Audio
Controller (rev 10)
         Subsystem: ASUSTeK Computer Inc. Unknown device 81e7
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step ping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 17
         Region 0: Memory at fbffc000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3ho t+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [70] Express Unknown type IRQ 0
                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                 Device: Latency L0s <64ns, L1 <1us
                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                 Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
                 Link: Latency L0s <64ns, L1 <1us
                 Link: ASPM Disabled CommClk- ExtSynch-
                 Link: Speed unknown, Width x0
00: 06 11 88 32 06 00 10 00 10 00 03 04 10 00 00 00
10: 04 c0 ff fb 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 e7 81
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00
40: 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 60 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 70 80 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 10 00 91 00 00 00 00 00 00 00 30 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

ALSA, instead of seeing ALC660, on my box sees ALC660-VD, with very
little in the way of devices (only front output) - which does not work
either :(

Stumped on where to go from here...
-- 
Rick Nelson
Life'll kill ya                         -- Warren Zevon
Then you'll be dead                     -- Life'll kill ya
