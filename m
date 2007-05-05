Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbXEEHIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbXEEHIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 03:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXEEHIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 03:08:43 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083AbXEEHIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 03:08:43 -0400
Date: Sat, 5 May 2007 00:08:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dtor@insightbb.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input patches for 2.6.20
Message-Id: <20070505000832.66b8cf9e.akpm@linux-foundation.org>
In-Reply-To: <20070505060338.GA27713@suse.de>
References: <200702180204.48643.dtor@insightbb.com>
	<200705030107.44990.dtor@insightbb.com>
	<alpine.LFD.0.98.0705041806210.3808@woody.linux-foundation.org>
	<20070505060338.GA27713@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 23:03:38 -0700 Greg KH <gregkh@suse.de> wrote:

> Sorry about that, sometimes core changes like this take a bit of
> coordination across subsystems.

tell me about it.



I often end up maintaining patches which fix susbsystem A for subsystem B.
And patches which fix patch A for patch B:

box:/usr/src/25> grep '[-]vs-' series
fix-refrigerator-vs-thaw_process-race.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-ioat-vs-git-md-accel.patch
#git-wireless-vs-git-net.patch
#git-wireless-vs-git-net-2.patch
#git-wireless-vs-git-net-3.patch
#mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch: Hugh issues
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
#git-block-vs-ext4-ext4-delayed-allocation.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
#lguest-the-host-code-vs-sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set-vs-x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
#proc-maps-protection-vs-utrace.patch
#utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
#git-block reiser4-vs-git-block.patch
#git-block reiser4-vs-git-block-2.patch
#git-block reiser4-vs-git-block3.patch
#git-kgdb-vs-define-struct-pspace.patch

but it takes a little time to get these propagated into the right place..
