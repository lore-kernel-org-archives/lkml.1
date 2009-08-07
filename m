Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbZHGK64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbZHGK64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbZHGK64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:58:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46974 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830AbZHGK6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:58:55 -0400
Date: Fri, 7 Aug 2009 12:58:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Mackerras <paulus@samba.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] perfcounters: Support for ftrace event records sampling
Message-ID: <20090807105835.GB24916@elte.hu>
References: <1249601154-5597-1-git-send-email-fweisbec@gmail.com> <1249641477.32113.664.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249641477.32113.664.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-08-07 at 01:25 +0200, Frederic Weisbecker wrote:
> > This patch brings the kernel side support for ftrace event record
> > sampling.
> > 
> > A new counter attribute is added: PERF_SAMPLE_TP_RECORD which requests
> > ftrace events record sampling.
> > 
> 
> > +	PERF_SAMPLE_TP_RECORD			= 1U << 10,
> 
> I'd really want this thing called PERF_SAMPLE_RAW

yeah, i'd agree. I suggested to Frederic to use TP_RECORD but in 
hindsight we are better off to handle PERF_SAMPLE_RAW as a 'non-ABI' 
embelishment of samples, of not firmly defined content.

In the tracepoint case, that extra raw content is defined by:

   /debug/tracing/events/*/format

and subject to changes.

	Ingo
