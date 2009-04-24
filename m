Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbZDXH0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbZDXH0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZDXH0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:26:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42727 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZDXHZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:25:59 -0400
Date: Fri, 24 Apr 2009 09:25:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sachin Sant <sachinp@in.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-s390@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: Next April 24: [S390] allmodconfig build failure (trace/events)
Message-ID: <20090424072533.GE24912@elte.hu>
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au> <49F16654.8040208@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F16654.8040208@in.ibm.com>
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


* Sachin Sant <sachinp@in.ibm.com> wrote:

> Today's next tree build(s390 allmodconfig) failed with
>
> kernel/built-in.o: In function `trace_softirq_entry'
> include/trace/events/irq.h:42: undefined reference to  
> `__tracepoint_softirq_entry'
> include/trace/events/irq.h:42: undefined reference to  
> `__tracepoint_softirq_entry'
> kernel/built-in.o: In function `trace_softirq_exit':
> include/trace/events/irq.h:48: undefined reference to  
> `__tracepoint_softirq_exit'
> include/trace/events/irq.h:48: undefined reference to  
> `__tracepoint_softirq_exit'

Hm, that's weird - s390 does not build kernel/softirq.o? Hm, it does 
- softirq.o is an obj-y object.

	Ingo
