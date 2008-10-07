Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYJGPU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYJGPU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYJGPUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:20:48 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:33157 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYJGPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:20:47 -0400
Date: Tue, 7 Oct 2008 17:20:32 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Message-ID: <20081007152032.GH13035@tekkaman>
References: <1223374230-18413-1-git-send-email-giometti@enneenne.com> <20081007135420.GB1592@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007135420.GB1592@ucw.cz>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH V3] led: Backlight trigger for led subsystem
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 03:54:20PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This patch set adds a new led trigger which emulates the backlight
> > behaviour: the leds are turned off and on each time the display blanks
> > and unblacks.
> > 
> > Since backlights are usually implemented with leds this patch set is
> > useful for those drivers whose manage leds controller used as
> > backlight controller.
> > 
> > The driver simply registers itself into the led subsystem and then the
> > user may get backlight emulation by setting the "backlight"
> > trigger. Moreover a driver, which usually manages more than one led,
> > can use some leds as "led" and the others as "backlights" at user
> > request.
> 
> We already have backlight subsystem, it can also handle display
> brightness. Why not use that?

Just to use a led as "led" or as "backlight" at user request. You can
do it by using:

   echo none > /sys/class/leds/lcd/trigger
   echo backlight > /sys/class/leds/lcd/trigger

and the led will work accordingly.

Also a led used as "backlight" is just a normal led (you can set the
brightness as a normal led) but it switchs off automatically when the
LCD blanks.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
