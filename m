Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYGLWRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYGLWRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 18:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYGLWRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 18:17:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:39598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbYGLWRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 18:17:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,351,1212390000"; 
   d="scan'208";a="311612240"
Message-ID: <48792D5D.8070109@linux.intel.com>
Date: Sat, 12 Jul 2008 15:17:01 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Warning/Oops report for the week of July 12th 2008
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

This week, a total of 3143 oopses and warnings have been reported,
compared to 3079 reports in the previous week.


Per file statistics
418	external/madwifi/wrapper (P)
253	drivers/parport/procfs.c
252	fs/jbd/journal.c
221	fs/sysfs/dir.c
205	external/madwifi/binary (P)
184	external/fireglx/binary (P)
79	fs/ext3/super.c
75	kernel/time/tick-broadcast.c
62	external/nvidia/binary (P)
56	drivers/ata/libata-core.c
52	mm/highmem.c
51	drivers/net/wireless/b43/main.c


Seen with untainted kernels
===========================
Rank 2: parport_device_proc_register (warning)
	Reported 253 times (2260 total reports)
	Duplicate /proc registration in the parport driver
	Some patches on lkml last week, but the problem is more tricky than assumed before
	This warning was last seen in version 2.6.26-rc9-git2, and first seen in 2.6.24-rc5.
	More info: http://www.kerneloops.org/searchweek.php?search=parport_device_proc_register

Rank 3: journal_update_superblock (warning)
	Reported 246 times (1732 total reports)
	Likely caused by the user removing a USB stick while mounted
	This warning was last seen in version 2.6.26, and first seen in 2.6.24-rc6-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=journal_update_superblock

Rank 4: sysfs_add_one (warning)
	Reported 208 times (2046 total reports)
	Duplicate sysfs registration, mostly in USB layer with USB audio
	This warning was last seen in version 2.6.26-rc3, and first seen in 2.6.24-rc6.
	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one

Rank 8: ext3_commit_super (warning)
	Reported 76 times (433 total reports)
	Likely caused by the user removing a USB stick while mounted
	This warning was last seen in version 2.6.26-rc8-git2, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=ext3_commit_super

Rank 9: tick_broadcast_oneshot_control (softlockup)
	Reported 75 times (710 total reports)
	Some interaction between tickless and systems with an AMD CPU and an ATI chipset
	This softlockup was last seen in version 2.6.25.10, and first seen in 2.6.24-rc4.
	More info: http://www.kerneloops.org/searchweek.php?search=tick_broadcast_oneshot_control

Rank 10: ata_hsm_move (oops)
	Reported 56 times (291 total reports)
	This oops was last seen in version 2.6.25.9, and first seen in 2.6.25-rc9-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=ata_hsm_move

Rank 11: set_page_address (warning)
	Reported 52 times (215 total reports)
	Non-highmem page found....
	Only seen with the 915 DRM driver loaded
	This warning was last seen in version 2.6.25.9, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=set_page_address

Rank 12: flush_workqueue (oops)
	Reported 50 times (94 total reports)
	[fedora] Fedora merged a buggy rt25xx wireless driver patch
	This oops was last seen in version 2.6.25.10, and first seen in 2.6.25.9.
	More info: http://www.kerneloops.org/searchweek.php?search=flush_workqueue

Rank 13: b43_generate_noise_sample (warning)
	Reported 49 times (1173 total reports)
	[fixed] too strict WARN_ON in b43 driver
	This warning was last seen in version 2.6.26-rc4-git5, and first seen in 2.6.25.3.
	More info: http://www.kerneloops.org/searchweek.php?search=b43_generate_noise_sample

Only seen with tainted kernels
==============================
Rank 1: ath_dynamic_sysctl_register (warning)
	Reported 340 times (4734 total reports)
	[external] Bug in the proprietary madwifi driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.9, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=ath_dynamic_sysctl_register

Rank 5: init_ath_hal (warning)
	Reported 205 times (2873 total reports)
	[external] Bug in the proprietary madwifi driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.9, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=init_ath_hal

Rank 6: firegl_ioctl (warning)
	Reported 155 times (1166 total reports)
	[external] Bug in the proprietary fireglx driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.10, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=firegl_ioctl

Rank 7: ath_sysctl_register (warning)
	Reported 78 times (1187 total reports)
	[external] Bug in the proprietary madwifi driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.9, and first seen in 2.6.24-rc4-git4.
	More info: http://www.kerneloops.org/searchweek.php?search=ath_sysctl_register
	
