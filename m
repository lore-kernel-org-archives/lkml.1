Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbXEKM34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbXEKM34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbXEKM3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:29:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1355 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760083AbXEKM3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:29:47 -0400
Date: Thu, 10 May 2007 13:09:55 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Esben Nielsen <nielsen.esben@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070510130954.GC4052@ucw.cz>
References: <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com> <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire> <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org> <20070506082911.GA32644@elte.hu> <alpine.LFD.0.98.0705061037390.25245@woody.linux-foundation.org> <Pine.LNX.4.64.0705071311040.14011@frodo.shire> <463FC5D8.2090502@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463FC5D8.2090502@bigpond.net.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>You say there is "no danger of overflow", and I mostly 
> >>agree that once
> >>we're talking about 64-bit values, the overflow issue 
> >>simply doesn't
> >>exist, and furthermore the difference between 63 and 
> >>64 bits is not really
> >>relevant, so there's no major reason to actively avoid 
> >>signed entries.
> >>
> >>So in that sense, it all sounds perfectly sane. And 
> >>I'm definitely not
> >>sure your "292 years after bootup" worry is really 
> >>worth even considering.
> >>
> >
> >I would hate to tell mission control for Mankind's 
> >first mission to another
> >star to reboot every 200 years because "there is no 
> >need to worry about it."
> >
> >As a matter of principle an OS should never need a 
> >reboot (with exception for upgrading). If you say you 
> >have to reboot every 200 years, why not every 100? 
> >Every 50? .... Every 45 days (you know what I am 
> >referring to :-) ?
> 
> There's always going to be an upper limit on the 
> representation of time. At least until we figure out 
>  how to implement infinity properly.

There's also upper limit on life time of this universe. 1000 bits is
certainly enough  to represent that in u-seconds.

Also notice that current cpus were not designed to work 300 years.
When we have hw designed for 50 years+, we can start to worry.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
