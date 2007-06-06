Return-Path: <linux-kernel-owner+w=401wt.eu-S935897AbXFFUyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935897AbXFFUyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935496AbXFFUyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:54:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:3923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934955AbXFFUyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:54:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="94172284"
Date: Wed, 6 Jun 2007 13:50:36 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Adam Belay <abelay@novell.com>, Len Brown <len.brown@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Shaohua Li <shaohua.li@intel.com>,
       linux-acpi@vger.kernel.org
Subject: [PATCH 2/8] cpuidle: menu governor and hrtimer compile fix
Message-ID: <20070606205036.GB23906@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Compile fix for menu governor.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/drivers/cpuidle/governors/menu.c
===================================================================
--- linux-2.6.22-rc-mm.orig/drivers/cpuidle/governors/menu.c	2007-06-01 16:25:49.000000000 -0700
+++ linux-2.6.22-rc-mm/drivers/cpuidle/governors/menu.c	2007-06-05 17:52:33.000000000 -0700
@@ -11,8 +11,8 @@
 #include <linux/latency.h>
 #include <linux/time.h>
 #include <linux/ktime.h>
-#include <linux/tick.h>
 #include <linux/hrtimer.h>
+#include <linux/tick.h>
 
 #define BM_HOLDOFF	20000	/* 20 ms */
 
