Return-Path: <linux-kernel-owner+w=401wt.eu-S1751235AbXBNUro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbXBNUro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXBNUrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:47:43 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52715 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751235AbXBNUrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:47:42 -0500
Date: Wed, 14 Feb 2007 21:45:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: malc <av1474@comtv.ru>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: CPU load
Message-ID: <20070214204515.GA26153@elf.ucw.cz>
References: <loom.20070212T063225-663@post.gmane.org> <20070212143219.GB5226@ucw.cz> <Pine.LNX.4.64.0702140059390.727@home.oyster.ru> <200702140908.44934.kernel@kolivas.org> <Pine.LNX.4.64.0702141023000.672@home.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702141023000.672@home.oyster.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> 
> >>>I have (had?) code that 'exploits' this. I believe I could eat 90% of cpu
> >>>without being noticed.
> >>
> >>Slightly changed version of hog(around 3 lines in total changed) does that
> >>easily on 2.6.18.3 on PPC.
> >>
> >>http://www.boblycat.org/~malc/apc/load-hog-ppc.png
> >
> >I guess it's worth mentioning this is _only_ about displaying the cpu 
> >usage to
> >userspace, as the cpu scheduler knows the accounting of each task in
> >different ways. This behaviour can not be used to exploit the cpu scheduler
> >into a starvation situation. Using the discrete per process accounting to
> >accumulate the displayed values to userspace would fix this problem, but
> >would be expensive.
> 
> Guess you are right, but, once again, the problem is not so much about
> fooling the system to do something or other, but confusing the user:
> 
> a. Everything is fine - the load is 0%, the fact that the system is
>    overheating and/or that some processes do not do as much as they
>    could is probably due to the bad hardware.
> 
> b. The weird load pattern must be the result of bugs in my code.
>    (And then a whole lot of time/effort is poured into fixing the
>     problem which is simply not there)
> 
> The current situation ought to be documented. Better yet some flag
> can

It probably _is_ documented, somewhere :-). If you find nice place
where to document it (top manpage?) go ahead with the patch.

> be introduced somewhere in the system so that it exports realy values to
> /proc, not the estimations that are innacurate in some cases (like hog)

Patch would be welcome, but I do not think it will be easy.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
