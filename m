Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbZEDDkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbZEDDkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 23:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZEDDkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 23:40:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbZEDDkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 23:40:46 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] Fix a typo in a printk message
Date: Mon, 4 May 2009 09:08:26 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905040908.27299.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo in a printk message.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 16ae70f..29a0e37 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -216,7 +216,7 @@ int __init get_memcfg_from_srat(void)
 
 	if (num_memory_chunks == 0) {
 		printk(KERN_WARNING
-			 "could not finy any ACPI SRAT memory areas.\n");
+			 "could not find any ACPI SRAT memory areas.\n");
 		goto out_fail;
 	}
 

