Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZHLOiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZHLOiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZHLOiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:38:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56947 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbZHLOiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:38:14 -0400
Date: Wed, 12 Aug 2009 10:37:02 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [GIT PULL] tracing: Syscalls trace events + perf support
Message-ID: <20090812143702.GC2711@redhat.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <20090812091133.GA21655@elte.hu> <20090812110307.GA806@elte.hu> <20090812111436.GA24263@elte.hu> <20090812142516.GB2711@redhat.com> <20090812142917.GA19882@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812142917.GA19882@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 04:29:17PM +0200, Ingo Molnar wrote:
> * Jason Baron <jbaron@redhat.com> wrote:
> 
> > On Wed, Aug 12, 2009 at 01:14:36PM +0200, Ingo Molnar wrote:
> 
> > > another thing: could we please also have a generic, highlevel 
> > > tracepoint (in addition to the specific tracepoints) that 
> > > enumerates the raw syscall Nr and the parameters it gets - in a 
> > > single tracepoint?
> > 
> > The specific tracepoints, are all layered on 2 (entry, exit) 
> > generic tracepoints already. So this shouldn't be too hard...The 
> > parameters it gets might be tricky, since there are a variable 
> > number b/w different syscalls?
> 
> We should just list all ~6 of them. It's up to the sampling entity 
> to decide which ones (if any) is relevant.
> 
> At least on x86 the syscall arguments will always have a value when 
> the syscall entry code is called. (they are in GP registers)
> 
> 	Ingo

ok, makes sense. I'll add to the todo list.

-Jason


