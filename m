Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbYC2DIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbYC2DIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbYC2DIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:08:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49798 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbYC2DIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:08:09 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ioat_dca __iomem annotations
Cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org
Message-Id: <E1JfRQO-0002cZ-J4@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:08:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/dma/ioat_dca.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat_dca.c b/drivers/dma/ioat_dca.c
index 0fa8a98..9e92276 100644
--- a/drivers/dma/ioat_dca.c
+++ b/drivers/dma/ioat_dca.c
@@ -98,7 +98,7 @@ struct ioat_dca_slot {
 
 struct ioat_dca_priv {
 	void __iomem		*iobase;
-	void			*dca_base;
+	void __iomem		*dca_base;
 	int			 max_requesters;
 	int			 requester_count;
 	u8			 tag_map[IOAT_TAG_MAP_LEN];
@@ -338,7 +338,7 @@ static struct dca_ops ioat2_dca_ops = {
 	.get_tag		= ioat2_dca_get_tag,
 };
 
-static int ioat2_dca_count_dca_slots(void *iobase, u16 dca_offset)
+static int ioat2_dca_count_dca_slots(void __iomem *iobase, u16 dca_offset)
 {
 	int slots = 0;
 	u32 req;
-- 
1.5.3.GIT


