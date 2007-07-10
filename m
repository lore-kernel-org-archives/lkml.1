Return-Path: <linux-kernel-owner+w=401wt.eu-S1762675AbXGJDUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762675AbXGJDUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760854AbXGJDUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:20:10 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49718 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbXGJDUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:20:08 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 12/33] x86-64: add symbolic constants for the boot segment selectors
Date: Mon,  9 Jul 2007 19:51:51 -0700
Message-Id: <11840371953778-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840370903975-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com>
Message-Id: <e3ff2ad47d4610cdafbe24dcabadef42bb3166fb.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
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

