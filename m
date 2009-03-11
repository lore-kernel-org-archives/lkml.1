Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZCKWCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZCKWCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbZCKV61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:58:27 -0400
Received: from smtp106.biz.mail.mud.yahoo.com ([68.142.200.254]:33345 "HELO
	smtp106.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754532AbZCKV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:58:26 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: .XbSjN8VM1mgbuDTnEsLkYTUY3MAUg38fT6n8DkJP_H8D7ZvHZakMYLWF.B5YlVcHU5UE04721I61X205kLjELHhX5m.jrbuj2rqhldceFK8SQWknwyka7HXfTIu1WW_3oa8Ye5VJQG07db9juDdjPSEbNA0wsdYvzmeTMWtVQ5Kk_cjzySEQFEvBMVUu_NnWj2fob8jU3yARkDqIb2IPimhXC_5L36ru064rYr7FvjYimA-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 13/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:56:13 -0800
User-Agent: KMail/1.9.10
Organization: fdwdc.com
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111456.13909.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68k/include/asm/m5407sim.h b/arch/m68k/include/asm/m5407sim.h
index cc22c4a..2519475 100644
--- a/arch/m68k/include/asm/m5407sim.h
+++ b/arch/m68k/include/asm/m5407sim.h
@@ -73,9 +73,15 @@
 #define MCFSIM_DACR1		0x110		/* DRAM 1 Addr and Ctrl (r/w) */
 #define MCFSIM_DMR1		0x114		/* DRAM 1 Mask reg (r/w) */
 
-#define	MCFSIM_PADDR		0x244		/* Parallel Direction (r/w) */
-#define	MCFSIM_PADAT		0x248		/* Parallel Data (r/w) */
+#define	MCFSIM_PADDR		(MCF_MBAR + 0x244)
+#define	MCFSIM_PADAT		(MCF_MBAR + 0x248)
 
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PIN_MAX			16
+#define MCFGPIO_IRQ_MAX			-1
+#define MCFGPIO_IRQ_VECBASE		-1
 
 /*
  *	Some symbol defines for the above...
