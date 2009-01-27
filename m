Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZA0Ibs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZA0Ibs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZA0Ibl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:31:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33626 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZA0Ibk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:31:40 -0500
Message-ID: <497EC4AB.7030703@jp.fujitsu.com>
Date: Tue, 27 Jan 2009 17:24:11 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com
Subject: [PATCH 3/3] fix typo "ACPI_PM_OVRRUN" -> "ACPI_PM_OVERRUN"
References: <497EC23A.7050408@jp.fujitsu.com>
In-Reply-To: <497EC23A.7050408@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes typo.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 arch/x86/kernel/apic.c     |    2 +-
 arch/x86/kernel/tsc.c      |    2 +-
 include/linux/acpi_pmtmr.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.29-rc2/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.29-rc2.orig/arch/x86/kernel/apic.c	2009-01-27 12:24:04.000000000 +0900
+++ linux-2.6.29-rc2/arch/x86/kernel/apic.c	2009-01-27 12:24:18.000000000 +0900
@@ -528,7 +528,7 @@ static void __init lapic_cal_handler(str
 		lapic_cal_t2 = tapic;
 		lapic_cal_tsc2 = tsc;
 		if (pm < lapic_cal_pm1)
-			pm += ACPI_PM_OVRRUN;
+			pm += ACPI_PM_OVERRUN;
 		lapic_cal_pm2 = pm;
 		lapic_cal_j2 = jiffies;
 		break;
Index: linux-2.6.29-rc2/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.29-rc2.orig/arch/x86/kernel/tsc.c	2009-01-27 12:21:20.000000000 +0900
+++ linux-2.6.29-rc2/arch/x86/kernel/tsc.c	2009-01-27 12:24:18.000000000 +0900
@@ -161,7 +161,7 @@ static unsigned long calc_pmtimer_ref(u6
 		return ULONG_MAX;

 	if (pm2 < pm1)
-		pm2 += (u64)ACPI_PM_OVRRUN;
+		pm2 += (u64)ACPI_PM_OVERRUN;
 	pm2 -= pm1;
 	tmp = pm2 * 1000000000LL;
 	do_div(tmp, PMTMR_TICKS_PER_SEC);
Index: linux-2.6.29-rc2/include/linux/acpi_pmtmr.h
===================================================================
--- linux-2.6.29-rc2.orig/include/linux/acpi_pmtmr.h	2009-01-27 12:21:20.000000000 +0900
+++ linux-2.6.29-rc2/include/linux/acpi_pmtmr.h	2009-01-27 12:24:18.000000000 +0900
@@ -10,7 +10,7 @@
 #define ACPI_PM_MASK CLOCKSOURCE_MASK(24)

 /* Overrun value */
-#define ACPI_PM_OVRRUN	(1<<24)
+#define ACPI_PM_OVERRUN	(1<<24)

 #ifdef CONFIG_X86_PM_TIMER

