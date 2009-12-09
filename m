Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbZLIG1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbZLIG1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZLIG1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:27:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZLIG1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:27:44 -0500
Date: Wed, 9 Dec 2009 01:25:48 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Glauber Costa <gcosta@redhat.com>,
       Amerigo Wang <amwang@redhat.com>, Ingo Molnar <mingo@elte.hu>
Message-Id: <20091209062850.4245.11541.sendpatchset@localhost.localdomain>
Subject: [Patch] i386: remove 'usedac' kernel parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is scheduled to be removed.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Glauber Costa <gcosta@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 591e944..8c895f6 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -291,13 +291,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
 
 ---------------------------
 
-What:	usedac i386 kernel parameter
-When:	2.6.27
-Why:	replaced by allowdac and no dac combination
-Who:	Glauber Costa <gcosta@redhat.com>
-
----------------------------
-
 What: print_fn_descriptor_symbol()
 When: October 2009
 Why:  The %pF vsprintf format provides the same functionality in a
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index afcc58b..2f76c7b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -210,10 +210,6 @@ static __init int iommu_setup(char *p)
 			forbid_dac = 0;
 		if (!strncmp(p, "nodac", 5))
 			forbid_dac = 1;
-		if (!strncmp(p, "usedac", 6)) {
-			forbid_dac = -1;
-			return 1;
-		}
 #ifdef CONFIG_SWIOTLB
 		if (!strncmp(p, "soft", 4))
 			swiotlb = 1;
