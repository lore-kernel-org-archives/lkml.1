Return-Path: <linux-kernel-owner+w=401wt.eu-S1763584AbXHFLgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763584AbXHFLgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759225AbXHFLg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:36:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55354 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757509AbXHFLg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:36:28 -0400
Date: Mon, 6 Aug 2007 13:36:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [linux-pm] Re: [Resend][PATCH] PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION (updated)
Message-ID: <20070806113644.GA1790@elf.ucw.cz>
References: <200708051906.22865.rjw@sisk.pl> <20070806090713.GC15329@atrey.karlin.mff.cuni.cz> <1186392591.28655.35.camel@johannes.berg> <20070806102659.GB1875@elf.ucw.cz> <1186398917.28655.69.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186398917.28655.69.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-08-06 13:15:17, Johannes Berg wrote:
> On Mon, 2007-08-06 at 12:26 +0200, Pavel Machek wrote:
> 
> > Well, so that it does not bitrot? This is few bytes, I'd say, and I
> > believe we have too many config options already.
> 
> This is not an option the user is ever going to see. I think I'd
> prefer

Ok, option that users can't set is probably not evil.

> having two new per-ARCH config symbols though:
> config SUSPEND_UP_POSSIBLE
> 	depends on ARCH_SUSPEND_UP_POSSIBLE
> 
> and then the architecture gets to define that when it can suspend.

Looks like a plan.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
