Return-Path: <linux-kernel-owner+w=401wt.eu-S1760143AbZCXR6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbZCXR6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZCXR5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:57:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59014 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbZCXR5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:57:47 -0400
Date: Tue, 24 Mar 2009 18:56:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 3/9] LTTng instrumentation tasklets
Message-ID: <20090324175621.GE31117@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.238795468@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324160148.238795468@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> tasklet entry and exit events.

> +DEFINE_TRACE(irq_tasklet_high_entry);
> +DEFINE_TRACE(irq_tasklet_high_exit);
> +DEFINE_TRACE(irq_tasklet_low_entry);
> +DEFINE_TRACE(irq_tasklet_low_exit);

Dunno - tasklets are a legacy mechanism, not sure we want to 
instrument them. That some tasklet activity happens will be obvious 
from the softirq tracepoints already.

Anyway ... i guess we could do it if it's done via the more complete 
TRACE_EVENT() mechanism in the tracing tree.

	Ingo
