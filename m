Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbXD1HBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbXD1HBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXD1HBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:01:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57970 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751366AbXD1HBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:01:05 -0400
Date: Sat, 28 Apr 2007 09:00:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: progress meter in s2disk (was Re: Back to the future.)
Message-ID: <20070428070039.GG2994@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704271801020.9964@woody.linux-foundation.org> <200704280344.49674.rjw@sisk.pl> <200704272251.57407.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704272251.57407.dhazelton@enter.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > It's doubly bad, because that idiocy has also infected s2ram. Again,
> > > > > another thing that really makes no sense at all - and we do it not
> > > > > just for snapshotting, but for s2ram too. Can you tell me *why*?
> > > >
> > > > Why we freeze tasks at all or why we freeze kernel threads?
> > >
> > > In many ways, "at all".
> > >
> > > I _do_ realize the IO request queue issues, and that we cannot actually
> > > do s2ram with some devices in the middle of a DMA. So we want to be able
> > > to avoid *that*, there's no question about that. And I suspect that
> > > stopping user threads and then waiting for a sync is practically one of
> > > the easier ways to do so.
> > >
> <snip>
> 
> Apparently I *CANNOT* wrap my head around this - if just because my laptop, 
> running a vendor 2.6.17 kernel does s2ram perfectly, at least, it does when 
> using the "Upstart" init system rather than the classical SysV init system. I 
> have tried it with the classical init and the suspend isn't triggered by the 
> buttons that used to do it. I didn't try 'echo ram > /sys/power/state', but I 
> have a feeling that would have worked as well. I have problems with s2disk, 
> but thats because I keep my swap partition small - I try to keep it at or 
> around 256M when I have more than half a gig of Ram in a system. Perhaps one 
> of these days I'll grab a multi-gig flash disk, set it up as a swap partition 
> and try it again. (every time I've tried s2disk I wind up running out of disk 
> space - and this is with nothing but X running. Any kind of progress meter 
> for when the system is doing s2disk would be nice - every time I've tried it 
> all I see for the nearly 2 minutes before the s2disk attempt ends is a black 
> screen. I say 2 minutes because thats how long it takes for it to learn that 
> there isn't enough space on the swap-partition to save the image)

Just turn up console loglevel to see the messages.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
