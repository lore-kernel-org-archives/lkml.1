Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbZJCKfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbZJCKfr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 06:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZJCKfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 06:35:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZJCKfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 06:35:45 -0400
Date: Sat, 3 Oct 2009 12:35:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: kprobes fixes
Message-ID: <20091003103538.GA12263@elte.hu>
References: <1254537091-4993-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254537091-4993-1-git-send-email-fweisbec@gmail.com>
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
> Please pull the tracing/kprobes tree that can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/kprobes
> 
> (I'm just waiting a bit before pushing the perf probe patches
> while we discuss some syntax things).
> 
> Thanks.
> 
> Masami Hiramatsu (3):
>       tracing/kprobes: Use global event perf buffers in kprobe tracer
>       x86: Add VIA processor instructions in opcodes decoder
>       tracing/ftrace: Fix to check create_event_dir() when adding new events
> 
>  arch/x86/lib/x86-opcode-map.txt |    8 +++-
>  kernel/trace/trace_events.c     |   25 +++++----
>  kernel/trace/trace_kprobe.c     |  115 +++++++++++++++++++++++++--------------
>  3 files changed, 94 insertions(+), 54 deletions(-)

Pulled, thanks!

	Ingo
