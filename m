Return-Path: <linux-kernel-owner+w=401wt.eu-S968262AbXJSWEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968262AbXJSWEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934209AbXJSWEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:04:31 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:41904 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751AbXJSWE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:04:29 -0400
From: Nick Warne <nick@ukfsn.org>
Reply-To: nick@ukfsn.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Date: Fri, 19 Oct 2007 23:04:23 +0100
User-Agent: KMail/1.9.7
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200710181832.42906.nick@ukfsn.org> <200710192212.30533.nick@ukfsn.org> <200710192344.27312.bzolnier@gmail.com>
In-Reply-To: <200710192344.27312.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710192304.23749.nick@ukfsn.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 22:44:27 Bartlomiej Zolnierkiewicz wrote:
>
> Ah, so the patch won't help (sorry, I didn't pay enough attention).
>
> Len's advices are worth the try, also please send the output
> of hdparm -I /dev/hdd.
>
> Thanks,
> Bart

Yes, Len's advice has me wondering now.  Do I have a dodgy cable? I will have 
to change that tomorrow.

But more info.  The old drive played DVD movies etc. OK, but slowly it became 
worse until I couldn't read any one of them 9 times out of 10.  CD play 
back/burning was OK 100% all the time though - so I guessed the dvd laser 
(whatever it does) was dead - hence why I bought a new one. 

The new drive works perfectly, but for the udma33 issue.  If it was the cable, 
why would it read/burn CD OK, but not DVD sometimes on the old drive?

hdparm -I

/dev/hdd:

ATAPI CD-ROM, with removable media
        Model Number:       TSSTcorp CDDVDW SH-S202J
        Serial Number:
        Firmware Revision:  SB00
Standards:
        Supported: CD-ROM ATAPI-3 -4 -5 -6 -7
Configuration:
        DRQ response: 50us.
        Packet size: 12 bytes
Capabilities:
        LBA, IORDY(cannot be disabled)
        DMA: mdma0 mdma1 mdma2 udma0 udma1 *udma2 udma3 udma4
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=383ns  IORDY flow control=120ns

BTW, thanks for help all.

Nick
-- 
Free Software Foundation Associate Member 5508
