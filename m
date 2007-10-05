Return-Path: <linux-kernel-owner+w=401wt.eu-S1764288AbXJEViR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764288AbXJEViR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761322AbXJEViE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:38:04 -0400
Received: from client062.sevenl.net ([66.241.137.62]:3578 "EHLO pcburn.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754782AbXJEViB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:38:01 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2007 17:38:01 EDT
Message-ID: <4706AD19.4040605@pcburn.com>
Date: Fri, 05 Oct 2007 17:31:05 -0400
From: Chris Bergeron <chris@pcburn.com>
Reply-To: chris@pcburn.com
Organization: PCBurn Media
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Syba 8-Port Serial Card Unidentified By Kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I've just installed a multiport serial card released by an outfit called 
Syba.  This is an 8 port serial-only card with an Octopus style breakout 
cable.  The main chipset on it is an ITE IT8871F.

I've got two questions on this: Is there a driver I should try force 
loading on it (and if so, what options to use)?  and is there any useful 
testing I can do to report back to the LKML on this card?

Thanks for your time, diagnostic output follows.
-- Chris

The following comes up from an "lspci -vv"

01:06.0 Serial controller: PLX Technology, Inc. Unknown device 9016 (rev 
01) (prog-if 02 [16550])
        Subsystem: Unknown device 544e:0008
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at a000 [size=64]
        Region 1: I/O ports at a400 [size=16]
        Region 2: I/O ports at a800 [size=16]
        Region 3: Memory at f5000000 (32-bit, non-prefetchable) [size=4K]
        Region 4: Memory at f5001000 (32-bit, non-prefetchable) [size=4K]
        Region 5: Memory at f5002000 (32-bit, non-prefetchable) [size=4K]

and "lshw" outputs:

        *-communication UNCLAIMED
             description: Serial controller
             product: PLX Technology, Inc.
             vendor: PLX Technology, Inc.
             physical id: 6
             bus info: pci@0000:01:06.0
             version: 01
             width: 32 bits
             clock: 33MHz
             capabilities: 16550
             configuration: latency=0

