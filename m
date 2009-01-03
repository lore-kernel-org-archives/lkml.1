Return-Path: <linux-kernel-owner+w=401wt.eu-S932763AbZACXKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbZACXKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760076AbZACXKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:10:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41118 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759805AbZACXKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:10:09 -0500
Date: Sat, 3 Jan 2009 23:10:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@suse.cz>, Andreas Mohr <andi@lisas.de>,
       Sriram V <vshrirama@gmail.com>, Pierre Ossman <drzeus-list@drzeus.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
Message-ID: <20090103231013.3591d027@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0901031306150.3179@localhost.localdomain>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com>
	<20090102102152.GA26603@rhlx01.hs-esslingen.de>
	<20090102172407.GD1555@ucw.cz>
	<alpine.LFD.2.00.0901031217261.3179@localhost.localdomain>
	<20090103204329.GD1666@elf.ucw.cz>
	<20090103204535.1a91cbcb@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0901031306150.3179@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, it goes both ways. You can make a nasty mess right now by suspending 
> and simply not having a working computer when it comes back - all your 
> work being lost.

Yes but these are both symptoms of the same problem.

> they actually get things right is pretty low, though. So I suspect we'd be 
> much better off having sane defaults in the kernel instead.

I don't believe "auto-destroy my music collection" is a sane default...

> So it boils down to the fact that if you have something like / or /home 
> mounted, we really _cannot_ do any better than "assume the user doesn't 
> screw us up".
> 
> A per-filesystem callback to re-verify at resume might be a good idea, but 
> a lot of filesystems cannot reasonably do a lot of verification.

A per file system sync and quiesce is I think also part of the
requirement. Having the file system media consistent but still mounted
before suspending is a good thing anyway (especially with stuff like USB
keys that people do then go and remove post suspend) and you can put the
device into a consistent state and revalidate it *regardless* of the
whether it is / or a music player. What you do if revalidating / fails is
another question ;)

Alan
