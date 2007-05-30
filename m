Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXE3ViY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXE3ViY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbXE3ViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:38:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59686 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbXE3ViE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:38:04 -0400
Date: Wed, 30 May 2007 23:37:55 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Richard Purdie <rpurdie@rpsys.net>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
In-Reply-To: <1180542740.5835.135.camel@localhost.localdomain>
Message-ID: <alpine.LRH.0.98.0705302334580.22353@twin.jikos.cz>
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz> 
 <alpine.LRH.0.98.0705292312150.22353@twin.jikos.cz> 
 <1180474885.5822.94.camel@localhost.localdomain> 
 <d120d5000705300756t24d4a58ey1f4130bef22f8309@mail.gmail.com>
 <1180542740.5835.135.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 30 May 2007, Richard Purdie wrote:
> On Wed, 2007-05-30 at 10:56 -0400, Dmitry Torokhov wrote:
>> Do you think it makes sense to split the driver (and Kconfig options)
>> between input and leds directories as Jan had done? I know that I
>> prefer to keep anything input related in input directory because it
>> makes my life as maintainer easier and I bet you prefer the same but
>> it does not always work well for multifunction devices or devices
>> using several subsystems...
>
> In ideal world having the code in drivers/leds would be preferred but if
> you want to add the LED code directly to the input driver in this case I
> have no objection and it probably makes sense. The LED code is already
> spread about a bit anyway...

I wasn't happy about having this splited in two subsystems either. So I'll 
rewrite it to use led functionality directly from drivers/input/joystick/xpad.c.

Thanks for comments
Jan
