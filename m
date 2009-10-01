Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbZJAJFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbZJAJFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZJAJFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:05:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55266 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbZJAJF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:05:29 -0400
Date: Thu, 1 Oct 2009 11:05:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed
	workqueue
Message-ID: <20091001090532.GR14918@kernel.dk>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <20091001084040.GA15345@elte.hu> <20091001084733.GO14918@kernel.dk> <20091001090137.GE15345@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001090137.GE15345@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Oct 01 2009, Ingo Molnar wrote:
> > > My main worry is that in practice workqueues arent all that performance 
> > > critical - so we are shooting to optimize something that doesnt 
> > > necessarily use all the potential goodness inherent in this approach.
> > 
> > Well, the main problem with the current code is that per-cpu 
> > workqueues are way abused. I don't look at this patchset from a 
> > performance point of view, but rather a way to limit this huge number 
> > of idle and pointless threads. [...]
> 
> I do look at it as a potentially (and primarily) big performance feature 
> - if only it was utilized in a place where the performance aspect 
> mattered.

That just makes it win-win-win :-)

> Sure, the memory savings are nice too.

As is the unified approach to async work handling, compared with what we
have now (which is several flavors of workqueues, async work, slow work,
etc).

-- 
Jens Axboe

