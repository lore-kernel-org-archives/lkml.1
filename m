Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbZD0TPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbZD0TPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbZD0TOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:14:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44393 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348AbZD0TOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:14:54 -0400
Date: Mon, 27 Apr 2009 21:09:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, zhaolei@cn.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com, rostedt@goodmis.org, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
	worklet lifecycle tracing
Message-ID: <20090427190953.GA3597@redhat.com>
References: <49F1A59B.3080206@cn.fujitsu.com> <20090424130616.a3c217cb.akpm@linux-foundation.org> <20090424225909.GA6658@nowhere> <20090424162056.45907fef.akpm@linux-foundation.org> <20090425003702.GC6658@nowhere> <20090424182821.8263f445.akpm@linux-foundation.org> <20090426104747.GA5983@elte.hu> <20090426224450.8ea9f724.akpm@linux-foundation.org> <20090427150241.GA23700@redhat.com> <20090427154327.GA29921@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427154327.GA29921@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > I must admit, I don't really understand why trace_workqueue.c uses
> > cwq->thread as a "primary key". I have the feeling we can simplify
> > this code if we pass "struct workqueue_struct *" instead, but I am
> > not sure.
> >
> > In particular, trace_workqueue_flush(cwq->thread) looks a bit
> > strange to me. I can't imagine how it can be useful per-thread and
> > without trace_workqueue_flush_end() or something. I mean, if we
> > need to trace flushes, then imho it makes much more sense to add
> > flush_start/flush_end handlers into flush_workqueue().
>
> If this is fixed (and no other problem surfaces), would you mind to
> ack these bits?

If you think my ack can help, you have it right now ;)

> And if you can think of any way to make it even simpler / less
> intrusive, please let us know ...

Sure. But currently I only have a gut feeling (probably wrong) and nothing
more. And just in case, my apologies to all, I can't be very responsive on
this topic in the near future.

Oleg.

