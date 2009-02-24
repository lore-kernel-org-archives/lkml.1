Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbZBXTr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbZBXTr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759842AbZBXTrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:47:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52935 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922AbZBXTrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:47:49 -0500
Date: Tue, 24 Feb 2009 20:46:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, peterz@infradead.org, fweisbec@gmail.com,
       tytso@mit.edu, arjan@infradead.org, pq@iki.fi, acme@redhat.com,
       jbaron@redhat.com, mbligh@google.com, compudj@krystal.dyndns.org,
       fche@redhat.com, kosaki.motohiro@jp.fujitsu.com, jens.axboe@oracle.com,
       mhiramat@redhat.com, srostedt@redhat.com
Subject: Re: [PATCH 1/4][RFC] tracing: add event trace infrastructure
Message-ID: <20090224194650.GC28772@elte.hu>
References: <20090224193344.638329210@goodmis.org> <20090224193450.734369391@goodmis.org> <20090224114217.d30ab19a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224114217.d30ab19a.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 24 Feb 2009 14:33:45 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +#define DECLARE_TRACE_FMT(call, proto, args, fmt, fmt_args)		\
> > +static void ftrace_event_##call(proto)					\
> > +{									\
> > +	event_trace_printk(_RET_IP_, "(%s) " fmt "\n", #call, fmt_args); \
> > +}									\
> 
> <anal>This macro emits a definition, not a declaration.</anal>

yes indeed :) It got modified from one that emitted a 
declaration to also emit a definition and the name was not 
converted.

	Ingo
