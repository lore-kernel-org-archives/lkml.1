Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbYGGRhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbYGGRhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYGGRhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:37:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59302 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbYGGRhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:37:23 -0400
Date: Mon, 7 Jul 2008 19:37:08 +0200
From: Pavel Machek <pavel@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080707173708.GA3000@elf.ucw.cz>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10919
> > Subject		: [regression] display dimming is slow and laggy - Acer Travelmate 661lci
> > Submitter	: Maximilian Engelhardt <maxi@daemonizer.de>
> > Date		: 2008-06-14 22:31 (23 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121348428828320&w=4
> 
> I wonder if this one could be related. The 'nr_zones' overwriting bug 
> would result in kswapd not reclaiming any memory asynchronously, so the 
> kernel would basically be constantly under a low-memory situation, and 
> processes would be forced to do synchronous reclaim. 
> 
> That, in turn, could easily explain laggy operation, especially if it is 
> something bigger that needs to allocate new memory (not that I know if X 
> dimming needs to, but I could imagine that it does some double buffering 
> or whatever).

Hmm, but that would mean whole system is slow, right?

I'd bet this is ACPI EC problem...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
