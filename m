Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYKDK4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYKDK4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 05:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYKDK4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 05:56:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52063 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYKDK4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 05:56:01 -0500
Date: Tue, 4 Nov 2008 11:56:00 +0100
From: Pavel Machek <pavel@suse.cz>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: System hang from holding left shift key
Message-ID: <20081104105600.GA4514@atrey.karlin.mff.cuni.cz>
References: <490EAB65.1000908@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490EAB65.1000908@lwfinger.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> While absentmindedly holding down the left shift key as I was thinking about my
> next input, I froze the keyboard. After 3 seconds, the system sounded a high
> beep, and then a low beep after another 3 seconds. At that point, no key entry
> had any effect. From the beeps, one might conclude that the input buffer is
> full, but a CTRL/U did not clear it. Fortunately, a short press on the power
> button shut down the machine cleanly.
> 
> I don't know if this is a regression. I found it in v2.6.28-rc2, but the oldest
> kernel that I could test (v2.6.24) already has the problem.
> 
> When the beeps occur, a stack dump is as follows:

What kind of machine is that...? I can't reproduce it here, do I need
some accessibility options enabled?

									Pavel


> Pid: 2989, comm: Xorg Not tainted 2.6.28-rc2-Linus-00473-g67d1128-dirty #2
> Call Trace:
>   [<ffffffff803957ce>] kd_mksound+0x69/0xa9
>   [<ffffffff8039196c>] vt_ioctl+0x3c4/0x1744
>   [<ffffffff8038b097>] tty_ioctl+0x793/0x7fa
>   [<ffffffff8025c6c0>] ? trace_hardirqs_off+0xd/0xf
>   [<ffffffff8044f94a>] ? _spin_unlock_irqrestore+0x3d/0x4c
>   [<ffffffff802bf102>] vfs_ioctl+0x2f/0x7d
>   [<ffffffff802bf4fe>] do_vfs_ioctl+0x3ae/0x3e0
>   [<ffffffff8020c07c>] ? sysret_check+0x27/0x62
>   [<ffffffff802bf577>] sys_ioctl+0x47/0x6a
>   [<ffffffff8020c04b>] system_call_fastpath+0x16/0x1b
> 
> Thanks,
> 
> Larry
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
