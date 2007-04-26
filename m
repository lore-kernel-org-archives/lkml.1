Return-Path: <linux-kernel-owner+w=401wt.eu-S1031182AbXDZMlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031182AbXDZMlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031183AbXDZMlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:41:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4679 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031182AbXDZMlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:41:16 -0400
Date: Thu, 26 Apr 2007 12:41:03 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426124102.GA8030@ucw.cz>
References: <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg> <20070426113525.GA1332@infradead.org> <20070426121544.GA11487@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426121544.GA11487@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The interface isn't even 64/32-bit compatible...
> > 
> > It's not .  And it's one of the worst interface I've seen lately. Did 
> > anyone actually review this crap before it went in?  I completely 
> > agree with Linus that these kind of boundaries that lead to horribly 
> > complex ioctl interface are totally wrong.
> 
> it's a bit hard to see the point of it anyway: the resume binary (much 
> of the focus of the ioctls) fundamentally lives as an 'initrd binary' - 
> and most of the stuff that wants to execute in an initrd is 
> fundamentally tied to the kernel anyway.

Typically... yes, it needs to be in initrd.

And yes, klibc would help here.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
