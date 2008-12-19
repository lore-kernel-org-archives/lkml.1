Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbYLSQB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbYLSQB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYLSQBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:01:47 -0500
Received: from relay3.sgi.com ([192.48.171.31]:59904 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750989AbYLSQBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:01:46 -0500
Message-Id: <20081219160144.697518000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 08:01:44 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] x86 cpumask: more cpumask updates to core kernel routines
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patches for review only.  Will be pushed via one git conduit or another.

Remove 20 more cpumask_t references (down to *only* 518... ;-)

Pulled the following patches from:

http://ozlabs.org/~rusty/kernel/rr-2008-12-18-1.tar.bz2

	cpumask:convert-kernel_compat.c.patch
	cpumask:convert-kernel_workqueue.c.patch
	cpumask:convert-kernel_time.patch
	cpumask:convert-kernel_trace.patch
	cpumask:convert-kernel.patch
	cpumask:convert-mm.patch
	cpumask:convert-drivers.patch
	cpumask:convert-misc.patch

... and edited slightly/built/tested on x86_64

In addition, the following are OBSOLETE:

	cpumask:get-rid-of-_nr-core.patch
	(folded into the above patches to avoid inter-patch dependencies)

The affected files are:

(* - interdepency on 'irq_default_affinity')

    (*)	arch/alpha/kernel/irq.c
	drivers/base/cpu.c
	drivers/misc/sgi-xp/xpc_main.c
	drivers/net/sfc/efx.c
	drivers/oprofile/buffer_sync.c
	drivers/oprofile/buffer_sync.h
	drivers/oprofile/oprof.c
	drivers/xen/manage.c
	fs/seq_file.c
	include/linux/interrupt.h
	include/linux/rcuclassic.h
	include/linux/seq_file.h
	include/linux/stop_machine.h
	include/linux/tick.h
	kernel/compat.c
	kernel/cpu.c
	kernel/irq/manage.c
	kernel/irq/proc.c
	kernel/power/poweroff.c
	kernel/profile.c
	kernel/rcuclassic.c
	kernel/rcupreempt.c
	kernel/rcutorture.c
	kernel/softlockup.c
	kernel/stop_machine.c
	kernel/taskstats.c
	kernel/time/clocksource.c
	kernel/time/tick-broadcast.c
	kernel/time/tick-common.c
	kernel/trace/ring_buffer.c
	kernel/trace/trace.c
	kernel/trace/trace_sysprof.c
	kernel/workqueue.c
	lib/smp_processor_id.c
	mm/pdflush.c
	mm/slab.c
	mm/slub.c
	mm/vmscan.c
	mm/vmstat.c
	net/iucv/iucv.c

-- 
