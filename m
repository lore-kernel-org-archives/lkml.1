Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbXEYJkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbXEYJkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXEYJkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:40:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37157 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750941AbXEYJkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:40:40 -0400
Date: Fri, 25 May 2007 11:40:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Need suspend-to-ram maintainer Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Message-ID: <20070525094016.GJ9604@elf.ucw.cz>
References: <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org> <20070524221743.GD9604@elf.ucw.cz> <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org> <20070524231852.GG9604@elf.ucw.cz> <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org> <1180058123.3997.91.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org> <1180059605.3997.100.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > To answer the question, I guess the answer is that although they're
> > different creatures, they have similarities. This is one of them, which
> > is why I could make the mistake I did. Nothing in the issue being
> > discussed was unique to suspend-to-ram. Perhaps we (or at least I) focus
> > too much on the similarities, but that doesn't mean they're not there.
> 
> I agree that the current bug is not unique to STR. In fact, I think Romano 
> tested both STD and STR, and both had the same bug with the 60s timeout.
> 
> But what irritates me is that STR really shouldn't have _had_ that bug at 
> all. The only reason STR had the same bug as STD was exactly the fact that 
> the two features are too closely inter-twined in the kernel. 

And what do you expect? We have three people working on
hibernation, and suspend-to-ram was created as "oh, if we do this,
this, and this, we get get suspend-to-ram with existing code".

> I agree that disk snapshotting is much harder. If we had a bug just in 
> that part, I wouldn't mind it so much. Getting hard problems wrong isn't 
> something you should be ashamed of. What I mind is that the _easier_ 
> problem got infected by all the bugs from the _harder_ issue. That just 
> makes me really really angry and frustrated.
> 
> Look at it this way: if you designed a CPU, and you made the integer 
> code-path share everything with the floating point side, because "addition 
> is addition", and as a result the latency for the simple arithmetic and 
> logical ops in integer ALU was four cycles, what would you be?

You'd be seriously overstaffed in FPU side, and seriously understaffed
on ALU side.

This is basically what happened here. I tell people to get hibernation
to work _first_ because it is usually easier.

And what does that mean? We need three people to work on
suspend-to-RAM. Heck, we need at least _one_ person to work on
suspend-to-RAM, but he needs to be listed in MAINTAINERS.

With hibernation people trying to maintain suspend in their spare
cycles, how do you expect suspend to work? Similar to hibernation,
that's how it looks today.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
