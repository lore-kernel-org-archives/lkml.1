Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbXJBJgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbXJBJgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXJBJgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:36:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51715 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXJBJgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:36:42 -0400
Date: Tue, 2 Oct 2007 11:36:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: rtc-linux@googlegroups.com, kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Message-ID: <20071002093641.GA11039@atrey.karlin.mff.cuni.cz>
References: <20070920103225.GA4410@elf.ucw.cz> <20070920105002.GA4611@elf.ucw.cz> <200709212238.05130.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709212238.05130.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > ...should they be changed to 200? Or perhaps file should be readable?
> 
> No, mode 644 is fine.  No reason to prevent "other" people from
> reading the alarm time (is there?) and if you write a legal value,
> that will work.  So $SUBJECT is no problem at all.

Yep, agreed. I was confused by fact that it does not give invalid
values back. 

> > > root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> > > root@amd:/sys/class/rtc/rtc0# echo 132719 > wakealarm 
> 
> At which point I'd expect
> 
> # echo $?
> 
> would indicate the write failed.  That's a LONG time in the
> past (January 2, 1970), so that setting would be rejected.

echo $? says 0 here :-(.

> > > root@amd:/sys/class/rtc/rtc0# 
> > > 
> > > ...standard PC with reasonably recent kernel...
> 
> Yeah, well a "standard PC" is chock full of fairly bizarrely
> glitchey hardware.  Clocks and timers have more than their
> fair share, or x86_64 NOHZ support would be merged by now!

:-). Ok. Thinkpad x60.
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
