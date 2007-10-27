Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbXJ0UCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbXJ0UCu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 16:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXJ0UCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 16:02:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45468 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbXJ0UCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 16:02:42 -0400
Date: Sat, 27 Oct 2007 21:02:32 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: buytenh@wantstofly.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH] fix breakage in pegasos_eth (fallout from commit b45d9147f1582333e180e1023624c003874b7312)
Message-ID: <20071027200232.GS8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/linux/mv643xx_eth.h b/include/linux/mv643xx_eth.h
index 3f27239..8df230a 100644
--- a/include/linux/mv643xx_eth.h
+++ b/include/linux/mv643xx_eth.h
@@ -8,6 +8,9 @@
 #define MV643XX_ETH_NAME		"mv643xx_eth"
 #define MV643XX_ETH_SHARED_REGS		0x2000
 #define MV643XX_ETH_SHARED_REGS_SIZE	0x2000
+#define MV643XX_ETH_BAR_4	0x220
+#define MV643XX_ETH_SIZE_REG_4	0x224
+#define MV643XX_ETH_BASE_ADDR_ENABLE_REG	0x0290
 
 struct mv643xx_eth_platform_data {
 	int		port_number;
