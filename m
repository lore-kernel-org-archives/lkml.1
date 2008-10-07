Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbYJGS50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbYJGS50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYJGS5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:57:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52334 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYJGS5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:57:17 -0400
Date: Tue, 7 Oct 2008 20:58:46 +0200
From: Pavel Machek <pavel@suse.cz>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH V3] led: Backlight trigger for led subsystem
Message-ID: <20081007185846.GA6604@elf.ucw.cz>
References: <1223374230-18413-1-git-send-email-giometti@enneenne.com> <20081007135420.GB1592@ucw.cz> <20081007152032.GH13035@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007152032.GH13035@tekkaman>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-07 17:20:32, Rodolfo Giometti wrote:
> On Tue, Oct 07, 2008 at 03:54:20PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > This patch set adds a new led trigger which emulates the backlight
> > > behaviour: the leds are turned off and on each time the display blanks
> > > and unblacks.
> > > 
> > > Since backlights are usually implemented with leds this patch set is
> > > useful for those drivers whose manage leds controller used as
> > > backlight controller.
> > > 
> > > The driver simply registers itself into the led subsystem and then the
> > > user may get backlight emulation by setting the "backlight"
> > > trigger. Moreover a driver, which usually manages more than one led,
> > > can use some leds as "led" and the others as "backlights" at user
> > > request.
> > 
> > We already have backlight subsystem, it can also handle display
> > brightness. Why not use that?
> 
> Just to use a led as "led" or as "backlight" at user request. You can
> do it by using:
> 
>    echo none > /sys/class/leds/lcd/trigger
>    echo backlight > /sys/class/leds/lcd/trigger
> 
> and the led will work accordingly.
> 
> Also a led used as "backlight" is just a normal led (you can set the
> brightness as a normal led) but it switchs off automatically when the
> LCD blanks.

Ok, what is it good for? So I have backlight, charging led and hdd led
on my zaurus. Now I can set charging led to indicate backlight... but
why is it useful?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
