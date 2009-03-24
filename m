Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZCXUsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZCXUsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZCXUsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:48:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42359 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbZCXUsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:48:32 -0400
Date: Tue, 24 Mar 2009 21:47:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 6/9] LTTng instrumentation - timer
Message-ID: <20090324204719.GA24320@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.754766083@polymtl.ca> <20090324182122.GG31117@elte.hu> <alpine.LFD.2.00.0903242011520.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903242011520.29264@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 24 Mar 2009, Ingo Molnar wrote:
> > the init methods are missing from your patch entirely - and the rest 
> > is partially incomplete as well.
> > 
> > Instrumentation of the del_timer() variants is missing. For a 
> > complete lifetime analysis of timers this cannot be left out.
> 
> Look at the debugobjects hooks. They cover the complete timer life 
> time already.
> 
> Piggypacking tracepoints on those would simplify maintenance and 
> reduce the number of extra lines in the code.

makes sense. They dont cover itimers nor hrtimers though.

	Ingo
