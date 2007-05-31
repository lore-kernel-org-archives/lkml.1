Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbXEaPxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbXEaPxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbXEaPxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:53:47 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50910 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbXEaPxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:53:46 -0400
Date: Thu, 31 May 2007 17:53:18 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: rpurdie@rpsys.net, dtor@mail.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
In-Reply-To: <20070531140715.GA5943@ucw.cz>
Message-ID: <alpine.LRH.0.98.0705311740520.22353@twin.jikos.cz>
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz>
 <20070531140715.GA5943@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 31 May 2007, Pavel Machek wrote:
>> Led subsystem allows us to set brightness, but there is
>> nothing like brightness on this device. So brightness is
>> actually interpreted as the command (only values between
>> 0 and 14 are accepted).
>
> Ugh, no, I do not think we want to do that.

finally! I was surprised that it took so long before someone made objection to 
this.
I agree that interpreting brightness as command isn't nice. But what other 
options do I have?
  a) Do not use led subystem, and do everything on my own
  b) Do not allow user to change state of leds on this device
  c) Extend led subsystem to have something like command. But it is in 
contradiction with desired simplicity of led sybsystem.
  d) Control leds via force feedback effect
  e) Make 4 leds available and use brightness 0 for off and 255 for on. But only 
one of them can be active at one time. And I'll give up some flashing effects.

Well actually I don't like this options. Any suggestions? Thanks!

Jan

