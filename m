Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbXDNVXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbXDNVXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXDNVV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:57 -0400
Received: from gw.goop.org ([64.81.55.164]:59558 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbXDNVUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:16 -0400
Message-Id: <20070414204924.272309498@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/28] i386: now its ok to use identify_boot_cpu
Content-Disposition: inline; filename=cleanup-identify_cpu-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/cpu/bugs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/i386/kernel/cpu/bugs.c
+++ b/arch/i386/kernel/cpu/bugs.c
@@ -177,7 +177,7 @@ static void __init check_config(void)
 
 void __init check_bugs(void)
 {
-	identify_cpu(&boot_cpu_data);
+	identify_boot_cpu();
 #ifndef CONFIG_SMP
 	printk("CPU: ");
 	print_cpu_info(&boot_cpu_data);

-- 

