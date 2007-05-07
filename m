Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbXEIM3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbXEIM3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbXEIM3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:29:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4224 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753152AbXEIM3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:29:31 -0400
Date: Mon, 7 May 2007 20:02:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hans-J?rgen Koch <hjk@linutronix.de>, Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
Message-ID: <20070507200245.GA3868@ucw.cz>
References: <20070427224957.GA17967@kroah.com> <4633A6D7.3030806@tmr.com> <200704282203.31141.hjk@linutronix.de> <20070428211515.4e9fd8c5@the-village.bc.nu> <1177792297.7646.297.camel@localhost.localdomain> <20070429012338.GA11147@suse.de> <1177835453.5791.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177835453.5791.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I agree, if we make it entirely clear that the flag is nonpolitical. 
> > 
> > Hm, I don't know, what makes this different from the fact that we can
> > mmap PCI device space today through the proc and sysfs entries?  That's
> > how X gets direct access to the hardware for a number of different
> > cards, and that's pretty much the same thing as the UIO interface is
> > doing.
> > 
> > Unless you think we should also use the same "taint" flag on those
> > accesses too, and if so, I have no objection.
> 
> Right, this is just a hint, that something in user space is accessing
> the hardware directly. Not a too bad idea, but pretty much useless when
> we add X to the picture as it will be set always :)

Some people -- like me -- use X68_fbcon over vesafb, in order not to
be tainted this way.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
