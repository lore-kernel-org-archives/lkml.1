Return-Path: <linux-kernel-owner+w=401wt.eu-S933637AbXEGM3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbXEGM3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 08:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbXEGM3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 08:29:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51411 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933637AbXEGM3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 08:29:31 -0400
Date: Mon, 7 May 2007 14:29:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: driver power operations (was Re: suspend2 merge)
Message-ID: <20070507122915.GF20605@elf.ucw.cz>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org> <20070425200836.GB17387@elf.ucw.cz> <200704252233.25296.rjw@sisk.pl> <20070425203150.GD17387@elf.ucw.cz> <1177669279.7828.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177669279.7828.55.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > So, the "suspend" and "resume" for the functions being called for that are
> > > wrong, but then we call them with PMSG_FREEZE. ;-)  Still, we could add
> > > .freeze() and .thaw() callbacks for hibernation just fine.  This wouldn't even
> > > be that difficult ...
> > 
> > It would be ugly big patch I'm afraid.
> 
> It'd be a lot of code churn, but well worth it. And most of the changes
> would be trivial too. You need to start looking beyond "this is ugly in
> the short term" and realise that it's much more maintainable in the long
> term if driver writers know what they're supposed to do as opposed to
> just hacking at it until it mostly works or just doing a full device
> down/up cycle including resetting full driver state.

I do not disagree with you. It will be ugly big patch, but it is
probably worth it, so the patch will be welcome.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
