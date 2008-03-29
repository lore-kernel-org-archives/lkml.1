Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbYC2DOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbYC2DOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759641AbYC2DLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:11:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58370 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbYC2DLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:11:09 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] dm9000 trivial annotation
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1JfRTI-000332-Lx@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:11:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/dm9000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/dm9000.c b/drivers/net/dm9000.c
index b09a53d..d63cc93 100644
--- a/drivers/net/dm9000.c
+++ b/drivers/net/dm9000.c
@@ -968,7 +968,7 @@ dm9000_interrupt(int irq, void *dev_id)
 struct dm9000_rxhdr {
 	u8	RxPktReady;
 	u8	RxStatus;
-	u16	RxLen;
+	__le16	RxLen;
 } __attribute__((__packed__));
 
 /*
-- 
1.5.3.GIT

