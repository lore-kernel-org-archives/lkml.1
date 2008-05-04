Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYEDOR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYEDOR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYEDORu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:17:50 -0400
Received: from smtp06.mtu.ru ([62.5.255.53]:56380 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063AbYEDORt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:17:49 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] remove duplicate definition of sysfs_update_group()
Date: Sun,  4 May 2008 18:17:46 +0400
Message-Id: <1209910666-7918-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stub version of the sysfs_update_group() function is erroneously
provided twice. This patch removes the redundant definition.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 include/linux/sysfs.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 27bad59..7858eac 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -196,12 +196,6 @@ static inline int sysfs_update_group(struct kobject *kobj,
 	return 0;
 }
 
-static inline int sysfs_update_group(struct kobject *kobj,
-				const struct attribute_group *grp)
-{
-	return 0;
-}
-
 static inline void sysfs_remove_group(struct kobject *kobj,
 				      const struct attribute_group *grp)
 {
-- 
1.5.3

