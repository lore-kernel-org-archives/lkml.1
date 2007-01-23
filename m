Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbXAWJl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbXAWJl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 04:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbXAWJl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 04:41:27 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2161 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932926AbXAWJl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 04:41:26 -0500
Date: Tue, 23 Jan 2007 09:41:15 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Alessandro Di Marco <dmr@gmx.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070123094114.GE6033@ucw.cz>
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz> <877ivfi60i.fsf@gmx.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ivfi60i.fsf@gmx.it>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>    > +if [ ! -d "/proc/sin" ]; then
>    > +    echo "/proc/sin not found, has sinmod been loaded?"
>    > +    exit
>    > +fi
> 
>    No new /proc files, please.
> 
> This was merely a prototype realized in a hurry, not a production
> driver. Really, I did't think it could be interesting for anybody.
> 
> Would be /sys ok?

If it has to be in kernel, /sys/power is probably ok. But I still
believe it can be out.

Yes, I believe it is interesting: on modern machine, you want to
control keyboard illumination, lower backlight after short inactivity,
turn screen off after longer one, etc...

>    Heh. We'll waste power trying to save it.
> 
> Well, not just a power saver. For example I use SIN to auto-logoff my bash
> session as well (detaching the screen session.)

Ok, ok :-).

>    If you have to hook it into kernel, can you at least do it properly?
> 
> Of course. You can find attached a patch fixing this. Now SIN wakes up just
> when it expects to do something: if in the meantime the user interacts with the
> system, SIN simply recalculates the next wake-up time on the basis of the last
> user's activity date and goes to sleep again.

Good.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
