Return-Path: <linux-kernel-owner+w=401wt.eu-S1760688AbYCWIZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688AbYCWIZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759397AbYCWIJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:17 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2275 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759381AbYCWIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:15 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 081/148] include/asm-x86/numaq.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:56 -0700
Message-Id: <1206259443-13210-82-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/numaq.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/numaq.h b/include/asm-x86/numaq.h
index 38f710d..94b86c3 100644
--- a/include/asm-x86/numaq.h
+++ b/include/asm-x86/numaq.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2002, IBM Corp.
  *
- * All rights reserved.          
+ * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -33,7 +33,8 @@ extern int get_memcfg_numaq(void);
 /*
  * SYS_CFG_DATA_PRIV_ADDR, struct eachquadmem, and struct sys_cfg_data are the
  */
-#define SYS_CFG_DATA_PRIV_ADDR		0x0009d000 /* place for scd in private quad space */
+#define SYS_CFG_DATA_PRIV_ADDR		0x0009d000 /* place for scd in private
+						      quad space */
 
 /*
  * Communication area for each processor on lynxer-processor tests.
@@ -139,7 +140,7 @@ struct sys_cfg_data {
 	unsigned int	low_shrd_mem_base; /* 0 or 512MB or 1GB */
 	unsigned int	low_shrd_mem_quad_offset; /* 0,128M,256M,512M,1G */
 					/* may not be totally populated */
-	unsigned int	split_mem_enbl; /* 0 for no low shared memory */ 
+	unsigned int	split_mem_enbl; /* 0 for no low shared memory */
 	unsigned int	mmio_sz; /* Size of total system memory mapped I/O */
 				 /* (in MB). */
 	unsigned int	quad_spin_lock; /* Spare location used for quad */
@@ -152,7 +153,7 @@ struct sys_cfg_data {
 	/*
 	 *	memory configuration area for each quad
 	 */
-        struct	eachquadmem eq[MAX_NUMNODES];	/* indexed by quad id */
+	struct		eachquadmem eq[MAX_NUMNODES];	/* indexed by quad id */
 };
 
 static inline unsigned long *get_zholes_size(int nid)
-- 
1.5.4.rc2

