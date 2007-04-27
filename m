Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbXD0NVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbXD0NVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbXD0NVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:21:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60393 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755757AbXD0NVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:21:11 -0400
Date: Fri, 27 Apr 2007 14:50:01 +0200
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
Message-ID: <20070427125001.GI22250@elf.ucw.cz>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070425203150.GD17387@elf.ucw.cz> <1177669279.7828.55.camel@johannes.berg> <200704271407.00879.rjw@sisk.pl> <20070427124029.GH22250@elf.ucw.cz> <1177678002.6024.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177678002.6024.11.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Five callbacks are fine by me, especially if we can define reasonable defaults
> > > for the hibernation (and can we?).
> > 
> > Well, we still can default to suspend(PMSG_FREEZE) for freeze(), and
> > resume() for thaw(). Anything else is just not sane way forward.
> 
> I think we should remove the argument to suspend() in the same patch
> series. Yes, that would mean porting all drivers that currently use
> it,

Well, if you can do it in one patch series, go ahead. But I think such
massive change all over kernel will take slightly longer, so I'd
prefer to keep the dummy argument for a while (so it still compiles)
and fix it slowly.

Of course, it is up to the person doing the series. And yes, such
series would be welcome.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
