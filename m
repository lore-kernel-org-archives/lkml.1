Return-Path: <linux-kernel-owner+w=401wt.eu-S938056AbXGUKZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938056AbXGUKZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 06:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932685AbXGUKZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 06:25:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37744 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759100AbXGUKZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 06:25:06 -0400
Date: Sat, 21 Jul 2007 12:25:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
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
Message-ID: <20070721102520.GE1902@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org> <200707171802.30903.rjw@sisk.pl> <Pine.LNX.4.64.0707170959160.2467@asgard.lang.hm> <200707172150.44417.rjw@sisk.pl> <Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> from my point of view the ACPI S4 sleep mode has far more in common with 
> suspend-to-ram then with the suspend-to-disk that I'm talking about
> 
> non-ACPI hibernate
> 
>   since the box powers off
>     it uses zero power while suspended
>     another OS could be run before a resume
>     hardware can be swapped, suspend image could be sent around the world 
>     to be restored on another system.
>     restore makes no assumptions about the state of the hardware when it is 
>     restored
>     restore is slower (full BIOS boot is required)
>   should be able to work on just about any hardware (the limit is the 
>   ability to initialize the devices)

So it will be break at least battery status and "AC plugged in"
status, because those are handled by ACPI and we do not know how to
control them by hand.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
