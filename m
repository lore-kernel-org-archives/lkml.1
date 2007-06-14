Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbXFNEjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbXFNEjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 00:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbXFNEjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 00:39:45 -0400
Received: from barikada.upol.cz ([158.194.242.200]:49192 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbXFNEjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 00:39:44 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
In-Reply-To: <4637B6B5.5060502@zytor.com>
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org> <4637B6B5.5060502@zytor.com>
Date: Thu, 14 Jun 2007 06:51:55 +0200
Message-Id: <E1HyhJM-00045g-09@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* From: "H. Peter Anvin"
* Date: Tue, 01 May 2007 14:52:53 -0700
>
> Linus Torvalds wrote:
>> 
>> And yes, I'm literally talking about the *text* modes. Not all of us want 
>> to have fbcon built in - I prefer my text-mode lean and mean and fast as 
>> hell, and if I want a frame buffer, I'll take X11, thank you very much.
>> 
>
> I use framebuffer console pretty much for one purpose -- it sucks less
> memory bandwidth when you're stuck with a UMA configuration.  Text modes
> require random access to the font buffer, which means it hogs the DRAM
> pretty badly, unless the chipset designer decided to burn an 8K SRAM,
> which is still a pretty pricey hunk of chip real estate.

When i first booted new Intel dualcore PC with

04:00.0 VGA compatible controller: ATI Technologies Inc RV370 [Sapphire X550 Silent]

back in November i discovered, that graphic/BIOS and normal text mode
aren't working right from power-on. I.e. it is with snow and random
switch on/off behavior, unless you do some reset button pushing.

Even after that is OK, shiny new 19" LCD from Sony with black screen and
glass in front of it in 80x25 mode shows contents in kind of unfocused
form. Yes it's because discrete pixels are not matching this legacy
resolution; standard graphic mode is so clear-cut, that i even can't
focus on it myself ;).

Thus, text mode on modern hardware isn't useable that much, only with
Terminus font it is kind of normal (kudos to Dimitar Toshkov Jekov).
But it's only option to unfortunately sucking X11, even with memory
bandwidth, you are talking about.
____
