Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100Ab0AMI0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab0AMI0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084Ab0AMI0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:26:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60713 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab0AMI0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:26:30 -0500
Date: Wed, 13 Jan 2010 09:26:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/11][GIT PULL] tracing: various updates for 2.6.34
Message-ID: <20100113082619.GA23541@elte.hu>
References: <20100106231349.107649729@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106231349.107649729@goodmis.org>
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
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Lai Jiangshan (7):
>       tracing: Have __dynamic_array() define a field
>       tracing: Add print_fmt field
>       tracing/syscalls: Init print_fmt for syscall events
>       tracing/kprobes: Init print_fmt for kprobe events
>       tracing: Use defined fields and print_fmt to print formats
>       tracing: Remove show_format and related macros from TRACE_EVENT
>       tracing: Consolidate protection of reader access to the ring buffer
> 
> Steven Rostedt (2):
>       tracing: Have syscall tracing call its own init function
>       tracing: Add stack dump to trace_printk if stacktrace option is set
> 
> Wolfram Sang (2):
>       tracing: optimize recordmcount.pl for offsets-handling
>       tracing: Use appropriate perl constructs in recordmcount.pl
> 
> ----
>  include/linux/ftrace_event.h  |    3 +-
>  include/linux/syscalls.h      |    6 +-
>  include/trace/ftrace.h        |  161 +++++++++--------------------------------
>  include/trace/syscall.h       |    4 -
>  kernel/trace/trace.c          |  144 ++++++++++++++++++++++++++-----------
>  kernel/trace/trace_events.c   |   77 +++++++++++---------
>  kernel/trace/trace_export.c   |   87 ++++-------------------
>  kernel/trace/trace_kprobe.c   |  104 +++++++++++---------------
>  kernel/trace/trace_syscalls.c |  106 ++++++++++++++--------------
>  scripts/recordmcount.pl       |   47 +++++-------
>  10 files changed, 310 insertions(+), 429 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
