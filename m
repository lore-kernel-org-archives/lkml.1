Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbXGOUEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbXGOUEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXGOUBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:01:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39959 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700AbXGOUBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:01:32 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] icside: devm_iounmap() needs linux/io.h
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Message-Id: <E1IAAHc-00056q-13@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:01:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/ide/arm/icside.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 444a0b8..c89b5f4 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -18,10 +18,10 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/scatterlist.h>
+#include <linux/io.h>
 
 #include <asm/dma.h>
 #include <asm/ecard.h>
-#include <asm/io.h>
 
 #define ICS_IDENT_OFFSET		0x2280
 
-- 
1.5.3.GIT

