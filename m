Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbYGOCWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbYGOCWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYGOCW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:22:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560AbYGOCWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:22:25 -0400
Date: Mon, 14 Jul 2008 19:22:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stoyan Gaydarov <stoyboyker@gmail.com>
cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       gorcunov@gmail.com, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
In-Reply-To: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Stoyan Gaydarov wrote:
> 
> Second I wanted to talk about the linux 2.7.x kernel, whats in the
> making or maybe even not started

Nothing.

I'm not going back to the old model. The new model is so much better that 
it's not even worth entertaining as a theory to go back.

That said, I _am_ considering changing just the numbering. Not to go back 
to the old model, but because a constantly increasing minor number leads 
to big numbers. I'm not all that thrilled with "26" as a number: it's hard 
to remember.

So I would not dismiss (and have been thinking about starting) talk about 
a simple numbering reset (perhaps yearly), but the old model of 3-year 
developement trees is simply not coming back as far as I'm concerned.

In fact, I think the time-based releases (ie the "2 weeks of merge window 
until -rc1, followed by roughly two months of stabilization") has been so 
successful that I'd prefer to skip the version numbering model too. We 
don't do releases based on "features" any more, so why should we do 
version _numbering_ based on "features"?

For example, I don't see any individual feature that would merit a jump 
from 2.x to 3.x or even from 2.6.x to 2.8.x. So maybe those version jumps 
should be done by a time-based model too - matching how we actually do 
releases anyway.

So if the version were to be date-based, instead of releasing 2.6.26, 
maybe we could have 2008.7 instead. Or just increment the major version 
every decade, the middle version every year, and the minor version every 
time we make a release. Whatever.

But three-year development trees with a concurrent stable tree? Nope. Not 
going to happen.

		Linus
