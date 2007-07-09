Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbXGINpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbXGINpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXGINpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:45:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43383 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751315AbXGINpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:45:24 -0400
Date: Mon, 9 Jul 2007 15:45:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
Message-ID: <20070709134522.GA3216@elf.ucw.cz>
References: <200707081737.21932.a1426z@gawab.com> <87tzsew712.fsf@jbms.ath.cx> <4691B9A5.6060203@yahoo.com.au> <87k5taw5vc.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5taw5vc.fsf@jbms.ath.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> This approach eliminates the need for the freezer, as it would make
> >> hibernate look a lot a bit like suspend to ram from the perspective of
> >> the "old" kernel (the kernel being hibernated), as the hibernate
> >> operation itself would be completely atomic from the perspective of the
> >> "old" kernel.  That is not to say, of course, that any code paths would
> >> actually be shared, or that the drivers would do the same things
> >> (because they probably would not).
> 
> > Well it basically is suspend to RAM with the additional step that a
> > new kernel gets booted and writes out the data from RAM to disk then
> > shuts down.
> 
> There is the key difference, though, that the drivers should do rather
> different things.  In particular, rather than place the hardware in a
> low-power mode, it should place it in some state such that the new
> kernel being loaded can handle it.

Actually, when current kernel restores the snapshot... driver
requirements seem to be pretty similar. So that should not be a big
problem.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
