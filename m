Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZL3RxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZL3RxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 12:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZL3RxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 12:53:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55242 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbZL3RxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 12:53:05 -0500
Date: Wed, 30 Dec 2009 18:52:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/3][GIT PULL][v2.6.33] tracing: various fixes
Message-ID: <20091230175246.GA15815@elte.hu>
References: <20091230162303.088852290@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230162303.088852290@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> The previous pull request was a bit too much for 33-rc. I pulled out the 
> three patches that are fixes that should definitely be in 33, and I'll save 
> the conversion to print_fmt for 34.
> 
> When these changes are in 33-rc, I'll send out another pull request based on 
> that 33-rc with the rest of the changes. That pull request will be for 34.
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Lai Jiangshan (3):
>       tracing/kprobe: Show sign of fields in trace_kprobe format files
>       tracing/syscalls: Fix typo in SYSCALL_DEFINE0
>       tracing: Fix sign fields in ftrace_define_fields_##call()
> 
> ----
>  include/linux/syscalls.h    |    2 +-
>  include/trace/ftrace.h      |    7 ++++---
>  kernel/trace/trace_export.c |    7 ++++---
>  kernel/trace/trace_kprobe.c |    7 ++++---
>  4 files changed, 13 insertions(+), 10 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
