Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZB1J1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZB1J1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZB1J1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:27:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZB1J1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:27:06 -0500
Date: Sat, 28 Feb 2009 10:26:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] zedtrace generic kernel filtering
Message-ID: <20090228092657.GA2869@elte.hu>
References: <1235725256.8512.88.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235725256.8512.88.camel@charm-linux>
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


* Tom Zanussi <tzanussi@gmail.com> wrote:

> Add generic kernel filtering.
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> ---
>  kernel/trace/trace_binary/Makefile     |    2 +-
>  kernel/trace/trace_binary/zed.c        |  103 +++++++++--
>  kernel/trace/trace_binary/zed.h        |   15 ++
>  kernel/trace/trace_binary/zed_filter.c |  301 ++++++++++++++++++++++++++++++++
>  kernel/trace/trace_binary/zed_filter.h |   45 +++++
>  kernel/trace/trace_binary/zed_sched.c  |    4 +
>  6 files changed, 451 insertions(+), 19 deletions(-)
>  create mode 100644 kernel/trace/trace_binary/zed_filter.c
>  create mode 100644 kernel/trace/trace_binary/zed_filter.h

Nice!

This fits really nicely into the ftrace principles and i'd love 
to see this feature merged into ftrace - would you be interested 
in working on that? If so then you can find the latest tracing 
tree at:

    http://people.redhat.com/mingo/tip.git/README

Note that Steve added explicit field enumeration and 'raw' C 
syntax tracepoints to the event tracer earlier today (partly 
based on your ideas here), so that would be a good basis to 
extend/enhance/fix, if you are interested.

Thanks,

	Ingo
