Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbZCKWBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbZCKWBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZCKV6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:58:19 -0400
Received: from smtp108.biz.mail.mud.yahoo.com ([68.142.201.177]:39275 "HELO
	smtp108.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754368AbZCKV6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:58:16 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: y4.DuH0VM1lYvA2T397GuvWANjIlIhv56FbPUjNDKEACav2jUQzdwiYBiediMCu1mzbejeiDPHZGcUXbXo844WZqgTw0rHmeyU.HS3OSDlnYQa6.rE2jVIbwAvyjzDjUsWtqBvItz_wFnwoM9jo9_vmmSvhJk5h8OU_7ACvX_YuC2zBjOyI3ZnRr1pKV4kGcNXTWZq5Qq6BQaW80R4o7kSyDPlQ2p1jvmlT6XSvAXvDQgME-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 10/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:56:05 -0800
User-Agent: KMail/1.9.10
Organization: fdwdc.com
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111456.05282.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68k/include/asm/m5307sim.h b/arch/m68k/include/asm/m5307sim.h
index 5886728..6a1870c 100644
--- a/arch/m68k/include/asm/m5307sim.h
+++ b/arch/m68k/include/asm/m5307sim.h
@@ -90,8 +90,15 @@
 #define MCFSIM_DACR1		0x110		/* DRAM 1 Addr and Ctrl (r/w) */
 #define MCFSIM_DMR1		0x114		/* DRAM 1 Mask reg (r/w) */
 
-#define	MCFSIM_PADDR		0x244		/* Parallel Direction (r/w) */
-#define	MCFSIM_PADAT		0x248		/* Parallel Data (r/w) */
+#define	MCFSIM_PADDR		(MCF_MBAR + 0x244)
+#define	MCFSIM_PADAT		(MCF_MBAR + 0x248)
+
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PIN_MAX			16
+#define MCFGPIO_IRQ_MAX			-1
+#define MCFGPIO_IRQ_VECBASE		-1
 
 
 /* Definition offset address for CS2-7  -- old mask 5307 */
