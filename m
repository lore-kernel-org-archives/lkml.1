Return-Path: <linux-kernel-owner+w=401wt.eu-S965983AbYD1Sg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965983AbYD1Sg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933293AbYD1Sgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:36:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933131AbYD1Sgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:36:47 -0400
Date: Mon, 28 Apr 2008 11:36:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/37] Linux Kernel Markers instrumentation for
 sched-devel.git
Message-Id: <20080428113610.b2d1e8e4.akpm@linux-foundation.org>
In-Reply-To: <1209238735.6441.4.camel@lappy>
References: <20080424150324.802695381@polymtl.ca>
	<1209238735.6441.4.camel@lappy>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2008 21:38:54 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2008-04-24 at 11:03 -0400, Mathieu Desnoyers wrote:
> > Hi Ingo,
> > 
> > Here is a rather large patchset applying kernel instrumentation to
> > sched-devel.git. It includes, mainly :
> 
> I saw this land in sched-devel, how about this:
> 
> ---
> Subject: sched: de-uglyfy marker impact
> 
> These trace_mark() things look like someone puked all over the code,

lol.

> lets hide the ugly bits.

It hides the cosmetically-ugly bits, but not the deeply ugly: each of these
trace points is an extension to the kernel->userspace API, with all that
this implies.

> +static inline
> +void trace_kernel_sched_wakeup(struct rq *rq, struct task_struct *p)

When doing this please put the newline immediately preceding the function
name.  Putting it between the `inline' and the return-type-declaration is
weird.


