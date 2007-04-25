Return-Path: <linux-kernel-owner+w=401wt.eu-S2993102AbXDYUcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993102AbXDYUcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993106AbXDYUcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:32:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54207 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993102AbXDYUcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:32:16 -0400
Date: Wed, 25 Apr 2007 22:31:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425203150.GD17387@elf.ucw.cz>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org> <20070425200836.GB17387@elf.ucw.cz> <200704252233.25296.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704252233.25296.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > .. but if the alternative is a feature that just isn't worth it, and 
> > > > > likely to not only have its own bugs, but cause bugs elsewhere? (And yes, 
> > > > > I believe STD is both of those. There's a reason it's called "STD". Go 
> > > > > to google and type "STD" and press "I'm feeling lucky". Google is God).
> > > > 
> > > > Is there really no use case for STD?
> 
> [--snip--]
> > > So my objections to STD have nothing to do with saving state and shutting 
> > > down. They have everything to do with the fact that it is not - and will 
> > > never be - a "suspend", and it shouldn't affect suspend.
> > 
> > STD needs to snapshot system, and then it needs devices to be
> > suspended so that snapshot is consistent.
> 
> Not suspended.  _Frozen_.  In fact don't want any DMA transfers or interrupts
> to take place when we're creating the image.  That's all and that's what we're
> doing (or rather, trying to do).

Yep, _frozen_. That's the right word.

> So, the "suspend" and "resume" for the functions being called for that are
> wrong, but then we call them with PMSG_FREEZE. ;-)  Still, we could add
> .freeze() and .thaw() callbacks for hibernation just fine.  This wouldn't even
> be that difficult ...

It would be ugly big patch I'm afraid.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
