Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYCTHFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYCTHFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYCTHFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:05:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37379 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYCTHFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:05:10 -0400
Date: Thu, 20 Mar 2008 08:05:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, marcel@holtmann.org, maxk@qualcomm.com,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
Subject: Re: bluetooth still corrupts memory in 2.6.25-rc6
Message-ID: <20080320070545.GA17356@elf.ucw.cz>
References: <20080319082115.GA14543@elf.ucw.cz> <47E19BA1.8010905@gmail.com> <20080319230624.GJ1811@elf.ucw.cz> <47E1A112.4060208@gmail.com> <a8e1da0803191950s1a656fffq98fbc180069814d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0803191950s1a656fffq98fbc180069814d9@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  >>> ...just leave ppp-over-cellphone-over-bluetooth running, and do
> >  >>> s2ram...
> >  >>>
> >  >>> Linux version 2.6.25-rc6 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #186 SMP Wed Mar 19 00:46:05 CET 2008
> >  >>> BIOS-provided physical RAM map:
> >  >> Pavel, does the "still" from $SUBJ mean, that 2.6.24 is affected too (if
> >  >> this is the same what I hit)?
> >  >
> >  > Hey, I did not do careful analysis. I believe it is the same problem
> >  > that affects 2.6.24, too, yes. But I actually believe it is much older
> >  > than that...
> >
> >  If yes, then I got the crash by using hidp over l2cap with non-hid device
> >  (session->input). I'm not sure if it was connected at all and even if hidd was
> >  running (I tested moving with mouse by cellphone with switching on and off the
> >  daemon, since it needed some little changes).

If you have easy/reproducible way of triggering that crash, yes that
would be useful.

...just leave ppp-over-cellphone-over-bluetooth running, and do
s2ram... takes few tries to reproduce, and you need to set up ppp each
time, so it is quite nasty to debug...

> >  If you, hci fellows, are interested I might send more detailed description of
> >  the crash tomorrow.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
