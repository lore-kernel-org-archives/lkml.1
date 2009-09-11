Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZIKUiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZIKUiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZIKUiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:38:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45287 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZIKUiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:38:15 -0400
Date: Fri, 11 Sep 2009 22:38:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/6] [GIT PULL] tracing: more updates
Message-ID: <20090911203807.GA9420@elte.hu>
References: <20090911193153.444303577@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911193153.444303577@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/core3 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core3
> 
> 
> Steven Rostedt (3):
>       tracing: move tgid out of generic entry and into userstack
>       tracing: add lock depth to entries
>       tracing: consolidate code between trace_output.c and trace_function_graph.c
> 
> jolsa@redhat.com (3):
>       tracing: create generic trace parser
>       tracing: trace parser support for set_event
>       tracing: trace parser support for function and graph
> 
> ----
>  include/linux/ftrace_event.h         |    2 +-
>  kernel/trace/ftrace.c                |  150 +++++++++-------------------------
>  kernel/trace/trace.c                 |  117 +++++++++++++++++++++++++-
>  kernel/trace/trace.h                 |   36 ++++++++
>  kernel/trace/trace_events.c          |   64 ++++-----------
>  kernel/trace/trace_functions_graph.c |   26 ++-----
>  kernel/trace/trace_output.c          |   42 ++++++++--
>  kernel/trace/trace_output.h          |    2 +
>  8 files changed, 246 insertions(+), 193 deletions(-)

Pulled, thanks Steve!

	Ingo
