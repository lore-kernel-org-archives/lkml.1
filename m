Return-Path: <linux-kernel-owner+w=401wt.eu-S2993060AbXDYVbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993060AbXDYVbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbXDYVbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:31:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37376 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754247AbXDYVbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:31:23 -0400
Date: Wed, 25 Apr 2007 23:30:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Adrian Bunk <bunk@stusta.de>,
       Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425213049.GF17387@elf.ucw.cz>
References: <20070419070437.GA25211@elte.hu> <20070425192512.GZ3468@stusta.de> <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org> <200704252220.57792.rjw@sisk.pl> <alpine.LFD.0.98.0704251323000.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251323000.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Please ask anyone who's worked with me if he's had any problem with that.
> > If anyone say I'm unable to work with anybody else, I'd say you're right.  Till
> > then, I feel offended.
> 
> I'll apologise (and virtually kiss your hairy feet) if you could actually 
> show me a single implementation that people can agree on.
> 
> But until then, I claim that the suspend-to-disk people cannot work with 
> each other.

It is not Rafael's fault. Actually it is quite hard to work with
Nigel, because he implements every feature someone asks for, and wants
to merge them all :-(. I don't expect to ever agree with Nigel on
anything important, sorry.

> And no, "three different implementations" doesn't cut it. Even _two_ is 
> too much. We need to get *rid* of something, not add more.

swsusp can be dropped. It is nice -- self contained, extremely easy to
setup, Andrew likes it. uswsusp has all the features, and pretty
elegant design. With klibc (or some way to ship userland code with
kernel, and put it into initramfs or something) we can reasonably drop
swsusp.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
