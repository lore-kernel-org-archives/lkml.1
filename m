Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbXDZWwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbXDZWwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXDZWwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:52:14 -0400
Received: from mail23.syd.optusnet.com.au ([211.29.133.164]:37887 "EHLO
	mail23.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755177AbXDZWwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:52:13 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Date: Fri, 27 Apr 2007 08:48:40 +1000
User-Agent: KMail/1.9.5
Cc: Redeeman <redeeman@metanurb.dk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
References: <20070425214704.GA32572@elte.hu> <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com>
In-Reply-To: <200704261041.04838.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704270848.41416.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2007 00:41, Gene Heskett wrote:
> On Thursday 26 April 2007, Redeeman wrote:
> >On Wed, 2007-04-25 at 23:47 +0200, Ingo Molnar wrote:
> ><snip>
> >
> >> As usual, any sort of feedback, bugreport, fix and suggestion is more
> >> than welcome,
> >
> >well, from my experiences with cfs on workstation/desktop, on amd64
> >2ghz, cfs doesent measure up to SD at all.
> >
> >audio skips easily, with or without reniced X, and games are not as
> >smooth. also it seems to be much lower throughput. vanilla seems much
> >better by comparisin.

That's a pretty bad regression for CFS to not even play audio without 
stuttering.

> Well, I don't generally feel as if the few stutters I just heard in a cbs
> news story I just played were anything but dsl glitches here. xmms, playing
> high quality (Q7) oggs from my own drive are dead smoothly done.  nbc did
> want to let me play anything because I have adblock enabled, and neither
> did abc but their anims played nicely, fox news smoothly played everything
> I clicked on.
>
> The only problem I've had so far is with a proprietary daemon from belkin,
> which took about 10 kills and restarts after I'd booted to 2.6.21-CFS-v6
> before it quit wanting a steady 40% of the cpu when it was running.  Now it
> only does that when the bulldog gui is running.  That's not normal either,
> but getting fixes out of belkin is like breeding elephants, lots of yelling
> and screaming and it takes 22 months to get results.  My next ups will NOT
> be a belkin.
>
> X is not reniced here, but I did run kmail up to -5.
>
> Compared to mainline?  I still think this is a 100% keeper for desktop
> users like me.

Hi Gene

Have you given up on SD testing then since it's stable and CFS is still shiny 
and new (and written by Ingo) therefore it must be better? 

-- 
-ck
