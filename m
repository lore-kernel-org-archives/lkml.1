Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYEWQTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYEWQTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYEWQTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:19:41 -0400
Received: from mga12.intel.com ([143.182.124.36]:60932 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750846AbYEWQTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:19:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,530,1204531200"; 
   d="scan'208";a="251386490"
Message-ID: <4836EE8C.1010200@linux.intel.com>
Date: Fri, 23 May 2008 09:19:24 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Top 10 bugs/warnings for the week of March 23rd, 2008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The http://www.kerneloops.org website collects kernel oops and
warning reports from various mailing lists and bugzillas as well as
with a client users can install to auto-submit oopses.
Below is a top 10 list of the oopses collected in the last 7 days.
(Reports prior to 2.6.23 have been omitted in collecting the top 10)

This week, a total of 3192 oopses and warnings have been reported,
compared to 1503 reports in the previous week.


Per file statistics
[I'd love to borrow Linus' gitstat stuff for this to get a nicer presentation of the per file/directory data]
1267 kernel/sysctl.c
283	fs/sysfs/dir.c
266	fs/buffer.c
111	lib/iomap.c
81	kernel/spinlock.c
51	mm/page_alloc.c
49	net/mac80211/main.c
38	kernel/irq/manage.c
38	security/selinux/hooks.c
34	net/core/sock.c


Rank 1: __register_sysctl_paths
	Reported 1260 times (2491 total reports)
	[tainted] Duplicate /proc registration. Bug in the madwifi driver
	(Occasionally seen in the parport driver)
	This oops was last seen in version 2.6.25.4, and first seen in 2.6.25-rc3.
	More info: http://www.kerneloops.org/searchweek.php?search=__register_sysctl_paths

Rank 2: sysfs_add_one
	Reported 264 times (528 total reports)
	Duplicate sysfs registration... mostly a GregKH bug ...
	This oops was last seen in version 2.6.26-rc3, and first seen in 2.6.24-rc6.
	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one

Rank 3: mark_buffer_dirty
	Reported 253 times (547 total reports)
	EXT3 bug while hot-removing a USB device
	This oops was last seen in version 2.6.25.3, and first seen in 2.6.24-rc6.
	More info: http://www.kerneloops.org/searchweek.php?search=mark_buffer_dirty

Rank 4: bad_io_access
	Reported 111 times (153 total reports)
	Bug with pata_isapnp causing another ata driver to go SPLAT
	Patch available in http://bugzilla.kernel.org/show_bug.cgi?id=10752
	This oops was last seen in version 2.6.25.3, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=bad_io_access

Rank 5: _spin_unlock_irqrestore
	Reported 80 times (207 total reports)
	Seems to happen mostly around the idle loop.. weak voltage regulators?
	This oops was last seen in version 2.6.25.3, and first seen in 2.6.22-rc1.
	More info: http://www.kerneloops.org/searchweek.php?search=_spin_unlock_irqrestore

Rank 6: ieee80211_stop_tx_ba_session
	Reported 49 times (104 total reports)
	A bug in the iwl4965 driver
	This oops was last seen in version 2.6.25.3, and first seen in 2.6.25-rc7-git6.
	More info: http://www.kerneloops.org/searchweek.php?search=ieee80211_stop_tx_ba_session

Rank 7: __alloc_pages
	Reported 49 times (79 total reports)
	This oops was last seen in version 2.6.25.3, and first seen in 2.6.18-rc1.
	Bugs in the sata_nv and velocity drivers.
	sata_nv patch available at http://lkml.org/lkml/2008/5/20/604
	More info: http://www.kerneloops.org/searchweek.php?search=__alloc_pages

Rank 8: set_irq_wake
	Reported 38 times (43 total reports)
	[fixed] Bug in serial_core.c where disable_irq_wake/enable_irq_wake were unbalanced
	Fix available at http://lkml.org/lkml/2008/5/20/218 (and in -mm)
	This oops was last seen in version 2.6.25.3, and first seen in 2.6.25-rc9-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=set_irq_wake

Rank 9: task_has_capability
	Reported 34 times
	[tainted] Bug in the proprietary firegl driver
	Oops only shows up in tainted kernels
	This oops was last seen in version 2.6.25.3, and first seen in 2.6.25.
	More info: http://www.kerneloops.org/searchweek.php?search=task_has_capability

Rank 10: sk_free
	Reported 29 times (109 total reports)
	[tainted] VMWare driver bug
	Oops only shows up in tainted kernels
	This oops was last seen in version 2.6.25.4, and first seen in 2.6.23.9.
	More info: http://www.kerneloops.org/searchweek.php?search=sk_free
