Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYLCH5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYLCH5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYLCH5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:57:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbYLCH5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:57:44 -0500
Date: Wed, 3 Dec 2008 08:57:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] ftrace updates for tip
Message-ID: <20081203075737.GB21006@elte.hu>
References: <20081202203404.496794864@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202203404.496794864@goodmis.org>
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

> Ingo,
> 
> Here's some more ftrace updates.
> 
> The first should help fix the bug in lockdep.

ok.

> The next are changes to the ring buffer to get ready to have it
> work with splice.

great!

> The last are some clean ups for function graph.

ok. I'll also pull the followup cleanups that you did based on Andrew's 
suggestions.

> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (5):
>       ftrace: replace raw_local_irq_save with local_irq_save
>       ring-buffer: move some metadata into buffer page
>       ring-buffer: read page interface
>       ftrace: clean up function graph asm
>       ftrace: have function graph use mcount caller address
> 
> ----
>  arch/x86/kernel/entry_32.S  |    1 +
>  arch/x86/kernel/entry_64.S  |    1 +
>  arch/x86/kernel/ftrace.c    |   20 +---
>  include/linux/ring_buffer.h |    5 +
>  kernel/lockdep.c            |    1 +
>  kernel/trace/ring_buffer.c  |  229 ++++++++++++++++++++++++++++++++++++++-----
>  kernel/trace/trace.c        |   12 +-
>  kernel/trace/trace_branch.c |    4 +-
>  kernel/trace/trace_stack.c  |    8 +-
>  9 files changed, 226 insertions(+), 55 deletions(-)

pulled into tip/tracing/ftrace, thanks Steve!

	Ingo
