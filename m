Return-Path: <linux-kernel-owner+w=401wt.eu-S1423363AbXDYVqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423363AbXDYVqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422769AbXDYVqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:46:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35002 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423363AbXDYVqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:46:22 -0400
Date: Wed, 25 Apr 2007 23:46:01 +0200
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
Message-ID: <20070425214601.GH17387@elf.ucw.cz>
References: <20070419070437.GA25211@elte.hu> <alpine.LFD.0.98.0704251323000.9964@woody.linux-foundation.org> <20070425213049.GF17387@elf.ucw.cz> <200704252340.20378.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704252340.20378.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > And no, "three different implementations" doesn't cut it. Even _two_ is 
> > > too much. We need to get *rid* of something, not add more.
> > 
> > swsusp can be dropped. It is nice -- self contained, extremely easy to
> > setup, Andrew likes it. uswsusp has all the features, and pretty
> > elegant design. With klibc (or some way to ship userland code with
> > kernel, and put it into initramfs or something) we can reasonably drop
> > swsusp.
> 
> Well, I think we still need it and will need it in the future, at least for
> debugging.  Moreover, I think there are many users of it.
> 
> Let's not drop things that are helping us. :-)

Yes, it is very nice for debugging. But if I _had_ to choose, I'd
rather remove swsusp than uswsusp.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
