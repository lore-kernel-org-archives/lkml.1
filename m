Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYJGNyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYJGNyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYJGNyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:54:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51302 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752865AbYJGNyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:54:31 -0400
Date: Tue, 7 Oct 2008 15:54:20 +0200
From: Pavel Machek <pavel@suse.cz>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH V3] led: Backlight trigger for led subsystem
Message-ID: <20081007135420.GB1592@ucw.cz>
References: <1223374230-18413-1-git-send-email-giometti@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223374230-18413-1-git-send-email-giometti@enneenne.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch set adds a new led trigger which emulates the backlight
> behaviour: the leds are turned off and on each time the display blanks
> and unblacks.
> 
> Since backlights are usually implemented with leds this patch set is
> useful for those drivers whose manage leds controller used as
> backlight controller.
> 
> The driver simply registers itself into the led subsystem and then the
> user may get backlight emulation by setting the "backlight"
> trigger. Moreover a driver, which usually manages more than one led,
> can use some leds as "led" and the others as "backlights" at user
> request.

We already have backlight subsystem, it can also handle display
brightness. Why not use that?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
