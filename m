Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbYJ2W6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbYJ2W6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbYJ2Wq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:46:29 -0400
Received: from kroah.org ([198.145.64.141]:56284 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756483AbYJ2WqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:46:15 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: "vijaykumar@bravegnu.org" <vijaykumar@bravegnu.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 41/49] Staging: poch: Fix build warnings
Date: Wed, 29 Oct 2008 15:40:08 -0700
Message-Id: <1225320016-21803-41-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vijaykumar@bravegnu.org <vijaykumar@bravegnu.org>

Removed out printing of DMA address, that causes warnings during
build.

Signed-off-by: Vijay Kumar <vijaykumar@bravegnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/poch/poch.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index afc9863..b54760f 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -390,8 +390,8 @@ static int poch_channel_alloc_groups(struct channel_info *channel)
 		group->user_offset =
 			(header_pages + (i * group_pages)) * PAGE_SIZE;
 
-		printk(KERN_INFO PFX "%ld: user_offset: 0x%lx dma: 0x%x\n", i,
-		       group->user_offset, group->dma_addr);
+		printk(KERN_INFO PFX "%ld: user_offset: 0x%lx\n", i,
+		       group->user_offset);
 	}
 
 	return 0;
-- 
1.6.0.2

