Return-Path: <linux-kernel-owner+w=401wt.eu-S1765562AbXEYTqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765562AbXEYTqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbXEYTqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:46:08 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755811AbXEYTqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:46:06 -0400
Date: Fri, 25 May 2007 12:45:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups, #2
In-Reply-To: <20070525191447.GA19412@elte.hu>
Message-ID: <alpine.LFD.0.98.0705251238440.26602@woody.linux-foundation.org>
References: <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu>
 <20070525094640.GL8094@one.firstfloor.org> <20070525101248.GA7547@elte.hu>
 <20070525112020.GN8094@one.firstfloor.org> <20070525112600.GA27007@elte.hu>
 <20070525115004.GA4574@elte.hu> <20070525115544.GP8094@one.firstfloor.org>
 <20070525120228.GA7186@elte.hu> <alpine.LFD.0.98.0705250946120.26602@woody.linux-foundation.org>
 <20070525191447.GA19412@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Ingo Molnar wrote:
> 
> sure enough, i'll work something sane out - i already have it partly 
> split up. It will probably be something along the lines of: 'remove 
> stuff that we can remove and still have functional scheduling' followed 
> by an 'add minimal CFS patch' and then nicely split up 'CFS related 
> add-ons' (like the task-stats accounting things, debugging, etc).

Ok, that sounds good. Some of that is obviously already in separate files 
already, even if they then just get #include'd into the main sched.c, so 
yeah, splitting it up along those lines makes sense.

> Do you think i should try to split up the core CFS bits some more beyond 
> this level? (that would be quite nontrivial i suspect)

I'd love to see some of that too, but I suspect that with something like 
the scheduler, it's hard to have any reasonable (and working!) points that 
make much sense. At some point, the changes to make it work incrementally 
get bigger than the patches themselves, and rather than show what's going 
on, it might _hide_ what's going on.

		Linus
