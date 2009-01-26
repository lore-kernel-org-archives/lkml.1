Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbZAZNnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbZAZNnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZAZNnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:43:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39368 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZAZNnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:43:37 -0500
Date: Mon, 26 Jan 2009 14:43:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-btrace@vger.kernel.org
Subject: Re: [PATCH tip][0/2] ftrace interface for blktrace
Message-ID: <20090126134320.GB18859@elte.hu>
References: <20090123140617.GB21737@ghostprotocols.net> <20090126114214.GH30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126114214.GH30821@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, Jan 23 2009, Arnaldo Carvalho de Melo wrote:
> > Hi Jens,
> > 
> > 	Here is a third version, that also implements blk_add_trace_msg,
> > using ftrace_vprintk.
> > 
> > 	As soon as the TRACE_ITER_CONTEXT_INFO option is implemented
> > I'll provide the struct trace_event->bin() callback to synthesize the
> > old blktrace record format so that we can test the output of trace_pipe
> > with blkparse -i -.
> > 
> > 	Please let me know if this is acceptable for inclusion on
> > linux-tip.
> 
> Sure, go ahead and add it!

Cool - i've started tracking Arnaldo's patch by picking up the latest 
version into tip/tracing/blktrace and merging it into tip/master.

Arnaldo, could you please check latest tip/master:

   http://people.redhat.com/mingo/tip.git/README

to see whether it's all OK, integrated with the latest tracing bits?

	Ingo
