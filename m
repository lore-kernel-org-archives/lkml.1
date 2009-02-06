Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbZBFADU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbZBFADU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZBFADK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:03:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55845 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbZBFADI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:03:08 -0500
Date: Fri, 6 Feb 2009 01:02:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 2/2] tracing: Introduce
	trace_buffer_{lock_reserve,unlock_commit}
Message-ID: <20090206000252.GC16040@elte.hu>
References: <20090205181413.GI17653@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090205181413.GI17653@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Impact: new API
> 
> These new functions do what previously was being open coded, reducing
> the number of details ftrace plugin writers have to worry about.
> 
> It also standardizes the handling of stacktrace, userstacktrace and
> other trace options we may introduce in the future.
> 
> With this patch, for instance, the blk tracer (and some others already
> in the tree) can use the "userstacktrace" /d/tracing/trace_options
> facility.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  block/blktrace.c                 |   21 ++------
>  kernel/trace/kmemtrace.c         |   19 ++-----
>  kernel/trace/trace.c             |   94 +++++++++++++++++++++----------------
>  kernel/trace/trace.h             |   11 ++++
>  kernel/trace/trace_boot.c        |   20 ++------
>  kernel/trace/trace_branch.c      |    7 +--
>  kernel/trace/trace_hw_branches.c |    7 +--
>  kernel/trace/trace_mmiotrace.c   |   20 +++-----
>  kernel/trace/trace_power.c       |   20 ++------
>  9 files changed, 102 insertions(+), 117 deletions(-)

Applied to tip:tracing/ftrace, thanks!

	Ingo
