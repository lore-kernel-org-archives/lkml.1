Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbYI1UMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbYI1UMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 16:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYI1UMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 16:12:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:40111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbYI1UMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 16:12:38 -0400
Date: Sun, 28 Sep 2008 13:12:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@tglx.de, netdev@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@elte.hu,
       linux-ide@vger.kernel.org
Subject: Oops/Warning report for the week of September 28th, 2008
Message-ID: <20080928131250.112f2a08@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The http://www.kerneloops.org website collects kernel oops and
warning reports from various mailing lists and bugzillas as well as
with a client users can install to auto-submit oopses.
Below is a list of the top traces collected in the last 7 days.
(Reports for version 2.6.25 or earlier have been omitted in collecting the top 10)

This week, a total of 3357 oopses and warnings have been reported,
compared to 2712 reports in the previous week.


Per file statistics
639	net/sched/sch_generic.c
424	drivers/ata/libata-sff.c
410	external/utrace
157	fs/jbd/journal.c
143	drivers/parport/procfs.c
134	external/fireglx/binary (P)
105	net/core/dev.c
103	kernel/timer.c
81	drivers/base/power/main.c
70	kernel/sched.c
42	drivers/char/random.c
38	drivers/gpu/drm/radeon/radeon_cp.c


Unfixed
-------

Rank 1: dev_watchdog (oops)
	Reported 639 times (1496 total reports)
	Various device timeouts. Patch to report the driver name is in -rc7; per driver data is now
	coming in but has not made the top 10 yet.
	This oops was last seen in version 2.6.27-rc7-git1, and first seen in 2.6.26-rc3.
	More info: http://www.kerneloops.org/searchweek.php?search=dev_watchdog

Rank 3: utrace_control (oops)
	Reported 409 times (775 total reports)
	[fedora] Fedora merged a broken utrace patch
	This oops was last seen in version 2.6.26.5, and first seen in 2.6.26.1.
	More info: http://www.kerneloops.org/searchweek.php?search=utrace_control

Rank 4: journal_update_superblock (warning)
	Reported 156 times (4183 total reports)
	Caused by the user removing a USB stick while mounted
	Ted has a patch to fix this, but isn't merged in Linus' tree yet.
	This warning was last seen in version 2.6.27-rc7-git1, and first seen in 2.6.24-rc6-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=journal_update_superblock

Rank 6: firegl_ioctl (warning)
	Reported 105 times (2694 total reports)
	[external] Bug in the proprietary fireglx driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.26.5, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=firegl_ioctl

Rank 9: finish_task_switch (lockup)
	Reported 58 times (139 total reports)
	This oops was last seen in version 2.6.27-rc2-git1, and first seen in 2.6.24.
	Potentially fixed by Thomas' timer patches, the jury is still out on this one
	More info: http://www.kerneloops.org/searchweek.php?search=finish_task_switch

Rank 10: device_pm_add (warning)
	Reported 56 times (231 total reports)
	Bug in the Suspend/Resume code of drivers. Patch to report the actual driver involved is pending for .28
	This warning was last seen in version 2.6.27-rc4, and first seen in 2.6.26-rc5.
	More info: http://www.kerneloops.org/searchweek.php?search=device_pm_add

Rank 11: account (oops)
	Reported 42 times (74 total reports)
	Bug in the /dev/random driver
	This oops was last seen in version 2.6.26.3, and first seen in 2.6.26.
	More info: http://www.kerneloops.org/searchweek.php?search=account

Rank 12: rs_get_rate (warning)
	Reported 34 times (361 total reports)
	Bug in the Intel IWL wireless drivers
	This warning was last seen in version 2.6.27-rc7-git1, and first seen in 2.6.25-rc2-git5.
	More info: http://www.kerneloops.org/searchweek.php?search=rs_get_rate

Rank 13: ext3_commit_super (warning)
	Reported 27 times (1069 total reports)
	Likely caused by the user removing a USB stick while mounted
	Ted has a patch to fix this, not merged yet.
	This warning was last seen in version 2.6.27, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=ext3_commit_super


Fixed in Linus' tree
--------------------
Rank 2: ata_sff_hsm_move (warning)
	Reported 420 times (1019 total reports)
	[fixed] redundant WARN_ON; fixed in 9c2676b61a5a4b6d99e65fb2f438fb3914302eda
	This warning was last seen in version 2.6.27-rc2-git1, and first seen in 2.6.25.4.
	More info: http://www.kerneloops.org/searchweek.php?search=ata_sff_hsm_move

Rank 7: run_timer_softirq (oops)
	Reported 90 times (205 total reports)
	softlockup that got fixed by Thomas' timer fixes
	This oops was last seen in version 2.6.27-rc1-git4, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=run_timer_softirq

Rank 8: __netif_schedule (warning)
	Reported 88 times (694 total reports)
	[fixed] issue as a result of the multiqueue feature, fixed for 2.6.27-rc1
	This warning was last seen in version 2.6.27-rc0-git11, and first seen in 2.6.26-rc8-git.
	More info: http://www.kerneloops.org/searchweek.php?search=__netif_schedule


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
