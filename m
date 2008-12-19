Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYLSPa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYLSPa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 10:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLSPaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 10:30:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55750 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbYLSPaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 10:30:11 -0500
Date: Fri, 19 Dec 2008 16:30:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: introduce tracing_reset_online_cpus() helper
Message-ID: <20081219153001.GA13130@elte.hu>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
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


* Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch factors out common code from multiple tracers into a
> tracing_reset_online_cpus() function and converts the tracers to use it.
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  kernel/trace/trace.c              |   10 ++++++++++
>  kernel/trace/trace.h              |    1 +
>  kernel/trace/trace_boot.c         |   12 +-----------
>  kernel/trace/trace_functions.c    |   14 ++------------
>  kernel/trace/trace_hw_branches.c  |   14 ++------------
>  kernel/trace/trace_mmiotrace.c    |    6 +-----
>  kernel/trace/trace_sched_switch.c |   14 ++------------
>  kernel/trace/trace_sysprof.c      |   12 +-----------
>  8 files changed, 20 insertions(+), 63 deletions(-)

looks like a nice simplification! Applied to tip/tracing/ftrace, thanks 
Pekka!

	Ingo
