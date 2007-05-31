Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbXEaPdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbXEaPdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXEaPdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:33:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3494 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752734AbXEaPdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:33:37 -0400
Date: Thu, 31 May 2007 14:07:16 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jan Kratochvil <honza@jikos.cz>
Cc: rpurdie@rpsys.net, dtor@mail.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
Message-ID: <20070531140715.GA5943@ucw.cz>
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  this patch is against current input tree.
> 
> Xbox360 pad has four leds, which forms a circle. 
> Unfortunately the leds itself are not independent, and 
> we can't control them directle, but rather through 
> sending commands which have predefined meaning (like 
> turn first on, others off)
> This patch allows us to send these commands via leds 
> subsystem. Commands itself are described here: 
> http://www.free60.org/wiki/Gamepad.
> 
> Led subsystem allows us to set brightness, but there is 
> nothing like brightness on this device. So brightness is 
> actually interpreted as the command (only values between 
> 0 and 14 are accepted).

Ugh, no, I do not think we want to do that.

Devices with brightness 0 or 255 (off or on) are okay, but controlling
4 leds with one brightness is just wrong.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
