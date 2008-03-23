Return-Path: <linux-kernel-owner+w=401wt.eu-S933116AbYCWIxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbYCWIxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760154AbYCWILo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:44 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2341 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760112AbYCWILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:36 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 125/148] include/asm-x86/tce.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:40 -0700
Message-Id: <1206259443-13210-126-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/tce.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/tce.h b/include/asm-x86/tce.h
index cd955d3..b1a4ea0 100644
--- a/include/asm-x86/tce.h
+++ b/include/asm-x86/tce.h
@@ -39,7 +39,7 @@ struct iommu_table;
 #define TCE_RPN_MASK     0x0000fffffffff000ULL
 
 extern void tce_build(struct iommu_table *tbl, unsigned long index,
-        unsigned int npages, unsigned long uaddr, int direction);
+		      unsigned int npages, unsigned long uaddr, int direction);
 extern void tce_free(struct iommu_table *tbl, long index, unsigned int npages);
 extern void * __init alloc_tce_table(void);
 extern void __init free_tce_table(void *tbl);
-- 
1.5.4.rc2

