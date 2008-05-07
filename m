Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbYEGDpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbYEGDpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYEGDpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:45:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbYEGDpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:45:42 -0400
Date: Tue, 6 May 2008 20:44:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: menage@google.com, seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Max Krasnyanskiy <maxk@qualcomm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Rientjes <rientjes@google.com>
Subject: Re: Reverting per-cpuset "system" (IRQ affinity) patch (was: Fix
 cpuset sched_relax_domain_level control file)
Message-Id: <20080506204444.f4c38d0a.akpm@linux-foundation.org>
In-Reply-To: <20080506223859.0b4fa876.pj@sgi.com>
References: <48210101.1070205@google.com>
	<20080506183138.546f42d9.akpm@linux-foundation.org>
	<20080506204054.564fff32.pj@sgi.com>
	<20080506223859.0b4fa876.pj@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 22:38:59 -0500 Paul Jackson <pj@sgi.com> wrote:

> pj wrote:
> > What's the easiest way to get from where we are now, to a world
> > without that patch?
> 
> Would it help, Andrew, if I proposed a patch that went into your latest
> mmtom stack, right after the three patches:
> 
>   origin.patch
>   linux-next.patch
>   Paul Menage's latest "Fix cpuset sched_relax_domain_level control file"
> 
> that reverted the cpuset "system" patch (this being a patch that added
> a per-cpuset file called "system", which could be used to do things
> such as help manage the assignment of IRQs to CPUs.)
> 
> I suspect that some of Ingo, Max Krasnyanskiy, or Peter Zijlstra will
> not be happy with my doing this, but I'm pretty sure that the "system"
> patch needs more work before we have agreement on the API.  I really
> don't want to add the API of that current patch "as is" to the kernel.
> 
> I've added several of the people who were part of the preceding threads
> on this discussion to the CC list.
> 
> I'm cooking up such a patch now -- I've gotten to the point that it
> applies and builds; now I am about to see how badly it breaks the
> remaining 426 patches in the mmtom stack.

Don't worry about it.  I sorted out things locally and I expect that
Stephen will be able to as well.  Hopefully Ingo will toss the whole patch
series so we can take another look at it all.


