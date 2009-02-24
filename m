Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbZBXTnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbZBXTnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZBXTnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:43:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:50467 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbZBXTnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:43:04 -0500
Subject: Re: [PATCH 0/4][RFC] event tracer
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
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20090224193344.638329210@goodmis.org>
References: <20090224193344.638329210@goodmis.org>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 20:42:36 +0100
Message-Id: <1235504556.4645.2252.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 14:33 -0500, Steven Rostedt wrote:

>  DECLARE_TRACE_FMT(sched_kthread_stop,
>         TPPROTO(struct task_struct *t),
>                   TPARGS(t),
>                    "task %s:%d", TPARGS(t->comm, t->pid));

Consistency would require something like:

DECLARE_TRACE_FMT(sched_kthread_stop,
		  TPPROTO(struct task_struct *t),
		  TPARGS(t),
		  TPFMT("task %s:%d", t->comm, t->pid));

I seem to remember Jason proposing something like this in the past.

