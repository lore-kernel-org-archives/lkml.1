Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721Ab0A2HHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab0A2HHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893Ab0A2HHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:07:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab0A2HHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:07:23 -0500
Date: Fri, 29 Jan 2010 08:06:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [GIT PULL] perf events updates
Message-ID: <20100129070651.GA14636@elte.hu>
References: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
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
> Thanks,
> 	Frederic
> ---
> 
> K.Prasad (2):
>       x86/debug: Clear reserved bits of DR6 in do_debug()
>       x86/hw-breakpoints: Optimize return code from notifier chain in hw_breakpoint_handler
> 
> Xiao Guangrong (2):
>       perf: Factorize trace events raw sample buffer operations
>       tracing/kprobe: Cleanup unused return value of tracing functions
> 
> Anton Blanchard (1):
>       perf: Fix inconsistency between IP and callchain sampling
> 
> 
>  arch/powerpc/kernel/perf_callchain.c |    3 -
>  arch/sh/kernel/perf_callchain.c      |    3 -
>  arch/x86/include/asm/debugreg.h      |    3 +
>  arch/x86/kernel/cpu/perf_event.c     |    3 -
>  arch/x86/kernel/hw_breakpoint.c      |   10 ++-
>  arch/x86/kernel/traps.c              |    3 +
>  include/linux/ftrace_event.h         |   18 +++++-
>  include/trace/ftrace.h               |   48 ++-------------
>  kernel/trace/trace_event_profile.c   |   52 +++++++++++++++--
>  kernel/trace/trace_kprobe.c          |  109 ++++++----------------------------
>  kernel/trace/trace_syscalls.c        |   71 +++-------------------
>  11 files changed, 109 insertions(+), 214 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
