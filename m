Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbZBYGaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbZBYGaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 01:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZBYG34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:29:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZBYG3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:29:55 -0500
Subject: Re: [PATCH 3/4] tracing: add schedule events to event trace
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090225025754.033529552@goodmis.org>
References: <20090225025608.956691460@goodmis.org>
	 <20090225025754.033529552@goodmis.org>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 07:29:20 +0100
Message-Id: <1235543360.4645.2912.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 21:56 -0500, Steven Rostedt wrote:
> +DEFINE_TRACE_FMT(sched_switch,
> +       TPPROTO(struct rq *rq, struct task_struct *prev,
> +               struct task_struct *next),
> +       TPARGS(rq, prev, next),
> +       TPFMT("task %s:%d ==> %s:%d",
> +             prev->comm, prev->pid, next->comm, next->pid));

Why add tehe "task" string to the left hand task, but not the right hand
one?

