Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZJAJCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZJAJCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbZJAJCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:02:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52157 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbZJAJCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:02:37 -0400
Date: Thu, 1 Oct 2009 11:01:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed
	workqueue
Message-ID: <20091001090137.GE15345@elte.hu>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <20091001084040.GA15345@elte.hu> <20091001084733.GO14918@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001084733.GO14918@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Oct 01 2009, Ingo Molnar wrote:
> > My main worry is that in practice workqueues arent all that performance 
> > critical - so we are shooting to optimize something that doesnt 
> > necessarily use all the potential goodness inherent in this approach.
> 
> Well, the main problem with the current code is that per-cpu 
> workqueues are way abused. I don't look at this patchset from a 
> performance point of view, but rather a way to limit this huge number 
> of idle and pointless threads. [...]

I do look at it as a potentially (and primarily) big performance feature 
- if only it was utilized in a place where the performance aspect 
mattered.

Sure, the memory savings are nice too.

	Ingo
