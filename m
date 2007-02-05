Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXBEXJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXBEXJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965041AbXBEXJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:09:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38289 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965034AbXBEXJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:09:35 -0500
Date: Mon, 5 Feb 2007 15:09:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <20070205143110.fca62b57.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
 <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org>
 <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org>
 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
 <1170710272.29759.894.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
 <1170711587.29759.909.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
 <1170712393.29759.925.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
 <20070205143110.fca62b57.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, Randy Dunlap wrote:
>
> I think the problem is "who is make *config" for?".

Absolutely.

> Linus wants it to be for (unadvanced) users, but they tend to just
> use distro kernels and distro configs, according to David, and I
> agree with that.

Well, the thing is, according to that logic, we might as well go back to 
the pre-Kconfig language entirely. 

I want people to feel that compiling their own kernel is *simple*.

I also feel that a lot of people are "advanced" in one area, but not 
necessarily in another. The Netfilter example I gave was one such personal 
gripe of mine. I just feel like I shouldn't need to care! Yeah, I have the 
knowledge, but I *still* want to be baby-fed with just a simple "anybody 
can understand it".

The same is true of the whole SATA/USB/SCSI thing. I know damn well that 
the kernel uses the SCSI layer for USB and SATA, yet I feel that the ATA 
layer does it right, and I just find the USB storage situation to be 
*offensively* bad in this regard. Why the HELL does it have those big 
comments and warnings, when it could just damn well enable SCSI support 
itself?

So even advanced users aren't necessarily advanced outside their own 
area of expertise (I have no clue what I2C crud I'd need for some DVB 
card or even regular video card - or even *if* I need it). And even when 
they are advanced, they don't mind simple questions.

This is not something where it's "good to be hard to use" (if those things 
even exist anywhere else either..)

> > Claiming that "select" is evil is just totally strange.
> 
> It's a real problem for developers who actually try to modify
> configs.

Why? You could *trivially* have a tool tell you. Make "xconfig" or 
something just pop up a window saying "sorry, you can't disable SCSI, 
because you've got ATA enabled, and ATA wants SCSI".

What's the big deal, here?

			Linus
