Return-Path: <linux-kernel-owner+w=401wt.eu-S936959AbXGSOCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936959AbXGSOCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765072AbXGSNtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:04 -0400
Received: from ns2.suse.de ([195.135.220.15]:48654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937293AbXGSNtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:49:00 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: da-x@monatomic.org, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [29/48] x86_64: arch/x86_64/kernel/aperture.c lower printk severity
Message-Id: <20070719134859.687B414E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dan Aloni <da-x@monatomic.org>

Users that use kernel log filtering (e.g.  via syslogd or a proprietry method)
wouldn't like to see warning prints that are not really warnings.

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/aperture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/aperture.c
===================================================================
--- linux.orig/arch/x86_64/kernel/aperture.c
+++ linux/arch/x86_64/kernel/aperture.c
@@ -214,7 +214,7 @@ void __init iommu_hole_init(void) 
 	if (iommu_aperture_disabled || !fix_aperture || !early_pci_allowed())
 		return;
 
-	printk("Checking aperture...\n"); 
+	printk(KERN_INFO  "Checking aperture...\n");
 
 	fix = 0;
 	for (num = 24; num < 32; num++) {		
