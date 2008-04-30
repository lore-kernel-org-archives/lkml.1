Return-Path: <linux-kernel-owner+w=401wt.eu-S934326AbYEAABM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934326AbYEAABM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933701AbYD3X60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:58:26 -0400
Received: from ns2.suse.de ([195.135.220.15]:44527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764211AbYD3X6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:58:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/11] sysfs: sysfs_update_group stub for CONFIG_SYSFS=n
Date: Wed, 30 Apr 2008 16:57:45 -0700
Message-Id: <1209599870-22919-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080430235701.GA20981@suse.de>
References: <20080430235701.GA20981@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

scsi_transport_spi uses sysfs_update_group() when CONFIG_SYSFS=n,
so provide a stub for it.

next-20080423/drivers/scsi/scsi_transport_spi.c:1467: error: implicit declaration of function 'sysfs_update_group'
make[3]: *** [drivers/scsi/scsi_transport_spi.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sysfs.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index add3c5a..7858eac 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -190,6 +190,12 @@ static inline int sysfs_create_group(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_update_group(struct kobject *kobj,
+				const struct attribute_group *grp)
+{
+	return 0;
+}
+
 static inline void sysfs_remove_group(struct kobject *kobj,
 				      const struct attribute_group *grp)
 {
-- 
1.5.5.1

