Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbXGaGdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbXGaGdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 02:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXGaGdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 02:33:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58686 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751770AbXGaGdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 02:33:45 -0400
Date: Tue, 31 Jul 2007 08:33:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_SUSPEND? (was: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1)
Message-ID: <20070731063310.GC22419@elf.ucw.cz>
References: <200707251238.50218.lenb@kernel.org> <alpine.LFD.0.999.0707280921150.3442@woody.linux-foundation.org> <alpine.LFD.0.999.0707280932470.3442@woody.linux-foundation.org> <200707302353.19217.lenb@kernel.org> <Pine.LNX.4.64.0707302102160.6478@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707302102160.6478@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-07-30 21:09:33, david@lang.hm wrote:
> On Mon, 30 Jul 2007, Len Brown wrote:
> 
> >On Saturday 28 July 2007 12:55, Linus Torvalds wrote:
> >
> >>So I think the real issue is that we allow that
> >>"suspend_devices_and_enter()" code to be compiled without HOTPLUG_CPU in
> >>the first place. It's not supposed to work that way.
> >
> >I don't see how CONFIG_HOTPLUG_CPU justifies its own existence.
> >This e-mail thread would have never happened if it were simply included
> >in CONFIG_SMP, always.
> >
> >I agree, of course, that ACPI should never have had to work-around
> >this by selecting HOTPLUG_CPU.  But even though it is now done at
> >the right layer, I don't see why PM should have to
> >be bothered with selecting HOTPLUG_CPU either --
> >it should just come with SMP.
> 
> why do you need hotplug just becouse you have muliple cpus? if you never 
> have any intention of useing suspend and your hardware doesn't support 
> hotplugging, why should you have to include the code for it?

Because otherwise we have way too many config options, and there are
basically no downsides? Too many options => too little testing of each
permutation...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
