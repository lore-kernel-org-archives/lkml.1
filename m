Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbZLJHWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbZLJHWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbZLJHWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:22:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57460 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752AbZLJHWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:22:08 -0500
Date: Thu, 10 Dec 2009 08:20:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 0/5] [GIT PULL] tracing: Fixes for function graph and
 trace_printk
Message-ID: <20091210072059.GD16874@elte.hu>
References: <20091209204035.871524827@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209204035.871524827@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> This is a rework of the patches last sent. It is based on commit:
> 
>   c521efd1700a8c0f7ce26f011f5eaecca17fabfa
>   tracing: Add pipe_close interface
> 
> and starts with a fix to the cut and paste bug. I compiled each patch
> with and without CONFIG_TRACING enabled.
> 
> Please pull the latest tip/tracing/core3 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core3
> 
> 
> Carsten Emde (1):
>       tracing: Remove comparing of NULL to va_list in trace_array_vprintk()
> 
> Jiri Olsa (1):
>       tracing: Fix function graph trace_pipe to properly display failed entries
> 
> Johannes Berg (1):
>       tracing: Add full state to trace_seq
> 
> Steven Rostedt (2):
>       tracing: Only call pipe_close if pipe_close is defined
>       tracing: Buffer the output of seq_file in case of filled buffer
> 
> ----
>  include/linux/ftrace_event.h         |    1 +
>  include/linux/trace_seq.h            |    7 +-
>  kernel/trace/trace.c                 |   55 +++++++++--
>  kernel/trace/trace_functions_graph.c |  165 +++++++++++++++++++++++++++-------
>  kernel/trace/trace_output.c          |   75 +++++++++++++---
>  5 files changed, 243 insertions(+), 60 deletions(-)

Pulled, thanks Steve!

	Ingo
