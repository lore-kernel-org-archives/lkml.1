Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZLIFyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZLIFyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZLIFyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:54:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43924 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbZLIFyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:54:39 -0500
Date: Wed, 9 Dec 2009 06:54:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: fix function graph tracer output
Message-ID: <20091209055417.GA2512@elte.hu>
References: <20091207201903.864817226@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207201903.864817226@goodmis.org>
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

> 
> Ingo,
> 
> This is rebased to latest Linus repo. As Jirka found, the function graph
> tracer can lose events or show incorrectly a nested function when it
> should have been a leaf. This patch series corrects the issue.
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Jiri Olsa (1):
>       tracing: Fix function graph trace_pipe to properly display failed entries
> 
> Johannes Berg (1):
>       tracing: Add full state to trace_seq
> 
> Steven Rostedt (2):
>       tracing: Add pipe_close interface
>       tracing: Buffer the output of seq_file in case of filled buffer
> 
> ----
>  include/linux/ftrace_event.h         |    1 +
>  include/linux/trace_seq.h            |    6 +-
>  kernel/trace/trace.c                 |   39 ++++++++-
>  kernel/trace/trace.h                 |    2 +
>  kernel/trace/trace_functions_graph.c |  165 +++++++++++++++++++++++++++-------
>  kernel/trace/trace_output.c          |   75 +++++++++++++---
>  6 files changed, 235 insertions(+), 53 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
