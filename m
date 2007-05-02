Return-Path: <linux-kernel-owner+w=401wt.eu-S1767158AbXEBSa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767158AbXEBSa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767159AbXEBSa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:30:27 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39697 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767158AbXEBSaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:30:25 -0400
Date: Wed, 2 May 2007 20:22:23 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Rene Herman <rene.herman@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
In-Reply-To: <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0705022017360.18504@yvahk01.tjqt.qr>
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org>
 <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 1 2007 14:41, Linus Torvalds wrote:
>On Tue, 1 May 2007, Rene Herman wrote:
>> 
>> The answer will probably be "no", but would this be a good point to ask if
>> this would be a good time to not bother with the mode switching code at all
>> anymore?
>
>The standard extended modes are actually really useful, if for a very 
>simply reason: they give you bigger more lines on screen when a bug 
>happens.
>
>So I _still_ occasionally use "vga=extended" just for that reason. The  
>default 80x25 thing scrolls most oops away.
>[...]
>80x50 is useful for the above reason. Yeah, it's ugly, but it's useful for 
>the "It's too much work to try to do anything but just take a digital 
>photo of the screen". And that 50-line mode will actually be 43 in EGA 
>mode, I think.
>
>The 132x50 mode is probably a bit prettier, and is fairly common too, and 
>useful for the same reason.

Seconded. 80x50, and where platforms support it, *80x60 and 132x60*,
is kinda handy (despite the font getting smaller and smaller, heh),
esp. when you don't run it in VMware and not have some capturing
device (serial con/netconsole.. takes time to set up)

>And yes, I'm literally talking about the *text* modes. Not all of us want 
>to have fbcon built in - I prefer my text-mode lean and mean and fast as 
>hell, and if I want a frame buffer, I'll take X11, thank you very much.

You speak for me :)



Jan
-- 
