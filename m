Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYLIMnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYLIMnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 07:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYLIMnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 07:43:33 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47317 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYLIMnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 07:43:32 -0500
Date: Tue, 9 Dec 2008 13:43:21 +0100
From: Pavel Machek <pavel@suse.cz>
To: mtk.manpages@gmail.com
Cc: Jonathan Corbet <corbet@lwn.net>,
       kernel list <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Document sysfs interface to RTC system wakeup
Message-ID: <20081209124320.GC1547@ucw.cz>
References: <20081126161524.GD1983@elf.ucw.cz> <20081126095610.13195e15@bike.lwn.net> <20081126170032.GE10157@atrey.karlin.mff.cuni.cz> <cfd18e0f0811281340r2317a1e4y938e11da27a35558@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811281340r2317a1e4y938e11da27a35558@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri 2008-11-28 16:40:35, Michael Kerrisk wrote:
> On Wed, Nov 26, 2008 at 12:00 PM, Pavel Machek <pavel@suse.cz> wrote:
> >> On Wed, 26 Nov 2008 17:15:24 +0100
> >> Pavel Machek <pavel@suse.cz> wrote:
> >>
> >> > +How to use /sys/class/rtc/rtcX/wakealarm
> >> > +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >> > +This file takes the seconds since epoch to enable a wake event at the
> >> > +specified time.
> >>
> >> More documentation is cool.  In this case, though, I'm left with an
> >> immediate question: *why* am I interested in wakealarm?  Reading
> >> through, I eventually figure out that it can maybe be used to get a
> >> system to start up at some point in the future, maybe.  It seems like
> >> that should be said at the outset.
> >
> > You can suspend/power down your machine, and it will power itself up
> > at appropriate time.
> >
> >> Also; why do I want to migrate from /proc/acpi/alarm?
> >
> > Because /proc/acpi/alarm is ugly hack that is going to go away :-).
> 
> And these are the statements that (in slightly more polished terms)
> should be in your doc ;-), in order to address Jonathan's quite
> reasonable questions.

I'm bad at polishing, but I'll add short explanation.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
