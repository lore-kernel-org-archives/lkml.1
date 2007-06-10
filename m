Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbXFJJbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbXFJJbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbXFJJaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:30:52 -0400
Received: from www.osadl.org ([213.239.205.134]:43008 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747AbXFJJav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:30:51 -0400
Message-Id: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:43:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 00/23] High resolution timer updates and x86_64 support
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

Thanks,

	tglx

-- 

