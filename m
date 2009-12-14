Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZLNABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZLNABU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbZLNABQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:01:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34686 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbZLMX6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:41 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, maciej.sosnowski@intel.com,
       shemminger@vyatta.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [PATCH 01/25] Constify struct sysfs_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:08 +0100
Message-Id: <89da2e678033f5cecbff89d477f846c0d2fe48c6.1260663004.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663004.git.re.emese@gmail.com>
References: <cover.1260663004.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
---
 drivers/dma/ioat/dma.c |    2 +-
 drivers/dma/ioat/dma.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index c524d36..fc2d0b6 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -1146,7 +1146,7 @@ ioat_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 	return entry->show(&chan->common, page);
 }
 
-struct sysfs_ops ioat_sysfs_ops = {
+const struct sysfs_ops ioat_sysfs_ops = {
 	.show	= ioat_attr_show,
 };
 
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 45edde9..c72e7fe 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -329,7 +329,7 @@ bool ioat_cleanup_preamble(struct ioat_chan_common *chan,
 			   unsigned long *phys_complete);
 void ioat_kobject_add(struct ioatdma_device *device, struct kobj_type *type);
 void ioat_kobject_del(struct ioatdma_device *device);
-extern struct sysfs_ops ioat_sysfs_ops;
+extern const struct sysfs_ops ioat_sysfs_ops;
 extern struct ioat_sysfs_entry ioat_version_attr;
 extern struct ioat_sysfs_entry ioat_cap_attr;
 #endif /* IOATDMA_H */
-- 
1.6.5.3

