Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbZFTP0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZFTP0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 11:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZFTP0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 11:26:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbZFTP0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 11:26:43 -0400
Date: Sat, 20 Jun 2009 17:26:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/7] [GIT PULL][for 2.6.31] ring-buffer: various clean
	ups
Message-ID: <20090620152635.GA6748@elte.hu>
References: <20090617232555.164629684@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617232555.164629684@goodmis.org>
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
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Steven Rostedt (7):
>       ring-buffer: use BUF_PAGE_HDR_SIZE in calculating index
>       ring-buffer: remove useless warn on check
>       ring-buffer: remove useless compile check for buffer_page size
>       ring-buffer: check for less than two in size allocation
>       ring-buffer: add locks around rb_per_cpu_empty
>       ring-buffer: do not grab locks in nmi
>       ring-buffer: have benchmark test print to trace buffer
> 
> ----
>  kernel/trace/ring_buffer.c           |   82 ++++++++++++++++++++++++---------
>  kernel/trace/ring_buffer_benchmark.c |   37 ++++++++-------
>  2 files changed, 78 insertions(+), 41 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
