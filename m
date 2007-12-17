Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbXLQTf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbXLQTf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760696AbXLQTbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:35 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2953 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759317AbXLQTbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:31 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
       anton@au.ibm.com, linuxppc-dev@ozlabs.org, paulus@au.ibm.com
Subject: [PATCH] arch/powerpc/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:12 -0800
Message-Id: <1197919875-5288-13-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/boot/4xx.c                 |    2 +-
 arch/powerpc/kernel/legacy_serial.c     |    2 +-
 arch/powerpc/sysdev/bestcomm/bestcomm.h |    2 +-
 arch/powerpc/sysdev/mmio_nvram.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/boot/4xx.c b/arch/powerpc/boot/4xx.c
index ebf9e21..3d0e4f9 100644
--- a/arch/powerpc/boot/4xx.c
+++ b/arch/powerpc/boot/4xx.c
@@ -122,7 +122,7 @@ void ibm4xx_denali_fixup_memsize(void)
 	else
 		dpath = 4; /* 32 bits */
 
-	/* get adress pins (rows) */
+	/* get address pins (rows) */
 	val = mfdcr_sdram0(DDR0_42);
 
 	row = DDR_GET_VAL(val, DDR_APIN, DDR_APIN_SHIFT);
diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index 4ed5887..b9cae6b 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -474,7 +474,7 @@ static int __init serial_dev_init(void)
 
 	/*
 	 * Before we register the platfrom serial devices, we need
-	 * to fixup their interrutps and their IO ports.
+	 * to fixup their interrupts and their IO ports.
 	 */
 	DBG("Fixing serial ports interrupts and IO ports ...\n");
 
diff --git a/arch/powerpc/sysdev/bestcomm/bestcomm.h b/arch/powerpc/sysdev/bestcomm/bestcomm.h
index e802cb4..c960a8b 100644
--- a/arch/powerpc/sysdev/bestcomm/bestcomm.h
+++ b/arch/powerpc/sysdev/bestcomm/bestcomm.h
@@ -20,7 +20,7 @@ struct bcom_bd; /* defined later on ... */
 
 
 /* ======================================================================== */
-/* Generic task managment                                                   */
+/* Generic task management                                                   */
 /* ======================================================================== */
 
 /**
diff --git a/arch/powerpc/sysdev/mmio_nvram.c b/arch/powerpc/sysdev/mmio_nvram.c
index e073e24..7b49633 100644
--- a/arch/powerpc/sysdev/mmio_nvram.c
+++ b/arch/powerpc/sysdev/mmio_nvram.c
@@ -99,7 +99,7 @@ int __init mmio_nvram_init(void)
 	nvram_addr = r.start;
 	mmio_nvram_len = r.end - r.start + 1;
 	if ( (!mmio_nvram_len) || (!nvram_addr) ) {
-		printk(KERN_WARNING "nvram: address or lenght is 0\n");
+		printk(KERN_WARNING "nvram: address or length is 0\n");
 		ret = -EIO;
 		goto out;
 	}
-- 
1.5.3.7.949.g2221a6

