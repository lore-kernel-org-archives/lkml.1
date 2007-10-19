Return-Path: <linux-kernel-owner+w=401wt.eu-S967109AbXJSWNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967109AbXJSWNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966961AbXJSWM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:12:59 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35576 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966646AbXJSWM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:12:58 -0400
Date: Fri, 19 Oct 2007 18:12:57 -0400
To: Nick Warne <nick@ukfsn.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Message-ID: <20071019221257.GV4000@csclub.uwaterloo.ca>
References: <200710181832.42906.nick@ukfsn.org> <200710192212.30533.nick@ukfsn.org> <200710192344.27312.bzolnier@gmail.com> <200710192304.23749.nick@ukfsn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710192304.23749.nick@ukfsn.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 11:04:23PM +0100, Nick Warne wrote:
> Yes, Len's advice has me wondering now.  Do I have a dodgy cable? I will have 
> to change that tomorrow.
> 
> But more info.  The old drive played DVD movies etc. OK, but slowly it became 
> worse until I couldn't read any one of them 9 times out of 10.  CD play 
> back/burning was OK 100% all the time though - so I guessed the dvd laser 
> (whatever it does) was dead - hence why I bought a new one. 
> 
> The new drive works perfectly, but for the udma33 issue.  If it was the cable, 
> why would it read/burn CD OK, but not DVD sometimes on the old drive?

Well older DVD drives often only did udma33 so they would even care if
you had an 80 wire cable or not.  Newer once often require more than
udma33 for full operation.  I got a new drive about a year ago, and
burning dvd+rw at 4x worked great, but all dvd-r at 8x failed.
Eventually I realized I had to change the 40wire cable to an 80 wire,
and all problems disappeared.  The drive works fine in udma4 mode
(whatever speed that is).  My previous DVD-ROM drive had no problems
reading using a 40wire cable.

> hdparm -I
> 
> /dev/hdd:
> 
> ATAPI CD-ROM, with removable media
>         Model Number:       TSSTcorp CDDVDW SH-S202J
>         Serial Number:
>         Firmware Revision:  SB00
> Standards:
>         Supported: CD-ROM ATAPI-3 -4 -5 -6 -7
> Configuration:
>         DRQ response: 50us.
>         Packet size: 12 bytes
> Capabilities:
>         LBA, IORDY(cannot be disabled)
>         DMA: mdma0 mdma1 mdma2 udma0 udma1 *udma2 udma3 udma4
>              Cycle time: min=120ns recommended=120ns
>         PIO: pio0 pio1 pio2 pio3 pio4
>              Cycle time: no flow control=383ns  IORDY flow control=120ns
> 
> BTW, thanks for help all.

--
Len Sorensen
