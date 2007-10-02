Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbXJBI2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbXJBI2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXJBI2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:28:38 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50142 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751878AbXJBI2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:28:37 -0400
Message-ID: <391313714.31041@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 2 Oct 2007 16:28:31 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Message-ID: <20071002082831.GA19954@mail.ustc.edu.cn>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <1191313025.13204.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191313025.13204.30.camel@twins>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 10:17:05AM +0200, Peter Zijlstra wrote:
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
> Thing. These patches sure were handy when debugging this, but not sure
> they want to move to maineline.
 
> Maybe we want /sys/bdi/<foo>/ or maybe /debug/bdi/<foo>/

I'd vote for /sys/bdi/.

It will be more than debug variables.  It's good to expose per-bdi
tunable parameters and allow one to view bdi states.

It would also allow one to tune things like NFS readahead :-)

