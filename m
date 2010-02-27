Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968042Ab0B0JHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:07:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968029Ab0B0JHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:07:09 -0500
Date: Sat, 27 Feb 2010 10:06:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier.adi@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL][RESEND] tracing/core updates
Message-ID: <20100227090651.GC22839@elte.hu>
References: <1267208445-8110-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267208445-8110-1-git-send-regression-fweisbec@gmail.com>
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
> Please pull the tracing/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core
> 
> Thanks,
> 	Frederic
> ---
> 
> Heiko Carstens (3):
>       tracing/kprobes: Make Kconfig dependencies generic
>       s390: Add pt_regs register and stack access API
>       tracing/kprobes: Add short documentation for HAVE_REGS_AND_STACK_ACCESS_API
> 
> Mike Frysinger (1):
>       tracing: Unify arch_syscall_addr() implementations
> 
> 
>  Documentation/trace/ftrace-design.txt |    5 +--
>  arch/Kconfig                          |    8 ++++
>  arch/s390/Kconfig                     |    1 +
>  arch/s390/include/asm/ptrace.h        |   13 +++++++-
>  arch/s390/include/asm/syscall.h       |    7 ++++
>  arch/s390/kernel/ftrace.c             |   10 ------
>  arch/s390/kernel/ptrace.c             |   58 +++++++++++++++++++++++++++++++++
>  arch/sh/include/asm/syscall.h         |    2 +
>  arch/sh/kernel/ftrace.c               |    9 -----
>  arch/sparc/include/asm/syscall.h      |    7 ++++
>  arch/sparc/kernel/ftrace.c            |   11 ------
>  arch/x86/Kconfig                      |    1 +
>  arch/x86/include/asm/syscall.h        |    2 +
>  arch/x86/kernel/ftrace.c              |   10 ------
>  include/linux/ftrace.h                |    6 +++
>  kernel/trace/Kconfig                  |    2 +-
>  kernel/trace/trace_syscalls.c         |    5 +++
>  17 files changed, 112 insertions(+), 45 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
