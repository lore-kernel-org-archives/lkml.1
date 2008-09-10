Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbYIJTRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbYIJTRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYIJTQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:16:58 -0400
Received: from mga05.intel.com ([192.55.52.89]:36098 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751078AbYIJTQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:16:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,374,1217833200"; 
   d="scan'208";a="378851883"
Message-ID: <48C81D20.9040302@linux.intel.com>
Date: Wed, 10 Sep 2008 12:16:48 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, gregkh@novell.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Oops/Warning report for the week of September 10th, 2008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The http://www.kerneloops.org website collects kernel oops and
warning reports from various mailing lists and bugzillas as well as
with a client users can install to auto-submit oopses.
Below is a top 13 list of the traces collected in the last 7 days.
(Reports prior to 2.6.23 have been omitted in collecting the top 10)

This week, a total of 3106 oopses and warnings have been reported,
compared to 1758 reports in the previous week.


Per file statistics
295	fs/jbd/journal.c
226	fs/sysfs/dir.c
179	drivers/parport/procfs.c
145	external/fireglx/binary (P)
131	drivers/ssb/main.c
126	net/core/dev.c
110	kernel/timer/tglx.c
65	fs/ext3/super.c
62	net/sched/sch_generic.c
60	kernel/time/tick-broadcast.c
49	drivers/base/power/main.c
45	drivers/gpu/drm/drm_drv.c


Rank 1: journal_update_superblock (warning)
	Reported 287 times (3559 total reports)
	Likely caused by the user removing a USB stick while mounted
	This warning was last seen in version 2.6.27-rc5-git9, and first seen in 2.6.24-rc6-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=journal_update_superblock

Rank 2: sysfs_add_one (warning)
	Reported 215 times (3751 total reports)
	Duplicate sysfs registration; mostly in USB audio
	This warning was last seen in version 2.6.27-rc5, and first seen in 2.6.24-rc6.
	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one

Rank 3: parport_device_proc_register (warning)
	Reported 179 times (3764 total reports)
	Duplicate /proc registration in the parport driver
	This warning was last seen in version 2.6.26.3, and first seen in 2.6.24-rc5.
	More info: http://www.kerneloops.org/searchweek.php?search=parport_device_proc_register

Rank 4: firegl_ioctl (oops)
	Reported 139 times (2360 total reports)
	[external] Bug in the proprietary fireglx driver
	oops only shows up in tainted kernels
	This warning was last seen in version 2.6.26, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=firegl_ioctl

Rank 5: ssb_tmslow_reject_bitmask (warning)
	New entry due to the Debian kernel having this bug, and Debian now including
	the data collection client
	Reported 131 times (770 total reports)
	This warning was last seen in version 2.6.26, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=ssb_tmslow_reject_bitmask

Rank 6: tick_dev_program_event (warning)
	Reported 110 times
	[debug] temporary WARN_ON() inserted in -rc5 for diagnostics purposes, removed for -rc6
	This warning was last seen in version 2.6.27-rc5-git10, and first seen in 2.6.27-rc5.
	More info: http://www.kerneloops.org/searchweek.php?search=tick_dev_program_event

Rank 7: __netif_schedule (warning)
	Reported 104 times (501 total reports)
	[fixed] issue as a result of the multiqueue feature, fixed for 2.6.27-rc1
	This warning was last seen in version 2.6.27-rc0-git11, and first seen in 2.6.26-rc8-git.
	More info: http://www.kerneloops.org/searchweek.php?search=__netif_schedule

Rank 8: ext3_commit_super (warning)
	Reported 61 times (928 total reports)
	Likely caused by the user removing a USB stick while mounted
	This warning was last seen in version 2.6.27-rc2-git1, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=ext3_commit_super

Rank 9: dev_watchdog (warning)
	Network card transmit timeout; several sis900's and others. Dave has a simple patched queued
	up for 2.6.28 that will include the driver name in the warning, to help diagnose this issue
	better.
	Reported 61 times (241 total reports)
	This warning was last seen in version 2.6.27-rc5-git7, and first seen in 2.6.26-rc3.
	More info: http://www.kerneloops.org/searchweek.php?search=dev_watchdog

Rank 10: tick_broadcast_oneshot_control (oops)
	Reported 58 times (1331 total reports)
	Some interaction betwee tickless and system with an AMD CPU and an ATI chipset
	This oops was last seen in version 2.6.25.14, and first seen in 2.6.24-rc4.
	More info: http://www.kerneloops.org/searchweek.php?search=tick_broadcast_oneshot_control

Rank 11: drm_lastclose (oops)
	Reported 45 times (127 total reports)
	[fedora] Bug in the Fedora DRM patches
	This oops was last seen in version 2.6.25.14, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=drm_lastclose

Rank 12: ata_hsm_move (oops)
	Reported 39 times (660 total reports)
	Long standing libata bug
	This oops was last seen in version 2.6.25.14, and first seen in 2.6.25-rc9-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=ata_hsm_move

Rank 13: rs_get_rate (warning)
	Reported 38 times (284 total reports)
	Bug in the Intel IWL wireless drivers
	This warning was last seen in version 2.6.27-rc1-git5, and first seen in 2.6.25-rc2-git5.
	More info: http://www.kerneloops.org/searchweek.php?search=rs_get_rate

Rank 14: empress_querycap (oops)
	Reported 28 times (261 total reports)
	Null pointer access in the V4L layer
	This oops was last seen in version 2.6.25.14, and first seen in 2.6.25-rc8-git4.
	More info: http://www.kerneloops.org/searchweek.php?search=empress_querycap
