Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbXKCSXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbXKCSXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbXKCSXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:23:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54236 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbXKCSXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:23:11 -0400
Date: Sat, 3 Nov 2007 19:23:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH 1/3] Suspend: Testing facility
Message-ID: <20071103182319.GC13202@elf.ucw.cz>
References: <200711012357.27797.rjw@sisk.pl> <200711012358.27919.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711012358.27919.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Introduce /sys/power/pm_test_level attribute allowing one to test the suspend
> core code.  Namely, writing a number (1-5) to this file causes the suspend code
> to work in one of the test modes defined as follows:
> 
> 5 - test the freezing of processes
> 4 - test the freezing of processes and suspending of devices
> 3 - test the freezing of processes, suspending of devices and platform global
>     control methods
> 2 - test the freezing of processes, suspending of devices, platform global
>     control methods and the disabling of nonboot CPUs
> 1 - test the freezing of processes, suspending of devices, platform global
>     control methods, the disabling of nonboot CPUs and suspending of
>     platform/system devices
> 
> Then, if a suspend is started by normal means, the suspend core will perform
> its normal operations up to the point indicated by the test level.  Next, it
> will wait for 5 seconds and carry out the resume operations needed to transition
> the system back to the fully functional state.
> 
> Writing 0 to /sys/power/pm_test_level turns the testing off.  The current test
> level may be read from /sys/power/pm_test_level .
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK on whole series, but... should we also remove the old debugging
infrastructure? (Or did I just miss it?)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
