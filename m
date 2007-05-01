Return-Path: <linux-kernel-owner+w=401wt.eu-S1031591AbXEAD57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031591AbXEAD57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031588AbXEAD57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:57:59 -0400
Received: from mx1.suse.de ([195.135.220.2]:60905 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031591AbXEAD56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:57:58 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/30] x86 candidate patches for review VII: VDSO, CPUID, NMI watchdog, MCE, misc
Date: Tue,  1 May 2007 05:57:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The last batch of x86 patches for .22 to review.

This one contains various patches that haven't hit l-k yet. Please
review closely.

- Finally vDSO support for x86-64
  * glibc support still missing unfortunately
- New early CPUID checking for i386
- Restructured NMI watchdog code
- Dynamic MCE polling interval adaption from Tim Hockin
- Some NUMA changes
- Use RDTSCP for synchronous get_cycles if possible
- Fix APIC timer calibration on x86-64 (stable candidate too) 
- Drop CONFIG_REORDER as announced earlier
- Misc stuff

Happy reviewing!

-Andi

