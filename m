Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZJBQh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZJBQh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbZJBQh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:37:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50848 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386AbZJBQh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:37:57 -0400
Date: Fri, 2 Oct 2009 18:37:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091002163707.GB12546@elte.hu>
References: <20090927164235.GA23126@kernel.dk> <1254340730.7695.32.camel@marge.simson.net> <1254341139.7695.36.camel@marge.simson.net> <20090930202447.GA28236@redhat.com> <1254382405.7595.9.camel@marge.simson.net> <20091001185816.GU14918@kernel.dk> <1254464628.7158.101.camel@marge.simson.net> <20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu> <1254476214.11022.8.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254476214.11022.8.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Fri, 2009-10-02 at 11:24 +0200, Ingo Molnar wrote:
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > It's not hard to make the latency good, the hard bit is making sure we 
> > > also perform well for all other scenarios.
> > 
> > Looking at the numbers from Mike:
> > 
> >  | dd competing against perf stat -- konsole -e exec timings, 5 back to 
> >  | back runs
> >  |                                                         Avg
> >  | before         9.15    14.51     9.39    15.06     9.90   11.6
> >  | after [+patch] 1.76     1.54     1.93     1.88     1.56    1.7
> > 
> > _PLEASE_ make read latencies this good - the numbers are _vastly_ 
> > better. We'll worry about the 'other' things _after_ we've reached good 
> > latencies.
> > 
> > I thought this principle was a well established basic rule of Linux 
> > IO scheduling. Why do we have to have a 'latency vs. bandwidth' 
> > discussion again and again? I thought latency won hands down.
> 
> Just a note: In the testing I've done so far, we're better off today 
> than ever, [...]

Definitely so, and a couple of months ago i've sung praises of that 
progress on the IO/fs latencies front:

   http://lkml.org/lkml/2009/4/9/461

... but we are greedy bastards and dont define excellence by how far 
down we have come from but by how high we can still climb ;-)

	Ingo
