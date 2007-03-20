Return-Path: <linux-kernel-owner+w=401wt.eu-S965830AbXCTSkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965830AbXCTSkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965753AbXCTSjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:39:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60022 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965808AbXCTSia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:38:30 -0400
Date: Tue, 20 Mar 2007 19:38:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.osdl.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070320183821.GD2670@elf.ucw.cz>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <45FFF026.4030502@gmail.com> <20070320080944.9cb3c765.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320080944.9cb3c765.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Andrew Morton napsal(a):
> > >   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> > 
> > I'm getting this while trying to swsusp:
> > Stopping tasks ...
> > Stopping kernel threads timed out after 20 seconds (1 tasks refusing to freeze):
> >  swapper
> >  Restarting tasks ... done.
> > 
> > What to test? Enable PM_DEBUG?

Is it repeatable? Freezer normally works better than that.

> hm, OK.  Rafael has been working on fixing the process freezer and it'll
> take some time to get it to where we want it to be, I expect.

> Rafael, I think that we could afford to add heaps of debug in there at this
> stage to help us track down problems like this.
> 
> Also, it might be useful to add a temporary /proc/freeze-unfreeze thing
> which will simply do a freeze/unfreeze cycle.  Then we can apply various
> workloads to the machine while madly stressing the freezer code.  

echo testproc > /sys/power/disk; echo disk > /sys/power/state ... is
pretty much what you want.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
