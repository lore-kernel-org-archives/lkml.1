Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbXJBIcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbXJBIcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbXJBIcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:32:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596AbXJBIcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:32:24 -0400
Date: Tue, 2 Oct 2007 01:31:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Message-Id: <20071002013148.18958af2.akpm@linux-foundation.org>
In-Reply-To: <1191313025.13204.30.camel@twins>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	<1191313025.13204.30.camel@twins>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 10:17:05 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2007-10-01 at 14:22 -0700, Andrew Morton wrote:
> 
> > nfs-remove-congestion_end.patch
> > lib-percpu_counter_add.patch
> > lib-percpu_counter_sub.patch
> > lib-percpu_counter-variable-batch.patch
> > lib-make-percpu_counter_add-take-s64.patch
> > lib-percpu_counter_set.patch
> > lib-percpu_counter_sum_positive.patch
> > lib-percpu_count_sum.patch
> > lib-percpu_counter_init-error-handling.patch
> > lib-percpu_counter_init_irq.patch
> > mm-bdi-init-hooks.patch
> > mm-scalable-bdi-statistics-counters.patch
> > mm-count-reclaimable-pages-per-bdi.patch
> > mm-count-writeback-pages-per-bdi.patch
> 
> This one:
> > mm-expose-bdi-statistics-in-sysfs.patch
> 
> > lib-floating-proportions.patch
> > mm-per-device-dirty-threshold.patch
> > mm-per-device-dirty-threshold-warning-fix.patch
> > mm-per-device-dirty-threshold-fix.patch
> > mm-dirty-balancing-for-tasks.patch
> > mm-dirty-balancing-for-tasks-warning-fix.patch
> 
> And, this one:
> > debug-sysfs-files-for-the-current-ratio-size-total.patch
> 
> 
> I'm not sure polluting /sys/block/<foo>/queue/ like that is The Right
> Thing.

hm, I suppose not.  It leaves nowhere for nfs, for a start.

> These patches sure were handy when debugging this, but not sure
> they want to move to maineline.
> 
> Maybe we want /sys/bdi/<foo>/ or maybe /debug/bdi/<foo>/
> 

If you think we'll need this stuff for support/debug during 2.6.24-rcX then
sure - we can always take it out prior to 2.6.24-final.

otoh, if we're going to take that approach we might as well leave things in
/sys/block/<foo>/queue.

