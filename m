Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbXGKTUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbXGKTUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761845AbXGKTTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38239 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760301AbXGKTTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:10 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 03/33] include/asm-i386/boot.h: This is <asm/boot.h>, not <linux/boot.h>
Date: Wed, 11 Jul 2007 12:18:28 -0700
Message-Id: <11841815392122-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815382283-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
Message-Id: <c20a5e19075b8eb5a5dd5f350c2012a71f072d56.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

include/asm-i386/boot.h incorrectly has the multiple include guards
as _LINUX_BOOT_H instead of _ASM_BOOT_H.  Fix.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-i386/boot.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-i386/boot.h b/include/asm-i386/boot.h
index bd024ab..ed8affb 100644
--- a/include/asm-i386/boot.h
+++ b/include/asm-i386/boot.h
@@ -1,5 +1,5 @@
-#ifndef _LINUX_BOOT_H
-#define _LINUX_BOOT_H
+#ifndef _ASM_BOOT_H
+#define _ASM_BOOT_H
 
 /* Don't touch these, unless you really know what you're doing. */
 #define DEF_INITSEG	0x9000
@@ -17,4 +17,4 @@
 				+ (CONFIG_PHYSICAL_ALIGN - 1)) \
 				& ~(CONFIG_PHYSICAL_ALIGN - 1))
 
-#endif /* _LINUX_BOOT_H */
+#endif /* _ASM_BOOT_H */
-- 
1.5.2.2

