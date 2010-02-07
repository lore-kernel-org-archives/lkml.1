Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab0BGThK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 14:37:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:41058 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0BGThI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 14:37:08 -0500
Date: Sun, 7 Feb 2010 11:38:21 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org, agk@redhat.com,
       airlied@redhat.com, mingo@elte.hu, peterz@redhat.com,
       akpm@linux-foundation.org
Subject: [2.6.33-rc only] kerneloops.org report for the week of Feb 7 2010
 for the 2.6.33-rc kernel series
Message-ID: <20100207113821.42f36e5d@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



With the 2.6.33 kernel around the kernel, this report covers ONLY the 2.6.33-rc series;
the oopes/warning in this report are rather "fresh" in that sense... and unfixed issues
will be seen in a much wider audience once .33 gets released.

This week, a total of 1118 oopses and warnings have been reported for the 2.6.33-rc series.


Per file statistics
400	net/core/iovec.c
242	drivers/md/dm-snap-persistent.c
72	drivers/gpu/drm/drm_crtc.c
54	kernel/lockdep.c
41	drivers/pci/intel-iommu.c
30	kernel/futex.c (P)
15	arch/x86/kernel/process_32.c
14	drivers/acpi/processor_idle.c
13	lib/parser.c
12	lib/debugobjects.c
11	include/linux/kernel.h
11	arch/x86/kernel/hpet.c


Rank 1: memcpy_toiovecend (warning)
	Reported 391 times (394 total reports)
	This warning was last seen in version 2.6.33-rc5, and first seen in 2.6.33-rc5.
	More info: http://www.kerneloops.org/searchweek.php?search=memcpy_toiovecend

Rank 2: chunk_io (warning)
	Reported 242 times (478 total reports)
	This warning was last seen in version 2.6.33-rc6-git1, and first seen in 2.6.33-rc4-git3.
	More info: http://www.kerneloops.org/searchweek.php?search=chunk_io

Rank 3: drm_fb_release (oops)
	Reported 72 times
	This oops was last seen in version 2.6.33-rc7-git0, and first seen in 2.6.33-rc5-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=drm_fb_release

Rank 4: lockstat_clock (oops)
	Reported 45 times (46 total reports)
	This oops was last seen in version 2.6.33-rc6-git1, and first seen in 2.6.33-rc5-git1.
	More info: http://www.kerneloops.org/searchweek.php?search=lockstat_clock

Rank 5: macvtap_ioctl (warning)
	Reported 41 times (44 total reports)
	This warning was last seen in version 2.6.33-rc5, and first seen in 2.6.33-rc5.
	More info: http://www.kerneloops.org/searchweek.php?search=macvtap_ioctl

Rank 6: lookup_pi_state (warning)
	Reported 30 times (60 total reports)
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.33-rc6, and first seen in 2.6.24.
	More info: http://www.kerneloops.org/searchweek.php?search=lookup_pi_state

Rank 7: init_dmars (warning)
	Reported 25 times (673 total reports)
	This warning was last seen in version 2.6.33-rc7, and first seen in 2.6.31.5.
	More info: http://www.kerneloops.org/searchweek.php?search=init_dmars

Rank 8: i915_gem_do_execbuffer (oops)
	Reported 17 times (18 total reports)
	This oops was last seen in version 2.6.33-rc6, and first seen in 2.6.33-rc4.
	More info: http://www.kerneloops.org/searchweek.php?search=i915_gem_do_execbuffer

Rank 9: iommu_prepare_identity_map (warning)
	Reported 16 times (3223 total reports)
	This warning was last seen in version 2.6.33-rc6-git1, and first seen in 2.6.31.5.
	More info: http://www.kerneloops.org/searchweek.php?search=iommu_prepare_identity_map

Rank 10: cpu_idle (warning)
	Reported 15 times (214 total reports)
	This warning was last seen in version 2.6.33-rc5-git0, and first seen in 2.6.18-rc4.
	More info: http://www.kerneloops.org/searchweek.php?search=cpu_idle

Rank 11: acpi_idle_enter_bm (warning)
	Reported 14 times (5906 total reports)
	Dell Laptops oops in idle
	This warning was last seen in version 2.6.33-rc6-git0, and first seen in 2.6.23.8.
	More info: http://www.kerneloops.org/searchweek.php?search=acpi_idle_enter_bm

Rank 12: match_number (warning)
	Reported 13 times (35 total reports)
	This warning was last seen in version 2.6.33-rc7, and first seen in 2.6.27.15.
	More info: http://www.kerneloops.org/searchweek.php?search=match_number

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
