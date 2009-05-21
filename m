Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbZEUXAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbZEUXAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZEUXA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:00:27 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2549 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZEUXA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:00:26 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, x86@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [PATCH 0/3] Introduce and use DO_ONCE statement expression macro
Date: Thu, 21 May 2009 16:00:21 -0700
Message-Id: <cover.1242943463.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The printk_once macro in kernel.h is limited to printk
This generalizes the functionality of printk_once and
allows statements like DO_ONCE(pr_info("foo\n"))
and DO_ONCE(initialize(foo));

Joe Perches (3):
  kernel.h: Add DO_ONCE statement expression macro
  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: Use DO_ONCE & spelling fix
  kernel.h: Remove unused printk_once

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 ++--
 include/linux/kernel.h                     |   27 ++++++++++++---------------
 2 files changed, 14 insertions(+), 17 deletions(-)

