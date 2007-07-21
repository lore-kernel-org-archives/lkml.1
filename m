Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbXGUR4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbXGUR4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 13:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXGUR40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 13:56:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41154 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752563AbXGUR4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 13:56:25 -0400
Date: Sat, 21 Jul 2007 19:56:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: david@lang.hm, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
Message-ID: <20070721175639.GA3701@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org> <200707171802.30903.rjw@sisk.pl> <Pine.LNX.4.64.0707170959160.2467@asgard.lang.hm> <200707172150.44417.rjw@sisk.pl> <Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm> <20070721102520.GE1902@elf.ucw.cz> <87ps2lojlc.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ps2lojlc.fsf@jbms.ath.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Pavel Machek <pavel@ucw.cz> writes:
> 
> [snip]
> 
> > So it will be break at least battery status and "AC plugged in"
> > status, because those are handled by ACPI and we do not know how to
> > control them by hand.
> 
> It seems that it should be possible to initialize ACPI as if the system
> just booted up normally.  Then battery status and such should be
> correct, since they are correct after normal initialization.
> 
> It should be possible to make hibernate look just like a reboot to all
> of the devices, including ACPI stuff.

Patch to make that work with swsusp/shutdown method would be indeed
welcome. It does not work today.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
