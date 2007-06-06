Return-Path: <linux-kernel-owner+w=401wt.eu-S935803AbXFFUxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935803AbXFFUxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934560AbXFFUx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:53:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:7500 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935011AbXFFUx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:53:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="254023601"
Date: Wed, 6 Jun 2007 13:49:47 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Adam Belay <abelay@novell.com>, Len Brown <len.brown@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Shaohua Li <shaohua.li@intel.com>,
       linux-acpi@vger.kernel.org
Subject: [PATCH 1/8] cpuidle: acpi_set_cstate_limit compile fix
Message-ID: <20070606204947.GA23906@linux-os.sc.intel.com>
References: <1174722412.32554.81.camel@localhost.localdomain> <200705312117.48690.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705312117.48690.lenb@kernel.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Len,

Following are a bunch of small changes to cpuidle trying to prepare it
for mainline. Some of the changes are just the compile timer errors/warnings
and you probably already have them in acpi-test.

Should apply cleanly to latest acpi-test. Please include in acpi-test.

Thanks,
Venki

This patch:


cpuidle compile fix related to acpi_set_cstate_limit().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/drivers/acpi/osl.c
===================================================================
--- linux-2.6.22-rc-mm.orig/drivers/acpi/osl.c	2007-06-01 16:17:40.000000000 -0700
+++ linux-2.6.22-rc-mm/drivers/acpi/osl.c	2007-06-01 16:21:43.000000000 -0700
@@ -1030,6 +1030,7 @@
 	if (acpi_do_set_cstate_limit)
 		acpi_do_set_cstate_limit();
 }
+EXPORT_SYMBOL(acpi_set_cstate_limit);
 
 /*
  * Acquire a spinlock.
