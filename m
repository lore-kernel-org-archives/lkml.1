Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbZIGDLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbZIGDLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbZIGDLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:11:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60991 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758826AbZIGDLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:11:20 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 1/2] m68k: Make thread_info.h usable from assembly.
Date: Sun,  6 Sep 2009 23:11:13 -0400
Message-Id: <1252293074-13196-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/m68k/include/asm/thread_info_mm.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/include/asm/thread_info_mm.h b/arch/m68k/include/asm/thread_info_mm.h
index 6ea5c33..192dee7 100644
--- a/arch/m68k/include/asm/thread_info_mm.h
+++ b/arch/m68k/include/asm/thread_info_mm.h
@@ -4,6 +4,7 @@
 #include <asm/types.h>
 #include <asm/page.h>
 
+#ifndef __ASSEMBLY__
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
 	unsigned long		flags;
@@ -12,6 +13,7 @@ struct thread_info {
 	__u32 cpu; /* should always be 0 on m68k */
 	struct restart_block    restart_block;
 };
+#endif /* __ASSEMBLY__ */
 
 #define PREEMPT_ACTIVE		0x4000000
 
-- 
1.6.3.3

