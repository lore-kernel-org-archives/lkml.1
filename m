Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbXJBIRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbXJBIRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXJBIRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:17:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45808 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbXJBIRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:17:08 -0400
Subject: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 10:17:05 +0200
Message-Id: <1191313025.13204.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 14:22 -0700, Andrew Morton wrote:

> nfs-remove-congestion_end.patch
> lib-percpu_counter_add.patch
> lib-percpu_counter_sub.patch
> lib-percpu_counter-variable-batch.patch
> lib-make-percpu_counter_add-take-s64.patch
> lib-percpu_counter_set.patch
> lib-percpu_counter_sum_positive.patch
> lib-percpu_count_sum.patch
> lib-percpu_counter_init-error-handling.patch
> lib-percpu_counter_init_irq.patch
> mm-bdi-init-hooks.patch
> mm-scalable-bdi-statistics-counters.patch
> mm-count-reclaimable-pages-per-bdi.patch
> mm-count-writeback-pages-per-bdi.patch

This one:
> mm-expose-bdi-statistics-in-sysfs.patch

> lib-floating-proportions.patch
> mm-per-device-dirty-threshold.patch
> mm-per-device-dirty-threshold-warning-fix.patch
> mm-per-device-dirty-threshold-fix.patch
> mm-dirty-balancing-for-tasks.patch
> mm-dirty-balancing-for-tasks-warning-fix.patch

And, this one:
> debug-sysfs-files-for-the-current-ratio-size-total.patch


I'm not sure polluting /sys/block/<foo>/queue/ like that is The Right
Thing. These patches sure were handy when debugging this, but not sure
they want to move to maineline.

Maybe we want /sys/bdi/<foo>/ or maybe /debug/bdi/<foo>/

Opinions?

