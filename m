Return-Path: <linux-kernel-owner+w=401wt.eu-S965069AbXBEXcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069AbXBEXcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965114AbXBEXcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:32:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39012 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965069AbXBEXct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:32:49 -0500
Date: Mon, 5 Feb 2007 15:32:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1170717694.29759.941.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702051525320.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> 
 <20070205084523.GA21858@elte.hu>  <1170682488.29759.795.camel@pmac.infradead.org>
  <20070205155627.GA8354@elte.hu>  <1170692539.29759.856.camel@pmac.infradead.org>
  <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> 
 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> 
 <1170710272.29759.894.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org> 
 <1170711587.29759.909.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> 
 <1170712393.29759.925.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org> 
 <20070205143110.fca62b57.randy.dunlap@oracle.com> 
 <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
 <1170717694.29759.941.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, David Woodhouse wrote:
> 
> The netfilter example is totally irrelevant here, since 'select' is
> neither necessary nor sufficient for that. Russell and I have both
> pointed that out to you already.

No, the example IS relevant.

Why?

Because you don't seem to be getting the whole "be nice" part.

You continually argue as if being nice isn't an issue, and shouldn't be 
even an option.

And maybe you can do it without select for netfilter, but you sure as HELL 
cannot do it for things like SCSI and the USB/ATA question.

So you keep on ignoring the real argument, by belittling it.

You talk about "Aunt Tillie".

Don't talk about Aunt Tillie. Dammit! Talk about ME!

And talk about the kinds of people we *want* to compile the kernel: people 
who may be entirely regular users, but people who want to help us debug 
things by testing the -rc1 release.

Those people are IMPORTANT. You belittling the whole concept just makes 
you look like an ass.

> Not only does that not work like it always did, but it's also _really_
> hard to find out why, on occasion.

And I told you that you could just improve the tools that track those 
dependencies ANYWAY!

But what do you do? You just ignore it, talk about sed/grep, and bring up 
your Aunt Tillie again.

Guess what? Maybe Aunt Tillie really *could* compile her own kernel.

But even more importantly, you have both the expertise and the knowledge 
to make _your_ gripes go away, without having to just belittle and ignore 
everybody elses concerns.

In other words, just make xconfig/gconfig/menuconfig/whatever say "Oops, 
I'm not going to disable i2c because of the following dependency: ..."
and what is your problem?

And don't tell me about Aunt Tillie or about how you refuse to do anything 
but grep's and sed's. If THAT is your problem, then you're barking up the 
wrong tree.

		Linus
