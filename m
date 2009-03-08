Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZCHPmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZCHPmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZCHPmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:42:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39614 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbZCHPmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:42:08 -0400
Date: Sun, 8 Mar 2009 16:41:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for tip] ftrace: remove latency_trace document
Message-ID: <20090308154151.GC19658@elte.hu>
References: <20090307235209.5A84.A69D9226@jp.fujitsu.com> <20090307153427.GA6075@nowhere> <2f11576a0903071926u3eeb793fx44300a0257439535@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0903071926u3eeb793fx44300a0257439535@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 2009/3/8 Frederic Weisbecker <fweisbec@gmail.com>:
> > On Sat, Mar 07, 2009 at 11:53:40PM +0900, KOSAKI Motohiro wrote:
> >> Subject: [PATCH] remove latency_trace document
> >>
> >> Currently, there aren't "Latency tracer" and latency_trace file.
> >> Then, its documentation is removed too.
> >
> > Hi,
> >
> > The latency_trace file has been removed but the latency tracing stil exists.
> > It has become an option instead of a file now:
> >
> > echo latency-format > /debugfs/tracing/trace_options
> >
> > There are even some tracers that default enable it (irqsoff, preemptoff...)
> > IMO, the documentation about latency tracing shouldn't be removed but
> > just updated a bit to reflect this change.
> 
> Ah, sorry.
> I totally misunderstood it.
> 
> thanks to correct my fault.

You are correct to point out that the documentation about 
latency tracing does need to be updated - as there's no 
latency_trace file anymore and we reference it in a few places:

Documentation/ftrace.txt:  latency_trace:
Documentation/ftrace.txt:	is retrieved. Unlike the "trace" and "latency_trace"
Documentation/ftrace.txt:	"latency_trace" files are static, and if the
Documentation/ftrace.txt:	"trace" or "latency_trace".  A new max trace will
Documentation/ftrace.txt:	trace via the latency_trace file.
Documentation/ftrace.txt:For traces that display latency times, the latency_trace file
Documentation/ftrace.txt:	latency_trace file is relative to the start of the trace.
Documentation/ftrace.txt:  verbose - This deals with the latency_trace file.
Documentation/ftrace.txt:		trace,trace_pipe,latency_trace. Example:
Documentation/ftrace.txt: # cat /debug/tracing/latency_trace
Documentation/ftrace.txt: # cat /debug/tracing/latency_trace
Documentation/ftrace.txt: # cat /debug/tracing/latency_trace
Documentation/ftrace.txt: # cat /debug/tracing/latency_trace

	Ingo
