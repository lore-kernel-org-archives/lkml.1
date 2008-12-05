Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYLENtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYLENtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYLENs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:48:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50755 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYLENs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:48:58 -0500
Date: Fri, 5 Dec 2008 14:48:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing/ftrace: fix the check of ftrace_trace_task
Message-ID: <20081205134854.GB27039@elte.hu>
References: <49385E8B.7070900@gmail.com> <alpine.DEB.1.10.0812041801480.32726@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812041801480.32726@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 4 Dec 2008, Frederic Weisbecker wrote:
> 
> > Impact: fix default empty traces on function-graph-tracer
> > 
> > The actual ftrace_trace_task() checks if ftrace_pid_trace is 
> > allocated and return 1 if it is true. If it is NULL, it will check 
> > the bit of pid tracing flag for the current task (which are not set 
> > by default). So by default, a task is not traced. Actually all tasks 
> > should be traced by default and filter_by_pid when ftrace_pid_trace 
> > is allocated.
> 
> Heh, I thought my output look funny. The function tracer does not use 
> it since it registers a different function. But because the graph 
> tracer only shows the current task on switch (I did not look into trace 
> options) I could not really test it well.
> 
> -- Steve
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>

applied to tip/tracing/ftrace, thanks!

	Ingo
