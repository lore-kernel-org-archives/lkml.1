Return-Path: <linux-kernel-owner+w=401wt.eu-S932896AbXAWQfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbXAWQfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 11:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933037AbXAWQfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 11:35:01 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:32837 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932896AbXAWQfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 11:35:00 -0500
Date: Tue, 23 Jan 2007 17:34:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alessandro Di Marco <dmr@gmx.it>
Cc: linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070123163442.GA18662@elf.ucw.cz>
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz> <877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz> <87wt3dhlte.fsf@gmx.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wt3dhlte.fsf@gmx.it>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi1

>    >    > +if [ ! -d "/proc/sin" ]; then
>    >    > +    echo "/proc/sin not found, has sinmod been loaded?"
>    >    > +    exit
>    >    > +fi
>    >
>    >    No new /proc files, please.
>    >
>    > This was merely a prototype realized in a hurry, not a production
>    > driver. Really, I did't think it could be interesting for anybody.
>    >
>    > Would be /sys ok?
> 
>    If it has to be in kernel, /sys/power is probably ok.
> 
> Doh! The attached patch introduces /sys/class/misc (along with some bug-fixes.)
> In case I'll change it again.

No, just leave it where it is. Maybe better location will be invented,
but mine idea was just first shot.

>    But I still believe it can be out.
> 
> Do you believe it could be a user-space daemon or what?

Yes, what prevents userspace daemon watching /dev/input/event* to
provide this functionality?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
