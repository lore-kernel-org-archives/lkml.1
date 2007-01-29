Return-Path: <linux-kernel-owner+w=401wt.eu-S1751242AbXA2L6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbXA2L6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXA2L6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:58:55 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4769 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751242AbXA2L6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:58:54 -0500
Date: Mon, 29 Jan 2007 11:58:42 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: roucaries bastien <roucaries.bastien@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Re: Bcm43xx oops after suspend to disk
Message-ID: <20070129115842.GA4928@ucw.cz>
References: <45B92488.6090908@lwfinger.net> <45B92536.2080909@lwfinger.net> <195c7a900701251530m409878a8id301c7cada76f342@mail.gmail.com> <45BA246B.6030505@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA246B.6030505@lwfinger.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Do you have the log stuff that precedes this part? In particular, was
> >> there a assertion that failed?
> >>
> > It is oops on resume and no asseertion failled this boot. However I
> > have usually a lot of
> > bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
> > drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
> 
> Those are well known and do not affect this problem.
> 
> > Moreover after the first oops I have a second oops (Surelly a
> > consequence of the first).
> 
> I think that is right.
> 
> Unfortunately, I cannot test for this problem on my system as it doesn't suspend at all.

Can you try to debug that? swsusp is very easy to get going these
days. And with minimum drivers, it tends to work very reliably. Any
help I can provide?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
