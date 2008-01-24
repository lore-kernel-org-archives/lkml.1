Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYAXQ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYAXQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYAXQxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:15 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64231 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbYAXQxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:05 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 13/17] [MIPS] Malta, Atlas: move an extern function declaration to the header file
Date: Thu, 24 Jan 2008 19:52:53 +0300
Message-Id: <1201193577-4261-14-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was compile-tested using default configs for the boards
affected by this change.

This patch does not introduce any functional changes.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/atlas/atlas_setup.c |    4 ----
 arch/mips/mips-boards/malta/malta_setup.c |    4 ----
 include/asm-mips/mips-boards/generic.h    |    4 ++++
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/mips/mips-boards/atlas/atlas_setup.c b/arch/mips/mips-boards/atlas/atlas_setup.c
index 5ce8004..5c50080 100644
--- a/arch/mips/mips-boards/atlas/atlas_setup.c
+++ b/arch/mips/mips-boards/atlas/atlas_setup.c
@@ -34,10 +34,6 @@
 #include <asm/time.h>
 #include <asm/traps.h>
 
-#ifdef CONFIG_KGDB
-extern void kgdb_config(void);
-#endif
-
 static void __init serial_init(void);
 
 const char *get_system_type(void)
diff --git a/arch/mips/mips-boards/malta/malta_setup.c b/arch/mips/mips-boards/malta/malta_setup.c
index 3e2de0b..8dacb6a 100644
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -35,10 +35,6 @@
 #include <linux/console.h>
 #endif
 
-#ifdef CONFIG_KGDB
-extern void kgdb_config(void);
-#endif
-
 struct resource standard_io_resources[] = {
 	{
 		.name = "dma1",
diff --git a/include/asm-mips/mips-boards/generic.h b/include/asm-mips/mips-boards/generic.h
index 2ca6bda..1c39d33 100644
--- a/include/asm-mips/mips-boards/generic.h
+++ b/include/asm-mips/mips-boards/generic.h
@@ -105,4 +105,8 @@ extern void mips_pcibios_init(void);
 #define mips_pcibios_init() do { } while (0)
 #endif
 
+#ifdef CONFIG_KGDB
+extern void kgdb_config(void);
+#endif
+
 #endif  /* __ASM_MIPS_BOARDS_GENERIC_H */
-- 
1.5.3

