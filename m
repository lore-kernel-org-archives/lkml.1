Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbZEOSB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbZEOSB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZEOR7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:59:52 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2045 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZEOR7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:59:51 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] arch/powerpc: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 10:59:38 -0700
Message-Id: <af190b65b5312146ef3bb2601bbf66a6156acb7f.1242407227.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b.dirty
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/platforms/pseries/eeh_cache.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_cache.c b/arch/powerpc/platforms/pseries/eeh_cache.c
index ce37040..eb355f1 100644
--- a/arch/powerpc/platforms/pseries/eeh_cache.c
+++ b/arch/powerpc/platforms/pseries/eeh_cache.c
@@ -163,10 +163,8 @@ pci_addr_cache_insert(struct pci_dev *dev, unsigned long alo,
 	piar->pcidev = dev;
 	piar->flags = flags;
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "PIAR: insert range=[%lx:%lx] dev=%s\n",
-	                  alo, ahi, pci_name (dev));
-#endif
+	pr_debug("PIAR: insert range=[%lx:%lx] dev=%s\n",
+		 alo, ahi, pci_name (dev));
 
 	rb_link_node(&piar->rb_node, parent, p);
 	rb_insert_color(&piar->rb_node, &pci_io_addr_cache_root.rb_root);
-- 
1.6.3.1.9.g95405b.dirty

