Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbXGUSmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbXGUSmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbXGUSmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:42:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbXGUSmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:42:05 -0400
Date: Sat, 21 Jul 2007 14:42:01 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: fix modular compilation of pmu_battery
Message-ID: <20070721184201.GA23306@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pmu_battery fails to compile as a module on ppc64.

ERROR: "pmu_batteries" [drivers/power/pmu_battery.ko] undefined!
ERROR: "pmu_battery_count" [drivers/power/pmu_battery.ko] undefined!
ERROR: "pmu_power_flags" [drivers/power/pmu_battery.ko] undefined!

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.22.noarch/drivers/macintosh/via-pmu.c~	2007-07-20 20:45:27.000000000 -0400
+++ linux-2.6.22.noarch/drivers/macintosh/via-pmu.c	2007-07-20 20:45:52.000000000 -0400
@@ -2842,10 +2842,10 @@ EXPORT_SYMBOL(pmu_wait_complete);
 EXPORT_SYMBOL(pmu_suspend);
 EXPORT_SYMBOL(pmu_resume);
 EXPORT_SYMBOL(pmu_unlock);
-#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
+#if defined(CONFIG_PM)
 EXPORT_SYMBOL(pmu_enable_irled);
 EXPORT_SYMBOL(pmu_battery_count);
 EXPORT_SYMBOL(pmu_batteries);
 EXPORT_SYMBOL(pmu_power_flags);
-#endif /* CONFIG_PM && CONFIG_PPC32 */
+#endif
 

-- 
http://www.codemonkey.org.uk
