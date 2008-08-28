Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYH1SQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYH1SQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYH1SQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:16:18 -0400
Received: from mx2.compro.net ([216.54.166.4]:27444 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719AbYH1SQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:16:17 -0400
X-IronPort-AV: E=Sophos;i="4.32,287,1217822400"; 
   d="scan'208";a="2753490"
Message-ID: <48B6EB6F.2050802@compro.net>
Date: Thu, 28 Aug 2008 14:16:15 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
References: <20080819103301.787700742@chello.nl> <200808290036.35817.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com> <200808290134.35093.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com> <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 28 Aug 2008, Steven Rostedt wrote:
>> I've always thought that the policy settings belong in the distro, and the 
>> kernel should never enforce a policy (by setting this as default, it is 
>> enforcing a policy, even though an RT user can change it).
> 
> The kernel has always done a certain amount of "default policy". 
> 
> What do you think things like "swappiness" etc are? Or things like 
> oevrcommit settings? They're all policies, and there is always a default 
> one. So in that sense the kernel always has - and fundamentally _must_ - 
> set some kind of policy.
> 
> And the default policy should generally be the one that makes sense for 
> most people. Quite frankly, if it's an issue where all normal distros 
> would basically be expected to set a value, then that value should _be_ 
> the default policy, and none of the normal distros should ever need to 
> worry.
> 
> Whether this case is one such, I dunno. Quite frankly, I don't think it's 
> even _nearly_ important enough to get this kind of noise.
> 
> 		Linus

More and more are wanting and now finding the Linux kernel to be more
RT capable. I seem to remember way back you saying it was one thing 
you didn't really care much about one way or the other. Thats OK. But, 
you _are_ the man. Put an end to this. Are you going to allow the long
understood meaning of SCHED_FIFO to change in the Linux kernel 
just to protect a few _supposedly_ bad programmers???

Regards
Mark

