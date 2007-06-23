Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbXFWNWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbXFWNWH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbXFWNVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:21:54 -0400
Received: from www.osadl.org ([213.239.205.134]:59155 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752369AbXFWNVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:21:53 -0400
Message-Id: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch-mm 00/28] High resolution timer updates and x86_64 support - V3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series contains:

- dyntick bugfixes for -mm (caused by the cpuidle changes in ACPI)

- updates and improvements to high resolution timer / dynticks 

- high resolution timer / dynticks support for x86_64

The x86_64 support is based on an initial patch from Chris Wright. Thanks Chris !

The overall diffstat of the patchset is:
 50 files changed, 843 insertions(+), 1477 deletions(-)

The patch set has been tested in the -hrt and -rt trees for quite a while
and the initial problems have been sorted out. Thanks to the folks from the
PowerTop project for testing and feedback.

Changes since V2:

- dropped clocksource settimeofday hook for PPC
- fixed compile breakage of vmiclock
- coding style fixups
- better patch split


The patch series is also available from the hrtimers project site:

http://www.tglx.de/projects/hrtimers/2.6.22-rc4-mm2/patch-2.6.22-rc4-mm2-hrt6.patch
http://www.tglx.de/projects/hrtimers/2.6.22-rc4-mm2/patch-2.6.22-rc4-mm2-hrt6.patches.tar.bz2

Note: these patches also contain the recently posted HPET force enable
series from Venki.

Thanks,

	tglx
-- 

