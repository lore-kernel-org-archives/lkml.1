Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXGJDEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXGJDEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760045AbXGJDEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:04:23 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57349 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758935AbXGJDEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:04:22 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 03/33] include/asm-i386/boot.h: This is <asm/boot.h>, not <linux/boot.h>
Date: Mon,  9 Jul 2007 19:51:42 -0700
Message-Id: <11840362483663-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840361432207-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
Message-Id: <38825725eb2e4aac1dd8e312460c5c239466b39a.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
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

