Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbXD2JAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbXD2JAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 05:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbXD2JAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 05:00:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48257 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755086AbXD2I7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:59:50 -0400
Date: Sun, 29 Apr 2007 10:59:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Back to the future.
Message-ID: <20070429085937.GD1900@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704290103.38409.rjw@sisk.pl> <alpine.LFD.0.98.0704281640480.9964@woody.linux-foundation.org> <200704291057.48747.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704291057.48747.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ie we do have history of _not_ freezing things.  The freezing came later, 
> > and came with the subsystem that had more problems..
> 
> It doesn't have that many problems as you are trying to suggest.  At present,
> the only problems with it happen if someone tries to "improve" it in the way
> I did with the workqueues.
> 
> Anyway, the freezing of tasks, including kernel threads, is one of the few
> things on which Pavel, Nigel and me completely agree that they should be done,
> so perhaps you could accept that?

Actually, if we want to support OLPC _nicely_, we'll need to get rid
of freezer from suspend-to-RAM. Of course, that _will_ put more
pressure at the drivers -- and break few of them...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
