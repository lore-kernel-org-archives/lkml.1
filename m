Return-Path: <linux-kernel-owner+w=401wt.eu-S932858AbXHNSL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbXHNSL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760808AbXHNSLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:11:19 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:41666 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331AbXHNSLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KPyQ7kYGhOWUDXG7+4/AdXgvTOpCtxnJdqdNRAnirK3QnKSMePpUxzIdcnwt9DGDE7vqgP7qG0P0dtTTLGDh7tZigMVIkASI815zUulNLUhpLYKNSVC46ILKW17iy9VPgCPkfSO1K/wXvM+ZYC/+KcUW7TEGMDVPSvxUaSOR/0I=
Message-ID: <5767b9100708141111ke19e7e5xaa555556e9633f83@mail.gmail.com>
Date: Wed, 15 Aug 2007 02:11:17 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       ben-linux@fluff.org
Subject: [PATCH] nand/s3c2410.c: fix header file include path
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

regs-nand.h and nand.h for s3c nand driver have been moved to plat-s3c/ dir.

Signed-off-by: conke.hu@gmail.com
-------------------
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 5fac4c4..b79a9cf 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -60,8 +60,8 @@

 #include <asm/io.h>

-#include <asm/arch/regs-nand.h>
-#include <asm/arch/nand.h>
+#include <asm/plat-s3c/regs-nand.h>
+#include <asm/plat-s3c/nand.h>

 #ifdef CONFIG_MTD_NAND_S3C2410_HWECC
 static int hardware_ecc = 1;
