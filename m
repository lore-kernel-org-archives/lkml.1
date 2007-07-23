Return-Path: <linux-kernel-owner+w=401wt.eu-S935266AbXGWUVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935266AbXGWUVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932489AbXGWUUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:20:17 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42710 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764525AbXGWUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:20:10 -0400
Date: Mon, 23 Jul 2007 13:10:16 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 8/10] x86_64: remove never used apic_mapped
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707231310.16954.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 8/10] x86_64: remove never used apic_mapped

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 900ff38..70b9e2b 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -39,7 +39,6 @@
 #include <asm/hpet.h>
 #include <asm/apic.h>
 
-int apic_mapped;
 int apic_verbosity;
 int apic_runs_main_timer;
 int apic_calibrate_pmtmr __initdata;
@@ -706,8 +729,8 @@ void __init init_apic_mappings(void)
 		apic_phys = mp_lapic_addr;
 
 	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-	apic_mapped = 1;
-	apic_printk(APIC_VERBOSE,"mapped APIC to %16lx (%16lx)\n", APIC_BASE, apic_phys);
+	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+				APIC_BASE, apic_phys);
 
 	/* Put local APIC into the resource map. */
 	lapic_resource.start = apic_phys;
diff --git a/include/asm-x86_64/apic.h b/include/asm-x86_64/apic.h
index 85125ef..b9315f8 100644
--- a/include/asm-x86_64/apic.h
+++ b/include/asm-x86_64/apic.h
@@ -19,7 +19,6 @@
 extern int apic_verbosity;
 extern int apic_runs_main_timer;
 extern int ioapic_force;
-extern int apic_mapped;
 
 /*
  * Define the default level of output to be very little
