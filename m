Return-Path: <linux-kernel-owner+w=401wt.eu-S1762100AbZFPT2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762100AbZFPT2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZFPT22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:28:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZFPT21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:28:27 -0400
Date: Tue, 16 Jun 2009 21:28:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] tracing/filters/ringbuffer: updates for
	2.6.31
Message-ID: <20090616192821.GA12699@elte.hu>
References: <20090616175133.317996432@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616175133.317996432@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Could you run these through your tests. I ran them through mine and
> they passed.
> 
> These should really make it into 31 since they all fix some bugs.
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Li Zefan (2):
>       tracing/filters: free filter_string in destroy_preds()
>       tracing/filters: fix race between filter setting and module unload
> 
> Steven Rostedt (3):
>       ring-buffer: have benchmark test handle discarded events
>       ring-buffer: remove unused variable
>       ring-buffer: use commit counters for commit pointer accounting
> 
> ----
>  kernel/trace/ring_buffer.c           |  155 ++++++++++++++++-----------------
>  kernel/trace/ring_buffer_benchmark.c |    8 +-
>  kernel/trace/trace_events_filter.c   |   28 +++----
>  3 files changed, 91 insertions(+), 100 deletions(-)

Pulled, thanks Steve!

	Ingo
