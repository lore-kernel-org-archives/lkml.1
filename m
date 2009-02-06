Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZBFACn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZBFACn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZBFACf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:02:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37686 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbZBFACe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:02:34 -0500
Date: Fri, 6 Feb 2009 01:02:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/2] ring_buffer: remove unused flags parameter
Message-ID: <20090206000223.GB16040@elte.hu>
References: <20090205181256.GH17653@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090205181256.GH17653@ghostprotocols.net>
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

> Impact: API change, cleanup
> 
> >From ring_buffer_{lock_reserve,unlock_commit}.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  block/blktrace.c                 |    8 +++---
>  include/linux/ring_buffer.h      |    9 ++----
>  kernel/trace/kmemtrace.c         |   12 +++-----
>  kernel/trace/ring_buffer.c       |    9 +-----
>  kernel/trace/trace.c             |   56 +++++++++++++------------------------
>  kernel/trace/trace_boot.c        |   12 +++-----
>  kernel/trace/trace_branch.c      |    7 ++---
>  kernel/trace/trace_hw_branches.c |    6 ++--
>  kernel/trace/trace_mmiotrace.c   |   12 +++-----
>  kernel/trace/trace_power.c       |   12 +++-----
>  10 files changed, 51 insertions(+), 92 deletions(-)

Applied to tip:tracing/ftrace, thanks Arnaldo!

	Ingo
