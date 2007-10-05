Return-Path: <linux-kernel-owner+w=401wt.eu-S1764711AbXJEWo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764711AbXJEWo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 18:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762556AbXJEWot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 18:44:49 -0400
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:39610 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762132AbXJEWos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 18:44:48 -0400
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
From: Nicholas Miell <nmiell@comcast.net>
To: chris@pcburn.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4706AD19.4040605@pcburn.com>
References: <4706AD19.4040605@pcburn.com>
Content-Type: text/plain
Date: Fri, 05 Oct 2007 15:43:50 -0700
Message-Id: <1191624230.2695.15.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-05 at 17:31 -0400, Chris Bergeron wrote:
> Hello all,
> 
> I've just installed a multiport serial card released by an outfit called 
> Syba.  This is an 8 port serial-only card with an Octopus style breakout 
> cable.  The main chipset on it is an ITE IT8871F.
> 
> I've got two questions on this: Is there a driver I should try force 
> loading on it (and if so, what options to use)?  and is there any useful 
> testing I can do to report back to the LKML on this card?
> 
> Thanks for your time, diagnostic output follows.
> -- Chris
> 
> The following comes up from an "lspci -vv"
> 
> 01:06.0 Serial controller: PLX Technology, Inc. Unknown device 9016 (rev 
> 01) (prog-if 02 [16550])
>         Subsystem: Unknown device 544e:0008
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin A routed to IRQ 16
>         Region 0: I/O ports at a000 [size=64]
>         Region 1: I/O ports at a400 [size=16]
>         Region 2: I/O ports at a800 [size=16]
>         Region 3: Memory at f5000000 (32-bit, non-prefetchable) [size=4K]
>         Region 4: Memory at f5001000 (32-bit, non-prefetchable) [size=4K]
>         Region 5: Memory at f5002000 (32-bit, non-prefetchable) [size=4K]

Try echo -n "10b5 9016" > /sys/bus/pci/drivers/serial/new_id and let
Russell King (rmk+serial@arm.linux.org.uk) know if it works (or if it
doesn't, for that matter).

-- 
Nicholas Miell <nmiell@comcast.net>

