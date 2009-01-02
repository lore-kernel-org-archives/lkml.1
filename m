Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbZACULR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbZACULR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932111AbZACUKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:10:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50292 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302AbZACUKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:10:46 -0500
Date: Fri, 2 Jan 2009 18:24:13 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andreas Mohr <andi@lisas.de>
Cc: Sriram V <vshrirama@gmail.com>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
Message-ID: <20090102172407.GD1555@ucw.cz>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com> <20090102102152.GA26603@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102102152.GA26603@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >   I am using linux-2.6.27.  I am testing power management after
> > booting out of a SD/MMC card.
> >   My root file system is on a SD card.
> > 
> >   I am issuing the following command to suspend
> > 
> >       $ echo -n mem > /sys/power/state
> >  What happens is, The kernel hangs and it does not come out of suspend.
> >  even after i press keypad/generate serial input data.
> 
> 
> > Has anyone tried this before?
> > 
> > Am i missing something here?
> 
> I don't think you're missing much, and you're definitely not alone.
> 
> There have been long threads on mobile phone and netbook related forums about issues
> with seemingly "any slightly advanced use whatsoever" of partitions on SD cards.
> 
> IMHO in this strongly increasingly netbook- and mobile phone-enabled world it's
> a bloody shame that:
...
> - installing a swap partition on an SD card and then resuming can easily
>   go as far as __even completely corrupting__ the entire SD card partitioning
>   plus first partition (corrupts first 1kB of the card: both table and partition)
>   People then immediately resort to a non-helpful "Don't Do This, Ever" reply
>   (using swap partition on SD and suspend, see http://dev.laptop.org/ticket/6532#comment:10),
>   but to this I'd say:
>   News Flash, if this can theoretically be made to work at all using software
>   (i.e. there are no VM-related _hard_ blockers to such an operation
>   of using swap itself on a non-fixed SD slot), then this should goddamn be made
>   to work practically on Linux, _somehow_, since on SSD netbooks this is
>   the most natural thing to do to avoid wear of the builtin device.

I'd like to help with this one... can you reproduce this?


> (or, slightly reworded: I think it's high time for some kernel God to buy a measly
> netbook or some such instead of 16-core mainframes to get a feeling for the
> amount of issues that one hits there)

I have one and yes, its full of problems; see my blog post about 'evil
little cards'.

OTOH currently you can't safely use ext3 on flash card, so suspend
problems seem little 'uninteresting' compared to that.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
