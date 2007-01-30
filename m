Return-Path: <linux-kernel-owner+w=401wt.eu-S965362AbXA3NXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362AbXA3NXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965364AbXA3NXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:23:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41143 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965362AbXA3NXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:23:31 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] mtd/nand/cafe.c missing include of dma-mapping.h
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Message-Id: <E1HBsxO-0002Ma-UR@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 30 Jan 2007 13:23:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/mtd/nand/cafe.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/cafe.c b/drivers/mtd/nand/cafe.c
index b8d9b64..65f9bd3 100644
--- a/drivers/mtd/nand/cafe.c
+++ b/drivers/mtd/nand/cafe.c
@@ -14,6 +14,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
 #include <asm/io.h>
 
 #define CAFE_NAND_CTRL1		0x00
-- 
1.5.0-rc2.GIT


