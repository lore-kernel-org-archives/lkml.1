Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0BIVQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:16:43 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:51531 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab0BIVQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:16:40 -0500
X-Auth-Info: I+OUROTyODn5kMsJBDanxa2GEBvgHJT8TldeDqUBAQc=
From: Anatolij Gustschin <agust@denx.de>
To: linuxppc-dev@ozlabs.org
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, gregkh@suse.de,
       jcrigby@gmail.com, dzu@denx.de, wd@denx.de,
       Anatolij Gustschin <agust@denx.de>
Subject: [PATCH v2 3/3] powerpc: mpc5121: enable support for more PSC UARTs
Date: Tue,  9 Feb 2010 22:13:52 +0100
Message-Id: <1265750032-2803-4-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265750032-2803-1-git-send-email-agust@denx.de>
References: <1265750032-2803-1-git-send-email-agust@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MPC5121 has 12 PSC devices. Enable UART support for all of
them by defining the number of max. PSCs depending on
selection of PPC_MPC512x platform support.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
No changes since v1.

 arch/powerpc/include/asm/mpc52xx_psc.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/mpc52xx_psc.h b/arch/powerpc/include/asm/mpc52xx_psc.h
index fb84120..42561f4 100644
--- a/arch/powerpc/include/asm/mpc52xx_psc.h
+++ b/arch/powerpc/include/asm/mpc52xx_psc.h
@@ -25,7 +25,11 @@
 #include <asm/types.h>
 
 /* Max number of PSCs */
+#ifdef CONFIG_PPC_MPC512x
+#define MPC52xx_PSC_MAXNUM     12
+#else
 #define MPC52xx_PSC_MAXNUM	6
+#endif
 
 /* Programmable Serial Controller (PSC) status register bits */
 #define MPC52xx_PSC_SR_UNEX_RX	0x0001
-- 
1.6.3.3

