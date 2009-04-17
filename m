Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbZDQPLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbZDQPLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758541AbZDQPLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:11:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43857 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758050AbZDQPLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:11:43 -0400
Date: Fri, 17 Apr 2009 17:11:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/5] [GIT PULL] ftrace,tracing/events rebase updates.
Message-ID: <20090417151135.GG23493@elte.hu>
References: <20090417144055.857407604@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417144055.857407604@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I have already sent these patches once to you. This version updates the
> change logs to put the impact lines at the end. It also folds in
> you delay.h missing header fix, and adds my fix to the event tests.
> The two updates are both done to tracing/events: add startup tests for events
> 
> The rest of the patches should be identical.
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Avadh Patel (1):
>       tracing: add saved_cmdlines file to show cached task comms
> 
> Steven Rostedt (4):
>       ftrace: use module notifier for function tracer
>       tracing/events: add startup tests for events
>       tracing/events/ring-buffer: expose format of ring buffer headers to users
>       tracing/events: perform function tracing in event selftests
> 
> ----
>  include/linux/ftrace.h      |    7 -
>  include/linux/module.h      |    4 +
>  include/linux/ring_buffer.h |    5 +
>  kernel/module.c             |   19 +--
>  kernel/trace/ftrace.c       |   90 ++++++++++----
>  kernel/trace/ring_buffer.c  |   44 +++++++
>  kernel/trace/trace.c        |   53 ++++++++
>  kernel/trace/trace_events.c |  282 +++++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 459 insertions(+), 45 deletions(-)

Pulled, thanks a lot Steve!

Will let you know if there's any further self-test failures.

	Ingo
