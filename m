Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYH1R1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYH1R1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYH1R1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:27:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbYH1R1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:27:34 -0400
Date: Thu, 28 Aug 2008 10:26:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
In-Reply-To: <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <200808290036.35817.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com> <200808290134.35093.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Aug 2008, Steven Rostedt wrote:
> 
> I've always thought that the policy settings belong in the distro, and the 
> kernel should never enforce a policy (by setting this as default, it is 
> enforcing a policy, even though an RT user can change it).

The kernel has always done a certain amount of "default policy". 

What do you think things like "swappiness" etc are? Or things like 
oevrcommit settings? They're all policies, and there is always a default 
one. So in that sense the kernel always has - and fundamentally _must_ - 
set some kind of policy.

And the default policy should generally be the one that makes sense for 
most people. Quite frankly, if it's an issue where all normal distros 
would basically be expected to set a value, then that value should _be_ 
the default policy, and none of the normal distros should ever need to 
worry.

Whether this case is one such, I dunno. Quite frankly, I don't think it's 
even _nearly_ important enough to get this kind of noise.

		Linus
