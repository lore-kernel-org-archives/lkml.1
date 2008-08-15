Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbYHOPkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbYHOPkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760206AbYHOPke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:40:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37469 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760176AbYHOPkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:40:33 -0400
Date: Fri, 15 Aug 2008 17:40:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] ftrace: dump out ftrace buffers to console on panic
Message-ID: <20080815154014.GD27955@elte.hu>
References: <alpine.DEB.1.10.0807302227320.20785@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807302227320.20785@gandalf.stny.rr.com>
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

> [
>  Changes since -v1:
>   Got alpine to send correctly (as well as spell check working).
>   Removed config option.
>   Moved the static variables into ftrace_dump itself.
>   Gave printk a log level.
> ]
> 
> At OLS I had a lot of interest to be able to have the ftrace buffers 
> dumped on panic.  Usually one would expect to uses kexec and examine 
> the buffers after a new kernel is loaded. But sometimes the resources 
> do not permit kdump and kexec, so having an option to still see the 
> sequence of events up to the crash is very advantageous.
> 
> This patch adds the option to have the ftrace buffers dumped to the 
> console in the latency_trace format on a panic. When the option is 
> set, the default entries per CPU buffer are lowered to 16384, since 
> the writing to the serial (if that is the console) may take an awful 
> long time otherwise.

we had this in the latency tracer - so it's a very useful feature. 
Applied to tip/tracing/ftrace, thanks Steve.

	Ingo
