Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXGKTXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXGKTXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932522AbXGKTTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:31 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbXGKTT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:29 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 12/33] x86-64: add symbolic constants for the boot segment selectors
Date: Wed, 11 Jul 2007 12:18:37 -0700
Message-Id: <11841815401013-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815402349-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
 <11841815393975-git-send-email-hpa@zytor.com>
 <11841815393014-git-send-email-hpa@zytor.com>
 <1184181539416-git-send-email-hpa@zytor.com>
 <118418153972-git-send-email-hpa@zytor.com>
 <11841815391923-git-send-email-hpa@zytor.com>
 <11841815403678-git-send-email-hpa@zytor.com>
 <11841815403041-git-send-email-hpa@zytor.com>
 <11841815402349-git-send-email-hpa@zytor.com>
Message-Id: <9c629383add61d72f69fde427153cb6b57f22188.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Add symbolic constants for the segment selectors/GDT slots used by
the setup code, for consistency with i386.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-x86_64/segment.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86_64/segment.h b/include/asm-x86_64/segment.h
index adf2bf1..04b8ab2 100644
--- a/include/asm-x86_64/segment.h
+++ b/include/asm-x86_64/segment.h
@@ -3,6 +3,14 @@
 
 #include <asm/cache.h>
 
+/* Simple and small GDT entries for booting only */
+
+#define GDT_ENTRY_BOOT_CS		2
+#define __BOOT_CS	(GDT_ENTRY_BOOT_CS * 8)
+
+#define GDT_ENTRY_BOOT_DS		(GDT_ENTRY_BOOT_CS + 1)
+#define __BOOT_DS	(GDT_ENTRY_BOOT_DS * 8)
+
 #define __KERNEL_CS	0x10
 #define __KERNEL_DS	0x18
 
-- 
1.5.2.2

