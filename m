Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXE2V36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXE2V36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbXE2V3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:29:48 -0400
Received: from twin.jikos.cz ([213.151.79.26]:51369 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbXE2V3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:29:47 -0400
Date: Tue, 29 May 2007 23:29:42 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: rpurdie@rpsys.net, dtor@mail.ru
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
In-Reply-To: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz>
Message-ID: <alpine.LRH.0.98.0705292312150.22353@twin.jikos.cz>
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
   I have question, probably for Richard. Why is 
/sys/class/leds/whatsoever/brightness mode set to 0644? Is it really necessary?
I feel like I'll be happy to allow anybody to change the state of this led. (Ok 
this maybe doesn't apply to other leds)

> So this patch uses led subystem in such way that it makes led in
> /sys/class/leds/xpad:[0-9][0-9]/ for each attached xbox 360 pad.
>

I have the impression that the led subsystem doesn't actually count with 
possibility to have more then one device of one type, right? In my case there 
can by lots of pads, so I made it on my own, using counter. Is it ok?

Thanks
Jan Kratochvil
