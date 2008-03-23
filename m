Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbYCWIqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbYCWIqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbYCWILG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:06 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2320 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759472AbYCWILE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:04 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 075/148] include/asm-x86/msidef.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:50 -0700
Message-Id: <1206259443-13210-76-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/msidef.h |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/msidef.h b/include/asm-x86/msidef.h
index 5b8acdd..296f29c 100644
--- a/include/asm-x86/msidef.h
+++ b/include/asm-x86/msidef.h
@@ -11,7 +11,8 @@
 
 #define MSI_DATA_VECTOR_SHIFT		0
 #define  MSI_DATA_VECTOR_MASK		0x000000ff
-#define	 MSI_DATA_VECTOR(v)		(((v) << MSI_DATA_VECTOR_SHIFT) & MSI_DATA_VECTOR_MASK)
+#define	 MSI_DATA_VECTOR(v)		(((v) << MSI_DATA_VECTOR_SHIFT) & \
+					 MSI_DATA_VECTOR_MASK)
 
 #define MSI_DATA_DELIVERY_MODE_SHIFT	8
 #define  MSI_DATA_DELIVERY_FIXED	(0 << MSI_DATA_DELIVERY_MODE_SHIFT)
@@ -37,11 +38,14 @@
 #define	 MSI_ADDR_DEST_MODE_LOGICAL	(1 << MSI_ADDR_DEST_MODE_SHIFT)
 
 #define MSI_ADDR_REDIRECTION_SHIFT	3
-#define  MSI_ADDR_REDIRECTION_CPU	(0 << MSI_ADDR_REDIRECTION_SHIFT) /* dedicated cpu */
-#define  MSI_ADDR_REDIRECTION_LOWPRI	(1 << MSI_ADDR_REDIRECTION_SHIFT) /* lowest priority */
+#define  MSI_ADDR_REDIRECTION_CPU	(0 << MSI_ADDR_REDIRECTION_SHIFT)
+					/* dedicated cpu */
+#define  MSI_ADDR_REDIRECTION_LOWPRI	(1 << MSI_ADDR_REDIRECTION_SHIFT)
+					/* lowest priority */
 
 #define MSI_ADDR_DEST_ID_SHIFT		12
 #define	 MSI_ADDR_DEST_ID_MASK		0x00ffff0
-#define  MSI_ADDR_DEST_ID(dest)		(((dest) << MSI_ADDR_DEST_ID_SHIFT) & MSI_ADDR_DEST_ID_MASK)
+#define  MSI_ADDR_DEST_ID(dest)		(((dest) << MSI_ADDR_DEST_ID_SHIFT) & \
+					 MSI_ADDR_DEST_ID_MASK)
 
 #endif /* ASM_MSIDEF_H */
-- 
1.5.4.rc2

