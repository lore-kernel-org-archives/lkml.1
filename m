Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbYB2FgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbYB2FgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYB2FgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:36:12 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:38269 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751909AbYB2FgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:36:11 -0500
Date: Fri, 29 Feb 2008 11:06:05 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: David Wilder <dwilder@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       systemtap@sourceware.org, prasadav@us.ibm.com, hch@infradead.org
Subject: Re: [PATCH 0/3] A kernel tracing interface
Message-ID: <20080229053605.GA10497@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1204065517.26964.14.camel@lc4eb748232119.ibm.com> <20080228020437.8f99f646.akpm@linux-foundation.org> <47C70E25.5020708@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C70E25.5020708@us.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 11:40:21AM -0800, David Wilder wrote:
> Andrew Morton wrote:
> >On Tue, 26 Feb 2008 14:38:37 -0800 "David J. Wilder" <dwilder@us.ibm.com> 
> >wrote:
> >
> >>These patches provide a kernel tracing interface called "trace".
> >>
> >>ChangeLog:
> >>-Updated to 2.6.25-rc2-mm1
> >>-Removed sem_watch example, to hard to maintain.
> >>-Added a new example that demonstrates per-cpu continuous tracing
> >> of data generated using marker probes.
> >>-Removed inline from relay patch.
> >>-Moved examples into /sample directory.
> >>
> >>The motivation for "trace" is to:
> >>- Provide a simple set of tracing primitives that will utilize the high-
> >>  performance and low-overhead of relayfs for passing traces data from
> >>  kernel to user space.
> >>- Provide a common user interface for managing kernel traces.
> >>- Allow for binary as well as ascii trace data.
> >>- Incorporate features from the systemtap runtime that are
> >>  useful to others.
> >
> >So... what's the story on this versus lttng?
> 
> Trace is simpler to use and a smaller bit of code than lttng.
> It may not have all the features of lttng but it is good starting point 
> that can be expanded upon.  I have several users of trace that just 
> wanted a simple way to get data out of the kernel without the overhead 
> of lttng trace is working well for them.  Trace also works well with 
> markers and kprobes.  For example systemtap is is using the basic trace 
> code to gather data from kprobes and markers.
> >
> >Is there some userspace code available for people to test this?  Maybe it's
> >mentioned and I missed it.
> 
> I purposely designed trace so no special user code is required to gather 
> trace data. Standard user utilities like cat, grep, sort and more is all 
> that is needed.  I show an example in /samples/trace/fork_trace.c.
> 
> However since trace uses relay as its transport any user interfaces 
> provided by relay can be used to read trace data. (documented in 
> /Documentation/relay.txt)
> 
> >
> >It'd be interesting to see a writeup of the proposed kernel<->userspace
> >interfaces.  I see a description of kernel-internal interfaces, but how do
> >users use it?
> 
> I will add some text in the documentation.
> >
> >I see it uses things from blktrace.  Can blktrace be switched over to being
> >a client of this code?
> 
> yep.
>
Dave,
	I might also want to add to the discussion by stating that you
will find a user for the 'trace' infrastructure in the marker handler 
code of the proposed markers for futex subsystem. I hope to post the 
patches soon to the community.

Thanks,
K.Prasad
 
