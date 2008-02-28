Return-Path: <linux-kernel-owner+w=401wt.eu-S1763004AbYB1Tls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763004AbYB1Tls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbYB1Tli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:41:38 -0500
Received: from mail.tmr.com ([64.65.253.246]:52545 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYB1Tlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:41:37 -0500
Message-ID: <47C70F41.4020406@tmr.com>
Date: Thu, 28 Feb 2008 14:45:05 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Nicholas Marquez <nicholas.marquez@gatech.edu>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] More accessible usage of custom flags
References: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com>
In-Reply-To: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Marquez wrote:
> I submitted this patch to the zen-sources Gentoo community and got
> much praise and has promptly been included.  This kind of thing have
> very likely already been done in other patchsets, but I haven't seen
> it around, so I've gone ahead and made one.  The idea is that one can
> enable -Os and various other options transparently through standard
> kernel configuration, so why bar the builder from any other options to
> pass on to gcc (et al)?  One can indeed add one's own flags in the
> Makefile, but this method is a good deal friendlier.  Granted, this
> could be misused by ricers and idiots, but they'll get themselves into
> that mess all of their own fault and we'll all go on our merry ways.
> It just seems that much use could be made out of this, both in terms
> of (sane) optimizations and easier access to enhanced debugging
> opportunities.
> 
> I see that people who build a Linux kernel are largely of two types:
> ~the ones that understand and know enough that they could, with some
> nudging and learning, become bonafide kernel devs and
> ~the ones that understand it to some very basic degree and can get
> through configuring it without too much trouble (though with limited
> understanding)
> I believe one of the very simple things that can be addressed is to
> make the kernel more "accessible" without harming its integrity or
> functionality.  This involves trying to fill the gap between those two
> types of people, allowing there to be more understanding,
> configuration, and (down the line) development opportunities within
> the kernel to better ease these people into learning enough to begin
> contributing back.  More developers can only be a Good Thing (tm).
> Though a haughty and abstract opinion/goal/thought of mine, this patch
> conforms to it and I think that with minimal effort such a vision
> could be implemented.  Whilst all other kernel devs are hacking away
> at the rough and tumultuous innards of the kernel, a few people of
> less confidence and experience (people like me) could polish the
> outside to make it more appealing to more people. So that eventually
> they too will sink below the surface and join the party.
> 
> Anyway, I'm not quite sure that my implementation is as clean as it
> could be and any feedback is certainly welcome.  This is my first time
> posting to LKML, so I fully expect to be shot down anyway.
> 
It seems to make access to these features easier, and I really don't see 
that it is going to create a higher number of posts here, the "I did X 
and..." posts might go up, and the "How do I..." post might go down, and 
I doubt either will change enough to notice.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
