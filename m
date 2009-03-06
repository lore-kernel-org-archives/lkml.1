Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZCFKlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZCFKlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbZCFKl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:41:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37219 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbZCFKl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:41:26 -0500
Date: Fri, 6 Mar 2009 11:41:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL] for tip/tracing/ftrace
Message-ID: <20090306104106.GF31042@elte.hu>
References: <20090306031857.686507907@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306031857.686507907@goodmis.org>
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
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (3):
>       tracing: make all file_operations const
>       tracing: move print of event format to separate file
>       tracing: add format files for ftrace default entries
> 
> ----
>  kernel/trace/Makefile               |    1 +
>  kernel/trace/ftrace.c               |   10 +-
>  kernel/trace/ring_buffer.c          |    2 +-
>  kernel/trace/trace.c                |   24 +++---
>  kernel/trace/trace_event_types.h    |  165 +++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_events.c         |   12 ++-
>  kernel/trace/trace_events_stage_2.h |   53 +-----------
>  kernel/trace/trace_export.c         |   81 +++++++++++++++++
>  kernel/trace/trace_format.h         |   55 ++++++++++++
>  kernel/trace/trace_sysprof.c        |    2 +-
>  10 files changed, 329 insertions(+), 76 deletions(-)

Pulled, thanks Steve!

	Ingo
