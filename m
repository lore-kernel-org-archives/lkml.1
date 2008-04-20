Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYDTKnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYDTKnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYDTKkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56278 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYDTKkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/36] sysfs: small header file cleanup for SYSFS=n
Date: Sun, 20 Apr 2008 03:45:41 -0700
Message-Id: <1208688366-9252-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

Convert sysfs_remove_bin_file() to have a return type of 'void' for
!CONFIG_SYSFS configurations.  Also removes unnecessary colons from empty
void functions.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sysfs.h |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 8027104..03378e3 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -131,7 +131,6 @@ static inline int sysfs_create_dir(struct kobject *kobj)
 
 static inline void sysfs_remove_dir(struct kobject *kobj)
 {
-	;
 }
 
 static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
@@ -160,7 +159,6 @@ static inline int sysfs_chmod_file(struct kobject *kobj,
 static inline void sysfs_remove_file(struct kobject *kobj,
 				     const struct attribute *attr)
 {
-	;
 }
 
 static inline int sysfs_create_bin_file(struct kobject *kobj,
@@ -169,10 +167,9 @@ static inline int sysfs_create_bin_file(struct kobject *kobj,
 	return 0;
 }
 
-static inline int sysfs_remove_bin_file(struct kobject *kobj,
-					struct bin_attribute *attr)
+static inline void sysfs_remove_bin_file(struct kobject *kobj,
+					 struct bin_attribute *attr)
 {
-	return 0;
 }
 
 static inline int sysfs_create_link(struct kobject *kobj,
@@ -183,7 +180,6 @@ static inline int sysfs_create_link(struct kobject *kobj,
 
 static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
 {
-	;
 }
 
 static inline int sysfs_create_group(struct kobject *kobj,
@@ -195,7 +191,6 @@ static inline int sysfs_create_group(struct kobject *kobj,
 static inline void sysfs_remove_group(struct kobject *kobj,
 				      const struct attribute_group *grp)
 {
-	;
 }
 
 static inline int sysfs_add_file_to_group(struct kobject *kobj,
-- 
1.5.4.5

