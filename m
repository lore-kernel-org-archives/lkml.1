Return-Path: <linux-kernel-owner+w=401wt.eu-S936309AbXGUKRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936309AbXGUKRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 06:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932340AbXGUKRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 06:17:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39535 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932324AbXGUKRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 06:17:33 -0400
Date: Sat, 21 Jul 2007 12:17:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
Message-ID: <20070721101741.GD1902@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707161015490.3410-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0707162137220.19248@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707162137220.19248@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Part of the problem here is that ACPI already has its own terminology,
> >and you're trying to invent a new one instead of using the existing
> >one.
> >
> >I agree, it would be good to have a non-ACPI-specific hibernation mode,
> >something which would look to ACPI like a normal shutdown.  But I'm not
> >so sure this is possible.
> 
> why would it not be possible?
> 
> >You have to understand that the ACPI spec is weird and complex.  The
> >mere fact that you have written a system image to disk changes the way
> >ACPI regards the shutdown procedure.  Even though you may treat all the
> >devices and the rest of the hardware exactly the same, it's a different
> >operation as far as ACPI is concerned, with different requirements.
> >
> >Yes, it's bizarre.  Why do you think so many people have complained so
> >vehemently about ACPI for all these years?
> 
> so let's act as if ACPI doesn't exist and make a suspend-to-disk that 
> works without it and looks to ACPI like a complete power off/on cycle (but 
> looks to the user like a suspend/resume cycle)

...if you act as if ACPI does not exist, you'll loose AC/battery power
status upon resume, and maybe more, because ACPI handles that.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
