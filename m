Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbXDPG1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbXDPG1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbXDPG1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:27:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbXDPG1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:27:05 -0400
Date: Mon, 16 Apr 2007 08:27:04 +0200
From: Nick Piggin <npiggin@suse.de>
To: Matthew Hawkins <darthmdh@gmail.com>
Cc: linux-kernel@vger.kernel.org, ck list <ck@vds.kolivas.org>
Subject: Re: [ck] Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416062704.GC2659@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <Pine.LNX.4.64.0704151054080.5473@woody.linux-foundation.org> <6741477B-4621-4A50-952E-0D03260D9526@lundell-bros.com> <200704160852.34241.kernel@kolivas.org> <20070416022838.GA13626@wotan.suse.de> <b21f8390704152257v1d879cc3te0cfee5bf5d2bbf3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b21f8390704152257v1d879cc3te0cfee5bf5d2bbf3@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 03:57:54PM +1000, Matthew Hawkins wrote:
> On 4/16/07, Nick Piggin <npiggin@suse.de> wrote:
> >
> >So, on to something productive, we have 3 candidates for a new scheduler
> >so
> >far. How do we decide which way to go? (and yes, I still think switchable
> >schedulers is wrong and a copout)
> 
> 
> I'm with you on that one.  It sounds good as a concept however there's
> various kernel structures etc that simply cannot be altered at runtime,
> which throws away the only advantage I can see of plugsched - a test/debug
> framework.
> 
> I think the best way is for those working on this stuff to keep producing
> their separate patches against mainline and people being encouraged to
> test.  THEN
> (and here comes the fun part) subsystem maintainers have to be prepared to
> accept code that is not their own or that of their IRC buddies.  I'm
> noticing this disturbing trend that Linux kernel development is becoming
> more and more like BSD where only the elite few ever get anywhere.  Con
> Kolivas, having a medical not CS degree, bruises the egos of those with CS
> degrees when he comes up with fairly clean, working, and widely-tested
> implementations of things like the staircase scheduler, R(SD)L, SCHED_ISO,
> swap prefetch, etc. when they can't.  We should be encouraging guys like

The thing is, it is really hard for anybody to change anything in page
reclaim or CPU scheduler. A few people saying a change is good for them
doesn't really mean anything because of the huge amount of diversity in
usages.

I've got my own CPU scheduler for 4 years and I and a few others think
it is better than mainline. I've tried to make many many VM changes
that haven't gone in.

Add to that, I don't actually know or care what sort of education most
kernel hackers have. I do know at least one of the more brilliant ones
does not have a CS degree, and I was able to get quite a few things in
before I had a degree (eg. rewrote IO scheduler and multiprocessor
CPU scheduler).


> It's all about the patches, baby

I don't know what would give anyone the idea that it isn't... patches
and numbers.

Nick
