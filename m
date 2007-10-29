Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbXJ2VYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbXJ2VYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbXJ2VYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:24:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59106 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbXJ2VYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:24:10 -0400
Date: Mon, 29 Oct 2007 22:24:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.23] IBM X41 looses time after Suspend2Disk
Message-ID: <20071029212414.GD3692@elf.ucw.cz>
References: <20071029201955.GA1955@titan.lahn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029201955.GA1955@titan.lahn.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have an IBM X41 tablet pc running 2.6.23 with the following problem:
> Suspend2Ram work fine, but when I do a Suspend2Disk (echo disk >
> /sys/power/state), the notebook hangs showing the following lines:
>         Stopping tasks ... done.
>         Shrinking memory... done (49361 pages freed)
>         Freed 197444 kbytes in 0.64 seconds (308.50 MB/s)
>         Suspending console(s)
> 
> When I repeatedly press some keys or move the TrackPoint, the SwSusp
> continues and the notebook powers off.
> On reboot, the notebook resumes but hangs showing the following screen:
>         Stopping tasks ... done.
>         Loading image data pages (62483 pages) ... done
>         Read 249932 kbytes in 18.63 seconds (13.41 MB/s)
>         Suspending console(s)
> 
> Generating interrupts by pressing keys or moving the TrackPoints makes
> the resume continue. But after that, the notebook looses time, xterms
> don't get updated until I press a key, the beeper beeps until I press a
> key, etc.
> 
> Any idea what the problem might be?

Yep, I seen that before. Try "nohz=off".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
