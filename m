Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbZJMN2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbZJMN2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759505AbZJMN2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:28:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40340 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138AbZJMN2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:28:00 -0400
Date: Tue, 13 Oct 2009 15:26:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       anton@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/tracing] hrtimer: Add tracepoint for hrtimers
Message-ID: <20091013132656.GA12292@elte.hu>
References: <4A7F8B2B.5020908@cn.fujitsu.com> <tip-c6a2a1770245f654f35f60e1458d4356680f9519@git.kernel.org> <1255404309.7113.948.camel@gandalf.stny.rr.com> <20091013070853.GA13175@elte.hu> <1255439822.7113.1541.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255439822.7113.1541.camel@gandalf.stny.rr.com>
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

> On Tue, 2009-10-13 at 09:08 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> 
> > > (unsigned long long)(((ktime_t) { .tv64 = REC->expires }).tv64)
> > > 
> > > Is not easy. It's basically implementing a C interpreter :-(
> > 
> > Btw., what i suggested quite some time ago was that we should bind 
> > tracepoints by emitting C source code stubs, which tools can then build 
> > and link in, using gcc.
> 
> Yeah, and I thought about that too. But that kills any chance of 
> running the trace on one box (non x86) and reading it on another 
> (x86). And that is one of my goals for this.

Why does it kill that chance?

	Ingo
