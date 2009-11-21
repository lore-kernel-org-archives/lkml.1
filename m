Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZKUTFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZKUTFX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 14:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZKUTFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 14:05:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33846 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbZKUTFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 14:05:21 -0500
Date: Sat, 21 Nov 2009 20:05:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-thinkpad@linux-thinkpad.org
Subject: Re: High power consumption after suspend/resume cycle
Message-ID: <20091121190520.GB2444@ucw.cz>
References: <cb0375e10910021044n182d696dy8fd566925e46b134@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0375e10910021044n182d696dy8fd566925e46b134@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'm running a git kernel that's slightly newer than 2.6.32-rc1.
> 
> First, thanks for all the great work everywhere on laptop power
> consumption -- on my Lenovo X200s, it looks like Linux is getting
> close to Windows (Windows wins by about 0.7W, except that its power
> usage frequently spikes since Windows apparently still doesn't know
> how to sit still and do nothing, whereas Linux's seems more stable.).
> Windows after a reboot, even running KDE with compositing enabled and
> while connected to wifi, at least after some tweaking.
> 
> There's a catch, though: after a suspend/resume cycle, power
> consumption goes up by over well over a watt.  (On a system that draws
> about 7 watts before suspending, that's a big deal.)  I've tried
> turning off X, suspending with 'echo mem > /sys/power/state' to avoid
> any distro scripts running, and manually restoring SATA power saving
> settings, but it still happens.  I even tried unbinding e1000e and
> both USB drivers, unloading the i2400 (wimax) driver, iwlagn, and
> iwlcore, and it still happens.  This is 100% reproducible, and I'd be
> happy to test things.
> 
> This could be a BIOS bug I suppose (although I'm running the latest
> BIOS), but Windows 7 does not have this problem at all.
> 
> Any ideas about what to try or what subsystem to blame?

Well, on thinkpad x60 power consumption is .3W *lower*.

You could try comparing lspci -vvv before and after... but this is
deep magic and hard to debug. 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
