Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbXGLUkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbXGLUkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763195AbXGLUjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:39:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36670 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762999AbXGLUjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:39:18 -0400
Date: Thu, 12 Jul 2007 11:15:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: nigel@nigel.suspend2.net, rjw@sisk.pl, a1426z@gawab.com, jeremy@goop.org,
       jbms@cmu.edu, nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Hibernation Redesign
Message-ID: <20070712091553.GC1866@elf.ucw.cz>
References: <200707081737.21932.a1426z@gawab.com> <200707111350.41806.rjw@sisk.pl> <E1I8amY-00009H-00@dorka.pomaz.szeredi.hu> <200707112200.43613.nigel@nigel.suspend2.net> <E1I8b0l-0000DB-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I8b0l-0000DB-00@dorka.pomaz.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Freezing of tasks is slowing down suspend.  Don't know how serious
> > > this is, suspend is pretty fast, but could possibly be even faster.
> > 
> > It's FUD. Freezing of tasks normally takes next to no time. I've never 
> > understood the rediculously long timeout it has. If freezing succeeds, all 
> > processes are frozen within 1/2 a second tops. If it fails, nothing is going 
> > to change in the following 19.5 seconds (or whatever it is if I don't 
> > remember the value properly).
> 
> Right.  The 20s timeout is again a sign of brokenness.

Well, "scenario 1/2 - simple/tricky deadlock" is a sign of brokenness,
too.

> If we expect something to fail, it should fail immediately, without
> waiting for arbitrary timeouts.

Agreed that freezer is not nice, but core issue here is that fuse
allows userspace tasks to hold kernel locks... bad.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
