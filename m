Return-Path: <linux-kernel-owner+w=401wt.eu-S1423691AbXEAVmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423691AbXEAVmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423699AbXEAVmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:42:20 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423691AbXEAVmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:42:18 -0400
Date: Tue, 1 May 2007 14:41:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
In-Reply-To: <4637A3F6.70508@gmail.com>
Message-ID: <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org>
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org>
 <4637A3F6.70508@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 May 2007, Rene Herman wrote:
> 
> The answer will probably be "no", but would this be a good point to ask if
> this would be a good time to not bother with the mode switching code at all
> anymore?

The standard extended modes are actually really useful, if for a very 
simply reason: they give you bigger more lines on screen when a bug 
happens.

So I _still_ occasionally use "vga=extended" just for that reason. The  
default 80x25 thing scrolls most oops away.

> I'd consider keeping anything but VESA 1.2 (which that ET4000 and most all
> other Super VGA cards of the era also do!) nonsensical and as far as I'm
> concerned this includes all the VGA modes with the strange number of lines; a
> 43/60-line VGA screen is too horrible to look at anyway...

80x50 is useful for the above reason. Yeah, it's ugly, but it's useful for 
the "It's too much work to try to do anything but just take a digital 
photo of the screen". And that 50-line mode will actually be 43 in EGA 
mode, I think.

The 132x50 mode is probably a bit prettier, and is fairly common too, and 
useful for the same reason.

And once you support those, you might as well support all the VESA text 
modes.

And yes, I'm literally talking about the *text* modes. Not all of us want 
to have fbcon built in - I prefer my text-mode lean and mean and fast as 
hell, and if I want a frame buffer, I'll take X11, thank you very much.

		Linus
