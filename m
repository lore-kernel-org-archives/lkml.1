Return-Path: <linux-kernel-owner+w=401wt.eu-S1765240AbYDYVrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765240AbYDYVrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 17:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758659AbYDYVrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 17:47:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:2976 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbYDYVrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 17:47:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,709,1199692800"; 
   d="scan'208";a="274838590"
Message-ID: <48125150.9020203@linux.intel.com>
Date: Fri, 25 Apr 2008 14:46:56 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Top 10 Oops/Warning reports for the week of April 25th, 2008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing really exciting in the last week or two; we're fixing all the frequent bugs,
or the bugs are in out of tree drivers / various git trees.

For the 2.6.25 development cycle, an overview of the sightings can be seen at:

http://www.kerneloops.org/twentyfive.html


The http://www.kerneloops.org website collects kernel oops and
warning reports from various mailing lists and bugzillas as well as
with a client users can install to auto-submit oopses.
Below is a top 10 list of the oopses collected in the last 7 days.
(Reports prior to 2.6.23 have been omitted in collecting the top 10)

This week, a total of 647 oopses and warnings have been reported,
compared to 719 reports in the previous week.


Rank 1: __register_sysctl_paths
	Reported 74 times (372 total reports)
	Duplicate /proc registration. Most bugs are in madwifi but also in the parport driver
	This warning was last seen in version 2.6.25, and first seen in 2.6.25-rc3.
	More info: http://www.kerneloops.org/searchweek.php?search=__register_sysctl_paths

Rank 2: set_dentry_child_flags  [fixed]
	Reported 64 times (665 total reports)
	Bug in the 2.6.24 inotify code that got exposed by KDE4 and got fixed in 2.6.25
	This warning was last seen in version 2.6.24.4, and first seen in 2.6.24-rc8-git4.
	More info: http://www.kerneloops.org/searchweek.php?search=set_dentry_child_flags

Rank 3: mark_buffer_dirty
	Reported 43 times (144 total reports)
	EXT3 bug while hot-removing a USB device
	This warning was last seen in version 2.6.25, and first seen in 2.6.24-rc6.
	More info: http://www.kerneloops.org/searchweek.php?search=mark_buffer_dirty

Rank 4: input_release_device [fixed]
	Reported 40 times (718 total reports)
	sysfs refcounting cleanup exposed input layer issues; fixed in 2.6.25-rc9
	This oops was last seen in version 2.6.25-rc7-git4, and first seen in 2.6.25-rc2.
	More info: http://www.kerneloops.org/searchweek.php?search=input_release_device

Rank 5: sysfs_add_one
	Reported 39 times (171 total reports)
	Various buggy subsystems that register duplicate sysfs files
	This warning was last seen in version 2.6.25, and first seen in 2.6.24-rc6.
	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one

Rank 6: radeon_cp_init_ring_buffer [out of tree]
	Reported 28 times (50 total reports)
	drm.git bug in the radeon driver
	This oops was last seen in version 2.6.25, and first seen in 2.6.25-rc8-git7.
	More info: http://www.kerneloops.org/searchweek.php?search=radeon_cp_init_ring_buffer

Rank 7: sysctl_check_lookup [out of tree]
	Reported 18 times (173 total reports)
	Bug in the proprietary madwifi driver
	Oops only shows up in tainted kernels
	This warning was last seen in version 2.6.24.4, and first seen in 2.6.24-rc5.
	More info: http://www.kerneloops.org/searchweek.php?search=sysctl_check_lookup

Rank 8: sk_free [out of tree]
	Reported 16 times (23 total reports)
	VMWare driver bug
	Oops only shows up in tainted kernels
	This oops was last seen in version 2.6.25, and first seen in 2.6.23.9.
	More info: http://www.kerneloops.org/searchweek.php?search=sk_free

Rank 9: __ieee80211_rx
	Warning at net/mac80211/rx.c:2183 in __ieee80211_rx
	Reported 16 times (176 total reports)
	Seen with various wireless drivers
	This warning was last seen in version 2.6.25, and first seen in 2.6.24-rc6.
	More info: http://www.kerneloops.org/searchweek.php?search=__ieee80211_rx

Rank 10: read_apic_id
	Reported 13 times (15 total reports)
	This oops was last seen in version 2.6.25-git2, and first seen in 2.6.25-rc8.
	More info: http://www.kerneloops.org/searchweek.php?search=read_apic_id
