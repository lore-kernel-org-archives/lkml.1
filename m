Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbZGJKBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbZGJKBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbZGJKBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:01:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59999 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZGJKBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:01:17 -0400
Date: Fri, 10 Jul 2009 12:01:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] ksym_tracer: various fixes
Message-ID: <20090710100100.GB5499@elte.hu>
References: <4A52E291.1020408@cn.fujitsu.com> <20090707231835.GA7514@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707231835.GA7514@nowhere>
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

> On Tue, Jul 07, 2009 at 01:52:17PM +0800, Li Zefan wrote:
> > Here are some fixes for ksym_tracer.
> > 
> > [PATCH 1/8] ksym_tracer: Extract trace entry from struct trace_ksym
> > [PATCH 2/8] ksym_tracer: Rewrite ksym_trace_filter_read()
> > [PATCH 3/8] ksym_tracer: Fix validation of access type
> > [PATCH 4/8] ksym_tracer: Fix validation of length of access type
> > [PATCH 5/8] ksym_tracer: NIL-terminate user input filter
> > [PATCH 6/8] ksym_tracer: Report error when failed to re-register hbp
> > [PATCH 7/8] ksym_tracer: Fix memory leak
> > [PATCH 8/8] ksym_tracer: Fix the output of stat tracing
> > ---
> >  kernel/trace/trace_ksym.c |  161 ++++++++++++++++++++++-----------------------
> >  1 files changed, 78 insertions(+), 83 deletions(-)
> > 
> 
> For the whole series:
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Thanks a lot!
> 
> Prasad, any objection?

Thanks guys, i've applied it to tip:tracing/hw-breakpoints. Not yet 
merged into tracing/core - we also want to see how the perfcounters 
angle plays out before committing this for v2.6.32.

	Ingo
