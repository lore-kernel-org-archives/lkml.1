Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZJOGl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZJOGl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZJOGl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:41:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZJOGl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:41:27 -0400
Date: Thu, 15 Oct 2009 08:40:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing: Arch syscalls tracing shrinks and fixlets
Message-ID: <20091015064043.GB11645@elte.hu>
References: <1255547598-5294-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255547598-5294-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the tracing/core branch that can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core
> 
> Thanks,
> Frederic.
> 
> ---
> Frederic Weisbecker (4):
>       tracing: Move syscalls metadata handling from arch to core
>       tracing: Document HAVE_SYSCALL_TRACEPOINTS needs
>       ftrace: Copy ftrace_graph_filter boot param using strlcpy
>       ftrace: Rename set_bootup_ftrace into set_cmdline_ftrace
> 
>  Documentation/trace/ftrace-design.txt |   13 ++++-
>  arch/s390/kernel/ftrace.c             |   67 +-------------------------
>  arch/x86/kernel/ftrace.c              |   76 +----------------------------
>  include/trace/syscall.h               |    2 +-
>  kernel/trace/ftrace.c                 |    2 +-
>  kernel/trace/trace.c                  |    4 +-
>  kernel/trace/trace_syscalls.c         |   86 +++++++++++++++++++++++++++++++++
>  7 files changed, 105 insertions(+), 145 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
