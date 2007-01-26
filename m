Return-Path: <linux-kernel-owner+w=401wt.eu-S1030885AbXAZRQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030885AbXAZRQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030873AbXAZRQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:16:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50816 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030891AbXAZRQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:16:37 -0500
Date: Fri, 26 Jan 2007 18:15:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alessandro Di Marco <dmr@gmx.it>
Cc: linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070126171536.GB964@elf.ucw.cz>
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz> <877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz> <87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz> <87lkjthdmd.fsf@gmx.it> <20070123184432.GE18662@elf.ucw.cz> <873b61cf1v.fsf@gmx.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873b61cf1v.fsf@gmx.it>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>    Imagine for a moment that we solve time-warp somehow. Any other
>    problems? 
> 
> Well, a user-level daemon have to process a lot of data just to detect user
> interaction. Considering that the trackpad bandwidth is nearly 5KB/sec,
> probably would be better to leave my panel alone... :-/

Ok, so we may want to introduce something like "tell me if some data
came from last time"... Actually, 5KB/sec is pretty much okay, and you
probably could get around actually reading that data.

When you know user is moving the touchpad, you could just sleep for 5
seconds (assuming user activity) and only then start monitoring it
again?

>    I'd really like to get "is user idle" solved, but it really should not be in
>    kernel unless it _has_ to. And time-warp probably causes problems not only
>    for your daemon.
> 
> IMHO signal the user-space is a kernel duty and no user-space daemon will ever
> make it better. There are plenty of PM daemons out there, but Linux still lacks

Well, I do not think your kernel code is mergeable. But bits to enable
similar functionality in userspace probably would be mergeable.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
