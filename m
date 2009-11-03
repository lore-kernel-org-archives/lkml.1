Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZKCHeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZKCHeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZKCHeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:34:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33314 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbZKCHeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:34:08 -0500
Date: Tue, 3 Nov 2009 08:33:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH 1/7] Adding general performance benchmarking
	subsystem to perf.
Message-ID: <20091103073354.GC19928@elte.hu>
References: <20091103.133615.1066539147061640148.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103.133615.1066539147061640148.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> 
> Adding general performance benchmarking subsystem to perf.
> This patch modifies Makefile of perf to build new source files.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> ---
>  tools/perf/Makefile |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 7e190d5..f6f7a6b 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -391,6 +391,9 @@ BUILTIN_OBJS += builtin-stat.o
>  BUILTIN_OBJS += builtin-timechart.o
>  BUILTIN_OBJS += builtin-top.o
>  BUILTIN_OBJS += builtin-trace.o
> +BUILTIN_OBJS += builtin-bench.o
> +BUILTIN_OBJS += builtin-bench-messaging.o
> +BUILTIN_OBJS += builtin-bench-pipe.o

The series should be bisectable (i.e. build at every step) - so i'd 
suggest to add this Makefile bit to the patch that adds the .c, or move 
the .c addition before the Makefile addition patch.

	Ingo
