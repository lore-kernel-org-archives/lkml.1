Return-Path: <linux-kernel-owner+w=401wt.eu-S1161781AbXDYRel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161781AbXDYRel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422740AbXDYRel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:34:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43423 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161781AbXDYRel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:34:41 -0400
Date: Wed, 25 Apr 2007 19:34:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425173405.GE17074@elf.ucw.cz>
References: <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425151825.GW3468@stusta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Even I am running in-kernel swsusp, but my managers were pretty clear
> > they want graphical progress bar hiding all the 'ugly' swsusp
> > messages... and in the end the same uswsusp enables compression, too.
> > 
> > > I absolutely detest all suspend-to-disk crap. Quite frankly, I hate the 
> > > whole thing. I think they've _all_ caused problems for the "true" suspend 
> > > (suspend-to-ram), and the last thing I want to see is three or four 
> > 
> > Well, it is a bit more complex than that.
> > 
> > suspend-to-disk is a workaround for
> > 
> > 	'suspend-to-ram eats too much power' (plus some details like
> > 	being able to replace battery).
> >...
> 
> Why does everyone think suspend-to-disk was a laptop-only thing?
> 
> My personal usage of suspend-to-disk is for turning the computer off in 
> the evening and getting the complete FVWM with all programs running, 
> open browser tabs,... back the next morning.

Ok ok ok, suspend-to-disk has some other uses, too.

But ... you are really using suspend-to-disk as a workaround for "my
desktop takes too much power when idle". Imagine pressing "lock
screensaver" combination, and your machine going to low power mode
(3W?), immediately. (Quiet, too; you can't generate much noise for
3W). In the morning, you'd just press any key, machine would power up,
immediately... ok, you'd have to ifconfig eth0 down, so that spurious
packets on the local net would wake your machine, with all its fans
etc.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
