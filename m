Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbXGINw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbXGINw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbXGINwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:52:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48535 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751578AbXGINwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:52:20 -0400
Date: Mon, 9 Jul 2007 15:52:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
Message-ID: <20070709135205.GB3216@elf.ucw.cz>
References: <200707081737.21932.a1426z@gawab.com> <87tzsew712.fsf@jbms.ath.cx> <4691B9A5.6060203@yahoo.com.au> <4691BC0F.8050909@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4691BC0F.8050909@yahoo.com.au>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>from a *new* kernel space/user space that is created by loading a new
> >>kernel in a manner similar to what is done for kexec crashdumps.  Unlike
> >>kexec crashdumps, however, it would not require reserving any memory at
> >>boot, because the necessary memory (maybe 16MB or 64MB) can be freed
> >>just before hibernating, and device drivers can be properly stopped so
> >>that DMAs don't stomp over certain memory.
> >
> >
> >This is the Morton method, isn't it? :) I remember it sounding like a
> >very good idea when he brought it up, but I can't remember the details
> >of why it was rejected or what the problems were.
> 
> Hmm, and it seems like I won't get to know without reliving what
> looks like an epic flamewar starting.... here:
> 
>   http://thread.gmane.org/gmane.linux.kernel/374889
> 
> However from a quick look it seems like the only reason is the RAM
> overhead of a reserve area. It seems unfortunate that it was
> dismissed so quickly because of that problem (which could be
> improved).

Well, the kexec thingy should be able to hibernate a machine, but it
will not be "software-suspend" any more, and it may be quite a lot of
work to get it going.

In the end, you'll get rid of freezer problems, but will have two
kernels to care about, and certainly more conventional design. I do
not think I have time to try that (and don't think freezer problems
are _that_ bad in the first place), but some interested soul could
certainly try it.

If we deprecate swsusp in 2.6.45 or so, I do not think I'll be crying.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
