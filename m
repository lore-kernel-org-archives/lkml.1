Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZFAVnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZFAVnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZFAVnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:43:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57636 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbZFAVnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:43:01 -0400
Date: Mon, 1 Jun 2009 23:42:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] tracing/workqueue updates
Message-ID: <20090601214232.GB5786@elte.hu>
References: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi Ingo,
> 
> The following patches are fixes and cleanup for the workqueue tracer.
> 
> One of them makes the worklet search patch faster.
> Some of them fix and sanitize the histogram output and the others clean and
> standardize the code.
> 
> Thanks.
> 
> The following changes since commit c5f0530c4bb2ec77a805cfcf23db09b3e5ab09d4:
>   Ingo Molnar (1):
>         Merge branch 'tracing/core' into tracing/workqueues
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/workqueue
> 
> Anton Blanchard (2):
>       tracing/events: use %pf in workqueue trace events
>       tracing/events: rename worklet_execute to worklet_entry and worklet_complete to worklet_exit
> 
> Zhaolei (3):
>       tracing/workqueue: get rid of searching last executed worklet in probe_worklet_complete()
>       tracing/workqueue: fix list header and function name format
>       tracing/workqueue: cleanup for trace_workqueue.c
> 
>  Documentation/trace/workqueue.txt |   12 ++--
>  include/trace/events/workqueue.h  |    8 +-
>  kernel/trace/trace_workqueue.c    |  124 +++++++++++++++++-------------------
>  3 files changed, 69 insertions(+), 75 deletions(-)

Pulled, thanks Frederic!

	Ingo
