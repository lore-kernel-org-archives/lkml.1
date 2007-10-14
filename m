Return-Path: <linux-kernel-owner+w=401wt.eu-S1763889AbXJNSkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763889AbXJNSkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbXJNSkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:40:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60401 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbXJNSkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:40:40 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] more tulip endianness annotations
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1Ih8OF-0004BA-7S@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:40:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/tulip/de4x5.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tulip/de4x5.h b/drivers/net/tulip/de4x5.h
index 12af0cc..9fb8d7f 100644
--- a/drivers/net/tulip/de4x5.h
+++ b/drivers/net/tulip/de4x5.h
@@ -1017,4 +1017,4 @@ struct de4x5_ioctl {
 #define DE4X5_SET_OMR           0x0d /* Set the OMR Register contents */
 #define DE4X5_GET_REG           0x0e /* Get the DE4X5 Registers */
 
-#define MOTO_SROM_BUG    ((lp->active == 8) && (((le32_to_cpu(get_unaligned(((s32 *)dev->dev_addr))))&0x00ffffff)==0x3e0008))
+#define MOTO_SROM_BUG    ((lp->active == 8) && (((le32_to_cpu(get_unaligned(((__le32 *)dev->dev_addr))))&0x00ffffff)==0x3e0008))
-- 
1.5.3.GIT


