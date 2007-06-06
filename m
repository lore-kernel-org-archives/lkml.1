Return-Path: <linux-kernel-owner+w=401wt.eu-S935965AbXFFU4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935965AbXFFU4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935012AbXFFU4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:56:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:16062 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934828AbXFFU4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:56:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="94173040"
Date: Wed, 6 Jun 2007 13:52:52 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Adam Belay <abelay@novell.com>, Len Brown <len.brown@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Shaohua Li <shaohua.li@intel.com>,
       linux-acpi@vger.kernel.org
Subject: [PATCH 4/8] cpuidle: fis the uninitialized variable in sysfs routine
Message-ID: <20070606205252.GD23906@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Fix the uninitialized usage of ret.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/drivers/cpuidle/sysfs.c
===================================================================
--- linux-2.6.22-rc-mm.orig/drivers/cpuidle/sysfs.c	2007-06-04 15:44:17.000000000 -0700
+++ linux-2.6.22-rc-mm/drivers/cpuidle/sysfs.c	2007-06-04 15:46:49.000000000 -0700
@@ -301,7 +301,7 @@
  */
 int cpuidle_add_driver_sysfs(struct cpuidle_device *device)
 {
-	int i, ret;
+	int i, ret = -ENOMEM;
 	struct cpuidle_state_kobj *kobj;
 
 	/* state statistics */
