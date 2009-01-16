Return-Path: <linux-kernel-owner+w=401wt.eu-S1763440AbZAPIxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763440AbZAPIxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbZAPIx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:53:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52033 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbZAPIx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:53:27 -0500
Date: Fri, 16 Jan 2009 09:53:26 +0100
From: Pavel Machek <pavel@suse.cz>
To: MartinG <gronslet@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend/resume works in 2.6.29-0.19.rc0.git9.fc11.i686, but fails in later versions
Message-ID: <20090116085326.GC4795@atrey.karlin.mff.cuni.cz>
References: <bcb3ef430901150110nc4ced93w50c662ac512f8552@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcb3ef430901150110nc4ced93w50c662ac512f8552@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi, I run Fedora Rawhide on a Dell Latitude X1 and want to report on
> failing suspend/resume on the latest kernel snapshots.
> Smolt is currently not working in Rawhide, but an old profile of my
> laptop can be found in [1]
> 
> In kernel-2.6.29-0.19.rc0.git9.fc11.i686 I have suspend(to ram)/resume
> working, but in later versions, I am not able to get my laptop to
> resume. I have tested these later kernels:
> kernel-2.6.29-0.24.rc0.git13.fc11.i686
> kernel-2.6.29-0.25.rc0.git14.fc11.i686
> kernel-2.6.29-0.28.rc1.fc11.i686
> kernel-2.6.29-0.31.rc1.git2.fc11.i686
> kernel-2.6.29-0.35.rc1.git4.fc11.i686
> 
> None of them seems to let me wake up from suspend to ram.
> I have used normal kwin (no desktop effects, no compiz).
> When I open the lid, my wlan led lights up, but there is no hdd
> activity, and the keyboard is dead.
> 
> Here's dmesg of the working kernel http://fpaste.org/paste/1459
> 
> Please let me know how I can test further and what logs to provide.

Can you boot non-working kernel, and try "cd /sys/devices/system/cpu;
echo 0 > cpu1/online; echo 1 > cpu1/online" ?

If it breaks, try just doing "echo 0 > online" followed by s2ram. That
should work.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
