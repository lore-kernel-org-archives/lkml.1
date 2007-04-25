Return-Path: <linux-kernel-owner+w=401wt.eu-S2993133AbXDYXqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993133AbXDYXqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993140AbXDYXqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:46:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55851 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993133AbXDYXqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:46:12 -0400
Date: Thu, 26 Apr 2007 01:45:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425234549.GM17387@elf.ucw.cz>
References: <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org> <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org> <1177540027.5025.87.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org> <20070425231319.GK17387@elf.ucw.cz> <alpine.LFD.0.98.0704251621530.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251621530.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Current design is:
> 
> Broken. Yes. I've tried to tell you.

Ok.

...

> It's worse than just confusing, it's *idiotic*.
> 
> It _can_ work in practice, but
>  - we have pretty damn solid evidence that it doesn't work all that often 
>    in practice
>  - the fact that something *can* be done the stupid way is in no way an 
>    argument that it *should* be done the stupid way.
> 
> I claim that the current STD is *stupid*. Yes, it can work. But that 
> doesn't make it less stupid.

Good. So you understand how it works.

> What's your argument? Your argument seems to be that it's not stupid, 
> because it can work. Can't you see that that simply isn't an
> argument at 

I tried keeping module_init/thaw/resume similar code, so that driver
authors can debug suspend-to-disk, cross their fingers, and have
suspend-to-ram work, too.

Now, perhaps enough people do std/str these days so this is not
important any longer... lets hope so.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
