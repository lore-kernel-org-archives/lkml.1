Return-Path: <linux-kernel-owner+w=401wt.eu-S1762972AbXG0SJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972AbXG0SJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbXG0SIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:08:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4817 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755350AbXG0SIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:08:38 -0400
Date: Fri, 27 Jul 2007 11:46:38 +0000
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: Power Management framework proposal
Message-ID: <20070727114637.GC11895@ucw.cz>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm> <1185125189.2714.13.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0707221130380.6350@asgard.lang.hm> <1185143240.2714.24.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0707221946170.6350@asgard.lang.hm> <1185163239.2714.37.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0707222105310.6350@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707222105310.6350@asgard.lang.hm>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>example 1: a laptop screen
> >>
> >>mode  capacity power description
> >>0        0        0    off
> >>1      100      100    full brightness
> >>2       70       60    half power to the backlight
> >>3       50       35    quarter power to the backlight
> >>4       30       25    eighth power to the backlight
> >>5        5       10    backlight off.
> >>
> >>example 2: a front-panel display on a server (no 
> >>variable backlight
> >>control)
> >>
> >>mode capacity power description
> >>0       0        0   off
> >>1     100      100   backlight on
> >>2      50       10   backlight off
> >
> >
> >the problem is: the person who SETS these needs to know 
> >what they mean.
> 
> that's what the description is for. this info can be 
> provided by the driver as part of the list_modes() 
> function.

That's what /sys/class/backlight/ is for :-).

> >as someone who wrote (part of) a power policy manager; 
> >sorry but you
> >take away information I need, and in addition the 
> >different API's are
> >absolutely no big deal.
> 
> assuming that nobody else chimes in to disagree with you 
> I'll accept your judgement and drop the issue.

Just for the record, I agree with Arjan here.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
