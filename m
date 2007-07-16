Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbXGPXlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbXGPXlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXGPXk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:40:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:54140 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXGPXky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DpF9gGI94CdIhVvU+RXC2VmRor+1Z1ctIrg68nK0o4AcQkoi8RQ32eqlAS8wRQ3NXOltFQqnwEqRST2oRiI7VEGgT9bLQzqLlrMjTybQnEmEJ4WxJsj3zi2ZIdyvhP3JBf71wPCLBdx9AebCHOkGxDK+NxXf1ZMbU5MwwTq2tl0=
Message-ID: <2c0942db0707161640h3c3afd7avecd7b3c61c4e7df1@mail.gmail.com>
Date: Mon, 16 Jul 2007 16:40:53 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Bodo Eggert" <7eggert@gmx.de>, "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <469BFDA7.1040204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8FO1e-2jW-35@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>
	 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>
	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	 <469BF104.1040703@gmail.com>
	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	 <469BF768.6040200@gmail.com>
	 <2c0942db0707161613lff9c07bpcf002b9139163a86@mail.gmail.com>
	 <469BFDA7.1040204@gmail.com>
X-Google-Sender-Auth: f304c82a5fef8434
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Rene Herman <rene.herman@gmail.com> wrote:
> On 07/17/2007 01:13 AM, Ray Lee wrote:
> > Given that there's actual, y'know, reports of people who can easily
> > crash a 4k+interrupt stacks kernel, and not an 8k one, I think the
> > current evidence speaks for itself.
>
> Where?

The second message in this thread, according to my reader, from Zan
Lynx. Another from Utz Lehmann a few minutes ago.

> > The point remains that the burden of proof of the safety of the 4k only
> > option is upon those people who want to remove the 8k option.
>
> Removing any such option was not the objective of this thread, just lifting
> 4K stacks from debug and making it the default.

True, but your messages are reading as advocacy for removing the 8k
option. I'm saying that's a bad idea. If I misunderstood your
position, then my bad.

> People fortunate enough to
> use workloads where some piece of crap code by accident works more often
> with the current shared 8K stacks then it does with the unshared 4K stacks
> can then still nicely not select it (or fix the code if possible).

If they even realize that it's the cause of the problem. In the
meantime, we're generating more bug reports to lkml. As the general
opinion is that the ones getting received now aren't getting enough
attention (see regression tracking threads), setting a default that is
known to break setups in hard to debug ways seems counterproductive.
