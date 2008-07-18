Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYGRPnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYGRPnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYGRPm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:42:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYGRPm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:42:58 -0400
Message-ID: <4880B994.4050803@redhat.com>
Date: Fri, 18 Jul 2008 11:41:08 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 00/17] Tracepoints v4 for linux-next
References: <20080715222604.331269462@polymtl.ca>
In-Reply-To: <20080715222604.331269462@polymtl.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

As far as I can see, your patchset can be separated into
several series of patches. Would you think this series of
patches should be pushed at once, or could be pushed
individually?

I think it is hard to push all of them into kernel at once,
because it needs ACKs from several developers who maintain
traced subsystems.

So, I'd like to suggest you to separate series of patches,
and to push framework and instrumentation patches step by step.
What would you think about it?

Thank you,

Mathieu Desnoyers wrote:
> Hi,
> 
> Here is the newest release of the Tracepoints, following the feedback from Peter
> Zijlstra. The main change is the creation of include/trace/ as a placeholder
> from tracepoint headers.
> 
> The patchset applies over linux-next patch-v2.6.26-next-20080715 in this order :
> 
> #This a separate RCU update upon which the tracepoints depend
> rcu-read-sched.patch
> 
> tracepoints.patch
> tracepoints-documentation.patch
> tracepoints-samples.patch
> 
> lttng-instrumentation-irq.patch
> lttng-instrumentation-scheduler.patch
> lttng-instrumentation-timer.patch
> lttng-instrumentation-kernel.patch
> 
> lttng-instrumentation-filemap.patch
> lttng-instrumentation-swap.patch
> lttng-instrumentation-memory.patch
> lttng-instrumentation-page.patch
> lttng-instrumentation-hugetlb.patch
> 
> lttng-instrumentation-net.patch
> lttng-instrumentation-ipv4.patch
> lttng-instrumentation-ipv6.patch
> 
> ftrace-port-to-tracepoints.patch
> 
> Mathieu
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com



