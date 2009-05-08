Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbZEHLat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbZEHLat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZEHLaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:30:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35635 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbZEHLaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:30:39 -0400
Date: Fri, 8 May 2009 13:30:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing/ring-buffer: updates for tip
Message-ID: <20090508113026.GJ11596@elte.hu>
References: <20090508043250.372421144@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508043250.372421144@goodmis.org>
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
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (4):
>       tracing: have menu default enabled when kernel debug is configured
>       ring-buffer: only periodically call cond_resched to ring-buffer-benchmark
>       ring-buffer: add total count in ring-buffer-benchmark
>       ring-buffer: change WARN_ON from checking preempt_count to preemptible
> 
> ----
>  kernel/trace/Kconfig                 |    1 +
>  kernel/trace/ring_buffer.c           |    2 +-
>  kernel/trace/ring_buffer_benchmark.c |   22 ++++++++++++++++++++--
>  3 files changed, 22 insertions(+), 3 deletions(-)
> -- 

Pulled, thanks Steve. (I suspect i'll get the fix for the things 
noticed by Andrew in the next pull request?)

	Ingo
