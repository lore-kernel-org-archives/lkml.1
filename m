Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbYFPSYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbYFPSYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYFPSYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:24:39 -0400
Received: from mga10.intel.com ([192.55.52.92]:32798 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751971AbYFPSYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:24:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,654,1204531200"; 
   d="scan'208";a="578500861"
Message-ID: <4856AFDF.5080901@linux.intel.com>
Date: Mon, 16 Jun 2008 11:24:31 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Oops report for the week preceding June 16th, 2008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This week, a total of 3877 oopses and warnings have been reported,
compared to 3390 reports in the previous week.

Recently, Fedora put out an updated kernel that contained a wireless update;
unfortunately, this update was rather broken and caused various things to show up
in the top 20. A few days later, another update fixing the most obvious ones
got released with the result that only rank 2 and 9 are from the broken update,
rather than a lot more..

A new feature this week: for certain type of oopses (need to happen in vmlinux etc),
the website now shows a mixed view of code/disassembly of the oops.
For example, on http://www.kerneloops.org/searchweek.php?search=page_remove_rmap
you can hover your mouse over the "Decode" word and it'll show the disassembled view.
This information is also part of the detailed view of each oops that is suitable,
and is also in the git exported view (git clone git://www.kerneloops.org/ )



Per file statistics
570	external/madwifi/wrapper (P)
323	drivers/net/wireless/b43/main.c
284	external/madwifi/binary (P)
276	drivers/parport/procfs.c
230	fs/sysfs/dir.c
208	fs/jbd/journal.c
174	security/selinux/hooks.c
137	net/mac80211/util.c
81	kernel/time/tick-broadcast.c
58	fs/ext3/super.c
49	net/mac80211/main.c
48	external/nvidia/binary (P)
45	mm/rmap.c


Seen with untainted kernels
---------------------------
Rank 2: b43_generate_noise_sample (warning)
	Reported 323 times (389 total reports)
	[fixed] too strict WARN_ON in b43 driver
	Fix available; not merged in mainline yet
	This warning was last seen in version 2.6.26-rc4-git5, and first seen in 2.6.25.3.
	More info: http://www.kerneloops.org/searchweek.php?search=b43_generate_noise_sample

Rank 4: parport_device_proc_register (warning)
	Reported 276 times (1290 total reports)
	Duplicate /proc registration in the parport driver
	This warning was last seen in version 2.6.26-rc5-git7, and first seen in 2.6.24-rc5.
	More info: http://www.kerneloops.org/searchweek.php?search=parport_device_proc_register

Rank 5: sysfs_add_one (warning)
	Reported 217 times (1280 total reports)
	Standard duplicate device name registration issue, still very much alive
	This warning was last seen in version 2.6.26-rc3, and first seen in 2.6.24-rc6.
	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one

Rank 6: journal_update_superblock (warning)
	Reported 208 times (972 total reports)
	Likely caused by the user removing a USB stick while mounted
	This warning was last seen in version 2.6.26, and first seen in 2.6.24-rc6-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=journal_update_superblock

Rank 9: ieee80211_iterate_active_interfaces (warning)
	Reported 137 times (240 total reports)
	[fedora] Fedora merged a buggy rt25xx wireless driver patch
	This warning was last seen in version 2.6.25.4, and first seen in 2.6.25.4.
	More info: http://www.kerneloops.org/searchweek.php?search=ieee80211_iterate_active_interfaces

Rank 10: tick_broadcast_oneshot_control (softlockup)
	Reported 81 times (425 total reports)
	Hard to trace down issue; but it's too frequent to be a fluke
	This softlockup was last seen in version 2.6.25.6, and first seen in 2.6.24-rc4.
	More info: http://www.kerneloops.org/searchweek.php?search=tick_broadcast_oneshot_control

Rank 11: ext3_commit_super (warning)
	Reported 53 times (237 total reports)
	Likely caused by the user removing a USB stick while mounted
	This warning was last seen in version 2.6.25.6, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=ext3_commit_super

Rank 12: default_idle (oops)
	Reported 44 times (118 total reports)
	Similar to the tick_broadcast_oneshot_control issue; hard to trace down
	This oops was last seen in version 2.6.26-rc5, and first seen in 2.6.21.3.
	More info: http://www.kerneloops.org/searchweek.php?search=default_idle
	

Only seen with tainted kernels
------------------------------	
Rank 1: ath_dynamic_sysctl_register (warning)
	Reported 376 times (3007 total reports)
	[external] Bug in the proprietary madwifi driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.6, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=ath_dynamic_sysctl_register

Rank 3: init_ath_hal (warning)
	Reported 284 times (1843 total reports)
	[external] Bug in the proprietary madwifi driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.6, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=init_ath_hal

Rank 7: ath_sysctl_register (warning)
	Reported 194 times (810 total reports)
	[external] Bug in the proprietary madwifi driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.6, and first seen in 2.6.24-rc4-git4.
	More info: http://www.kerneloops.org/searchweek.php?search=ath_sysctl_register

Rank 8: task_has_capability (warning)
	Reported 166 times (580 total reports)
	[out of tree] Bug in the proprietary firegl driver
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.6, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=task_has_capability

Rank 13: VNetBridgeDown (warning)
	Reported 41 times (230 total reports)
	[external] Bug in the proprietary VMWare drivers
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.25.6, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=VNetBridgeDown
