Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbXE2Vll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbXE2Vll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXE2Vle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:41:34 -0400
Received: from tim.rpsys.net ([194.106.48.114]:44741 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbXE2Vle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:41:34 -0400
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
From: Richard Purdie <rpurdie@rpsys.net>
To: Jan Kratochvil <honza@jikos.cz>
Cc: dtor@mail.ru, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LRH.0.98.0705292312150.22353@twin.jikos.cz>
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz>
	 <alpine.LRH.0.98.0705292312150.22353@twin.jikos.cz>
Content-Type: text/plain
Date: Tue, 29 May 2007 22:41:25 +0100
Message-Id: <1180474885.5822.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 23:29 +0200, Jan Kratochvil wrote:
>    I have question, probably for Richard. Why is 
> /sys/class/leds/whatsoever/brightness mode set to 0644? Is it really necessary?
> I feel like I'll be happy to allow anybody to change the state of this led. (Ok 
> this maybe doesn't apply to other leds)

Permissions management of the LEDs is outside the scope of kernel. If
you need users to have access to them, change the permissions in
userspace to grant access.

> > So this patch uses led subystem in such way that it makes led in
> > /sys/class/leds/xpad:[0-9][0-9]/ for each attached xbox 360 pad.
> 
> I have the impression that the led subsystem doesn't actually count with 
> possibility to have more then one device of one type, right? In my case there 
> can by lots of pads, so I made it on my own, using counter. Is it ok?

It leaves it up to the driver concerned. In your case it makes sense so
counting is fine. Don't put the colon in though, just have it as xpad0
etc. as the name. Anything after the first colon is defined as an
optional colour (see Documentation/leds-class.txt).

Richard

