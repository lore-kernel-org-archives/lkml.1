Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXAWSov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXAWSov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 13:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXAWSov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 13:44:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55613 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933103AbXAWSou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 13:44:50 -0500
Date: Tue, 23 Jan 2007 19:44:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alessandro Di Marco <dmr@gmx.it>
Cc: linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070123184432.GE18662@elf.ucw.cz>
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz> <877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz> <87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz> <87lkjthdmd.fsf@gmx.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lkjthdmd.fsf@gmx.it>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>    >    But I still believe it can be out.
>    >
>    > Do you believe it could be a user-space daemon or what?
> 
>    Yes, what prevents userspace daemon watching /dev/input/event* to
>    provide this functionality?
> 
> Well that was my first attempt. Just an hack, but it works. Nonetheless I found
> the kernel-level approach fitting better the problem: it is elegant, simpler
> and more efficient than user-level one.

Well, unfortunately it is also wrong thing to do :-(.

> For example, the subsystem provides at kernel-level handy
> hiberante/suspend/resume callbacks that I use to turn on/off the timer,
> avoiding the time-warp problem. Doing that at user-level would be far more
> messy...

Imagine for a moment that we solve time-warp somehow. Any other
problems? [I'd really like to get "is user idle" solved, but it really
should not be in kernel unless it _has_ to. And time-warp probably
causes problems not only for your daemon.]
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
