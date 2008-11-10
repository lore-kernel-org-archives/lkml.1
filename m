Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbYKJJmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbYKJJmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYKJJmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:42:42 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38888 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYKJJml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:42:41 -0500
Date: Mon, 10 Nov 2008 10:42:39 +0100
From: Pavel Machek <pavel@suse.cz>
To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Message-ID: <20081110094239.GA14204@atrey.karlin.mff.cuni.cz>
References: <20081109195033.GA1335@mobydick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109195033.GA1335@mobydick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I've just finished compiling a recent snapshot of rc3 (namely gfed4d59
> [1]) on a F9 distro (gcc 4.3.0 20080428) and suspend to disk doesn't
> work anymore.  My config is attached below [2].
> 
> It just freezes my laptop (an old Thinkpad T30) while it works with
> kernel version 2.6.26 (I've never tried 2.6.27).
> 
> I've tried playing with the pm_test facility, and while the "freezer"
> test works, the "devices" test fails like the real suspend...
> 
> When that happens, the console still works (ie I can switch VTs and
> type) but the whole system doesn't respond: I can't login for example...
> Guess the disk driver is already off at that point.
> 
> I don't have another computer to capture a serial trace so I guess I'm
> going to try to bisect it (which is going to take while on this slow
> computer).  If I reconfigure my syslog could I get the output of the
> suspend process on the screen (for some reason I used to get it during
> suspend but now I only get it during resume)?
> 
> Any ideas or pointers to fix this appreciated...

Trying with minimum drivers is likely to help here, and should be
easier than bisect. Boot with init=/bin/bash, then try "devices" >
pm_dest and disk > state...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
