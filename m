Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab0CJO2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:28:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40643 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab0CJO2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:28:41 -0500
Date: Wed, 10 Mar 2010 15:28:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] perf updates
Message-ID: <20100310142826.GA7848@elte.hu>
References: <1267826147-6613-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267826147-6613-1-git-send-regression-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> - Lock events seem to be usable now with perf
> - Better performances in x86-64 stacktraces
> - Trace events now have correct callchains
> - Cleanups
> 
> 
> Other patches still in discussion are not in the branch.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (5):
>       lockdep: Move lock events under lockdep recursion protection
>       perf/x86-64: Use frame pointer to walk on irq and process stacks
>       perf: Introduce new perf_fetch_caller_regs() for hot regs snapshot
>       perf: Take a hot regs snapshot for trace events
>       perf: Drop the obsolete profile naming for trace events
> 
> 
>  arch/x86/kernel/cpu/perf_event.c   |   12 +++
>  arch/x86/kernel/dumpstack.h        |   15 +++
>  arch/x86/kernel/dumpstack_64.c     |    4 +-
>  include/linux/ftrace_event.h       |   23 +++--
>  include/linux/perf_event.h         |   42 +++++++++-
>  include/linux/syscalls.h           |   24 +++---
>  include/trace/ftrace.h             |   44 +++++-----
>  include/trace/syscall.h            |    8 +-
>  kernel/lockdep.c                   |    9 +--
>  kernel/perf_event.c                |   18 ++--
>  kernel/trace/Makefile              |    2 +-
>  kernel/trace/trace_event_perf.c    |  165 ++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_event_profile.c |  164 -----------------------------------
>  kernel/trace/trace_events.c        |    2 +-
>  kernel/trace/trace_kprobe.c        |   29 +++---
>  kernel/trace/trace_syscalls.c      |   72 ++++++++--------
>  16 files changed, 353 insertions(+), 280 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
