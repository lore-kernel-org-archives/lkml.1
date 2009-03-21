Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbZCUPTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbZCUPTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZCUPS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:18:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58473 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbZCUPS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:18:58 -0400
Date: Sat, 21 Mar 2009 16:18:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] blktrace: report EBUSY correctly
Message-ID: <20090321151845.GA31890@elte.hu>
References: <49C2F599.3060306@cn.fujitsu.com> <49C2F614.2010101@cn.fujitsu.com> <20090320131017.GN30407@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320131017.GN30407@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Fri, Mar 20, 2009 at 09:49:08AM +0800, Li Zefan escreveu:
> > blk_trace_remove_queue() returns EINVAL if q->blk_trace == NULL,
> > but blk_trace_setup_queue() doesn't return EBUSY if q->blk_trace != NULL.
> > 
> >  # echo 0 > sdaX/trace/enable
> >  # echo 0 > sdaX/trace/enable
> >  bash: echo: write error: Invalid argument
> >  # echo 1 > sdaX/trace/enable
> >  # echo 1 > sdaX/trace/enable
> >  (should return EBUSY)
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Thanks for all the testing, its being really appreciated,
> 
> Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

thanks Arnaldo - i've added your acks to tip:tracing/blktrace.

Jens, are the changes fine with you too, can i merge them into 
tracing/core, for v2.6.30?

	Ingo
