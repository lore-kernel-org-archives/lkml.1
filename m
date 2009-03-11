Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZCKV65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZCKV65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZCKV6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:58:06 -0400
Received: from smtp103.biz.mail.mud.yahoo.com ([68.142.200.238]:21736 "HELO
	smtp103.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753992AbZCKV6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:58:05 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: LHAIaokVM1mc_3PevQqpLWbgftbaonrSUY0g2sJPhWI2MPuFOTKk2uJwvn4dhYf6Oe2ZpQuyF0cktXVUMRsATWg8oG9BgFcKsEvpnpTyxuKf6GqTjgQYyu_6Fv2oxBwi4hneNc.zup_AoEf7HCf95.UDIsG6mui5S4w9sFXWYwX9ne.qHf0hzgNix55iiXTgNY21ClKPPf1e7wrxzCLUh76I27kh8vj0xkwYoYh_Dqlf7kA-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 03/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:55:52 -0800
User-Agent: KMail/1.9.10
Organization: fdwdc.com
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111455.52426.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68k/include/asm/m5206sim.h b/arch/m68k/include/asm/m5206sim.h
index 7e3594d..7be8a2d 100644
--- a/arch/m68k/include/asm/m5206sim.h
+++ b/arch/m68k/include/asm/m5206sim.h
@@ -85,10 +85,16 @@
 #define	MCFSIM_PAR		0xcb		/* Pin Assignment reg (r/w) */
 #endif
 
-#define	MCFSIM_PADDR		0x1c5		/* Parallel Direction (r/w) */
-#define	MCFSIM_PADAT		0x1c9		/* Parallel Port Value (r/w) */
+#define	MCFSIM_PADDR		(MCF_MBAR + 0x1c5)	/* Parallel Direction (r/w) */
+#define	MCFSIM_PADAT		(MCF_MBAR + 0x1c9)	/* Parallel Port Value (r/w) */
 
 /*
+ * Generic GPIO
+ */
+#define MCFGPIO_PIN_MAX		8
+#define MCFGPIO_IRQ_VECBASE	-1
+#define MCFGPIO_IRQ_MAX		-1
+/*
  *	Some symbol defines for the Parallel Port Pin Assignment Register
  */
 #ifdef CONFIG_M5206e
