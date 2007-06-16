Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbXFPKYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbXFPKYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbXFPKYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:24:12 -0400
Received: from www.osadl.org ([213.239.205.134]:37144 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753077AbXFPKYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:24:09 -0400
Message-Id: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 16 Jun 2007 10:36:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch-mm 00/25] High resolution timer updates and x86_64 support - V2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series contains:

- dyntick bugfixes for -mm (caused by the cpuidle changes in ACPI)

- updates and improvements to high resolution timer / dynticks 

- high resolution timer / dynticks support for x86_64

The x86_64 support is based on an initial patch from Chris Wright. Thanks Chris !

The patch set has been tested in the -hrt and -rt trees for quite a while
and the initial problems have been sorted out. Thanks to the folks from the
PowerTop project for testing and feedback.

The -hrt tree at http://www.tglx.de/projects/hrtimers/2.6.22-rc4/ contains
also an hpet force patch series from Venki Pallipadi, but I leave this up to
Venki to send it mainline wards.

Changes since V1:

- simplified the idle breakage fixup

- fixed a resume bug (making the famous VAIO work again)

- added a clocksource settimeofday hook for PPC (Tony Breeds)

Thanks,

	tglx
-- 

