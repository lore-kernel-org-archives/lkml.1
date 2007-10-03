Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbXJCLAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbXJCLAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbXJCLAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:00:42 -0400
Received: from web32612.mail.mud.yahoo.com ([68.142.207.239]:41755 "HELO
	web32612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755362AbXJCLAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:00:41 -0400
X-YMail-OSG: XJY.GTsVM1ll5CQmMGoL64nAf6.0u56Fmf4B8LV3EH5gHoHMHRC_lxQ.MWUSTjVBtwRPIWNcOymqeHaJDISCy7DFTg--
X-RocketYMMF: knobi.rm
Date: Wed, 3 Oct 2007 04:00:40 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Reply-To: knobi@knobisoft.de
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
To: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
In-Reply-To: <1191313025.13204.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <336165.86658.qm@web32612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Peter Zijlstra <peterz@infradead.org> wrote:

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
> Thing. These patches sure were handy when debugging this, but not
> sure
> they want to move to maineline.
> 
> Maybe we want /sys/bdi/<foo>/ or maybe /debug/bdi/<foo>/
> 
> Opinions?
> 
Hi Peter,

 my only opinion is that it is great to see that stuff moving into
mainline. If it really goes in, there will be one more very interested
rc-tester :-)

Cheers
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
