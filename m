Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbZBVRKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbZBVRKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbZBVRKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:10:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49539 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbZBVRKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:10:41 -0500
Date: Sun, 22 Feb 2009 18:10:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4] [git pull v2 @num@/@total@] updates for tip
Message-ID: <20090222171018.GB6570@elte.hu>
References: <20090220193239.561624242@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220193239.561624242@goodmis.org>
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
> I incorporated your comments, and rebased against your tip/x86/urgent
> branch.
> 
> Updates are:
>  - rename ftrace_arch_modify_* to ftrace_arch_code_modify_*
>  - use pr_debug over KERN_INFO in set_kernel_text_*
>  - removed comment about ftrace on set_kernel_text_*
>  - use return instead of goto to break out of double loop
>  - merged akpm's suggestion into 2cd patch
> 
> My last commit is:
> 
>  4377245aa93b65b6597e4b7bb460fb9abc48b56b
>  ftrace: break out modify loop immediately on detection of error
> 
> Because I did recently rebase, you might want to confirm that
> the SHA1 matches and is not stale data.
> 
> Please pull the latest tip/x86/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/x86/ftrace
> 
> 
> Steven Rostedt (4):
>       ftrace: allow archs to preform pre and post process for code modification
>       ftrace, x86: make kernel text writable only for conversions
>       ftrace: immediately stop code modification if failure is detected
>       ftrace: break out modify loop immediately on detection of error
> 
> ----
>  arch/x86/include/asm/cacheflush.h |    5 +++++
>  arch/x86/kernel/ftrace.c          |   17 +++++++++++++++++
>  arch/x86/mm/init_32.c             |   35 ++++++++++++++++++++++++++++++++---
>  arch/x86/mm/init_64.c             |   37 ++++++++++++++++++++++++++++++++-----
>  include/linux/ftrace.h            |    3 +++
>  kernel/trace/ftrace.c             |   33 ++++++++++++++++++++++++++++++++-
>  6 files changed, 121 insertions(+), 9 deletions(-)

Pulled into tip:tracing/ftrace, thanks Steve!

	Ingo
