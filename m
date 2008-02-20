Return-Path: <linux-kernel-owner+w=401wt.eu-S1761683AbYBTBjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761683AbYBTBjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbYBTBj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:39:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:7054 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbYBTBj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:39:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=OSqr6yASYKZuOqhfmAzVdfaL5FL8z2O84MdqnO+xAy4benvCxt+i7FZ8Fi6GRfPyX
	0TlM7v07FOv6vHeeGtkog==
Date: Tue, 19 Feb 2008 17:39:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [patch] sysfs: small header file cleanup
In-Reply-To: <20080219144053.f0506b87.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.1.00.0802191738070.20797@chino.kir.corp.google.com>
References: <20080218162216.ee1501fd.randy.dunlap@oracle.com> <alpine.DEB.1.00.0802181629180.15109@chino.kir.corp.google.com> <alpine.DEB.1.00.0802181650140.21008@chino.kir.corp.google.com> <20080219144053.f0506b87.randy.dunlap@oracle.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert sysfs_remove_bin_file() to have a return type of 'void' for
!CONFIG_SYSFS configurations.  Also removes unnecessary colons from empty
void functions.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/sysfs.h |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
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
