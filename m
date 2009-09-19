Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZISHQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZISHQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZISHQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:16:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38978 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZISHQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:16:23 -0400
Date: Sat, 19 Sep 2009 09:16:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/2] tracing: Move syscalls metadata handling from arch
	to core
Message-ID: <20090919071616.GA15292@elte.hu>
References: <1253338757-5918-1-git-send-email-fweisbec@gmail.com> <1253338757-5918-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253338757-5918-2-git-send-email-fweisbec@gmail.com>
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

> Most of the syscalls metadata processing is done from arch. But these 
> operations are mostly generic accross archs. Especially now that we 
> have a common variable name that expresses the number of syscalls 
> supported by an arch: NR_syscalls, the only remaining bits that need 
> to reside in arch is the syscall nr to addr translation.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> ---
>  arch/s390/kernel/ftrace.c     |   67 +---------------------------------
>  arch/x86/kernel/ftrace.c      |   76 +-------------------------------------
>  include/trace/syscall.h       |    2 +-
>  kernel/trace/trace_syscalls.c |   80 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 85 insertions(+), 140 deletions(-)

Martin, Heiko, would this cleanup be fine with you?

	Ingo
