Return-Path: <linux-kernel-owner+w=401wt.eu-S1764275AbYCWIro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764275AbYCWIro (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759989AbYCWILN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:13 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2324 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759955AbYCWILL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:11 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 046/148] include/asm-x86/ide.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:21 -0700
Message-Id: <1206259443-13210-47-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/ide.h |   58 +++++++++++++++++++++++++++++-------------------
 1 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/include/asm-x86/ide.h b/include/asm-x86/ide.h
index c2552d8..828df8a 100644
--- a/include/asm-x86/ide.h
+++ b/include/asm-x86/ide.h
@@ -22,41 +22,53 @@
 
 #define IDE_ARCH_OBSOLETE_DEFAULTS
 
-static __inline__ int ide_default_irq(unsigned long base)
+static inline int ide_default_irq(unsigned long base)
 {
 	switch (base) {
-		case 0x1f0: return 14;
-		case 0x170: return 15;
-		case 0x1e8: return 11;
-		case 0x168: return 10;
-		case 0x1e0: return 8;
-		case 0x160: return 12;
-		default:
-			return 0;
+	case 0x1f0:
+		return 14;
+	case 0x170:
+		return 15;
+	case 0x1e8:
+		return 11;
+	case 0x168:
+		return 10;
+	case 0x1e0:
+		return 8;
+	case 0x160:
+		return 12;
+	default:
+		return 0;
 	}
 }
 
-static __inline__ unsigned long ide_default_io_base(int index)
+static inline unsigned long ide_default_io_base(int index)
 {
 	/*
-	 *	If PCI is present then it is not safe to poke around
-	 *	the other legacy IDE ports. Only 0x1f0 and 0x170 are
-	 *	defined compatibility mode ports for PCI. A user can 
-	 *	override this using ide= but we must default safe.
+	 * If PCI is present then it is not safe to poke around
+	 * the other legacy IDE ports. Only 0x1f0 and 0x170 are
+	 * defined compatibility mode ports for PCI. A user can
+	 * override this using ide= but we must default safe.
 	 */
 	if (no_pci_devices()) {
-		switch(index) {
-			case 2: return 0x1e8;
-			case 3: return 0x168;
-			case 4: return 0x1e0;
-			case 5: return 0x160;
+		switch (index) {
+		case 2:
+			return 0x1e8;
+		case 3:
+			return 0x168;
+		case 4:
+			return 0x1e0;
+		case 5:
+			return 0x160;
 		}
 	}
 	switch (index) {
-		case 0:	return 0x1f0;
-		case 1:	return 0x170;
-		default:
-			return 0;
+	case 0:
+		return 0x1f0;
+	case 1:
+		return 0x170;
+	default:
+		return 0;
 	}
 }
 
-- 
1.5.4.rc2

