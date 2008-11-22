Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbYKVRgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbYKVRgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbYKVReq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:34:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55371 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759132AbYKVRep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:34:45 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 9/32] W1_MASTER_DS1WM should depend on HAVE_CLK
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wNY-0006Ot-J7@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:34:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Uses clk_...() a lot

Acked-by: rmk+kernel@arm.linux.org.uk
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/w1/masters/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -36,7 +36,7 @@ config W1_MASTER_DS2482
 
 config W1_MASTER_DS1WM
 	tristate "Maxim DS1WM 1-wire busmaster"
-	depends on W1 && ARM
+	depends on W1 && ARM && HAVE_CLK
 	help
 	  Say Y here to enable the DS1WM 1-wire driver, such as that
 	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
