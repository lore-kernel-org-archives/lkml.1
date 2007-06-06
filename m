Return-Path: <linux-kernel-owner+w=401wt.eu-S936306AbXFFVe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936306AbXFFVe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935187AbXFFVeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:34:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1390 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936167AbXFFVeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:34:03 -0400
Date: Wed, 6 Jun 2007 21:26:06 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Rene Herman <rene.herman@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-ID: <20070606212605.GA6711@ucw.cz>
References: <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com> <46646747.2080803@cs.helsinki.fi> <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com> <20070604155355.bf29a3a8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com> <466523E0.3050605@gmail.com> <alpine.DEB.0.99.0706050804170.27388@sigma.j-a-k-j.com> <46655CEC.7070900@gmail.com> <466575EE.70901@goop.org> <46657988.6060901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46657988.6060901@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>No, what we have is a sizeof(pointer) sized pointer 
> >>pointing to an
> >>object of size zero. ZERO_SIZE_PTR is butt-ugly. With 
> >>a really ugly butt. 
> >
> >It doesn't matter.  It will never, ever, be used by 
> >anything except the
> >kmalloc internals.  No client code should ever use the 
> >constant for
> >anything.
> 
> Yes, I'm aware of this (I should snip less) but I still 
> feel it's not a good name. When I read say "a 64-bit 
> pointer" I immediately take that to mean a pointer of 
> size 64-bit, not a pointer to 64-bits and only it not 
> making any sense would stop me from interpreting 
> "ZERO_SIZE_PTR" similarly.
> 
> Yes, it's internal but given that this is open-source 
> which, optimistically, is read many more times than it's 
> written one should still strive for code that reads nice 
> as far as I'm concerned. It's obviously also not hugely 
> important but it's just that ZERO_SIZE_PTR makes my neck 
> hair stand up.

PTR_TO_NOTHING? 
PTR_TO_0BYTES?
PTR_TO_0SIZE?
PTR_TO_ZERO_SIZE?
NOT_QUITE_NULL? :-)
FULL? 
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
