Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZIXUPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZIXUPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 16:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZIXUPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 16:15:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41127 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbZIXUPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:15:19 -0400
Date: Thu, 24 Sep 2009 22:15:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
Message-ID: <20090924201509.GA26573@elte.hu>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
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
> This is new iteration of the bkl tracepoints + filter
> regex support. It addresses the reviews that were posted
> in the previous RFC version.
> 
> Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core
> 
> Thanks;
> Frederic.
> 
> Frederic Weisbecker (5):
>       tracing/bkl: Add bkl ftrace events
>       tracing/filters: Cleanup useless headers
>       tracing/event: Cleanup the useless dentry variable
>       tracing/filters: Provide basic regex support
>       tracing/filters: Unify the regex parsing helpers
> 
>  include/linux/smp_lock.h           |   19 ++++-
>  include/trace/events/bkl.h         |   61 ++++++++++++++
>  kernel/trace/ftrace.c              |   64 +--------------
>  kernel/trace/trace.h               |   36 ++++++--
>  kernel/trace/trace_events.c        |   23 +++---
>  kernel/trace/trace_events_filter.c |  155 +++++++++++++++++++++++++++++++----
>  lib/kernel_lock.c                  |   11 ++-
>  7 files changed, 262 insertions(+), 107 deletions(-)
>  create mode 100644 include/trace/events/bkl.h

Pulled, thanks a lot Frederic! These bits look very useful.

It would be perf-ect now to complete the filters-via-perf-events changes 
Li Zefan is working on ;-)

	Ingo
