Return-Path: <linux-kernel-owner+w=401wt.eu-S1423090AbXDXVZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423090AbXDXVZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423097AbXDXVZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:25:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34507 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423090AbXDXVZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:25:24 -0400
Date: Tue, 24 Apr 2007 23:24:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070424212408.GD16457@elf.ucw.cz>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Well, current uswsusp code can do most of stuff suspend2 can do, with
> > 20% (or so) of kernel code. 
> 
> Btw, this is a totally inane argument.
> 
> If the code just moved somewhere else, it's not "less code".

It is not "just moved". It is in userspace, where we can use liblzf /
gcrypt / ( and vbetool for s2ram/s2both) as libraries. We have about
7000 LoC of userland code (that is not libraries).

> You compare complete subsystems against complete subsystems, OR YOU DON'T 
> COMPARE THEM AT ALL!

Ok, I do not know how big suspend2 user code is, but kernel uswsusp
(4 kLoC) + userland support (7 kLoC) is still smaller than suspend2
kernel code (+ ? kLoC suspend2 userland support).

> This whole notion that "kernel lines of code" is somehow different is a 
> stupid and idiotic _disease_ that is spread by microkernel people and 
> people who have been brainwashed by them.

Yep, sorry about that.

> Separation of code often makes things *harder* to understand and debug. A 
> few prime examples of this f*cking idiotic stupid disease of discounting 
> user level code because it somehow "doesn't matter" is:

I believe uswsusp user/kernel separation is clean enough. Kernel
provides "snapshot image" and "resume image". (Thanks go to Rafael for
very clean interface).

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
