Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZCCKgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZCCKgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 05:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZCCKgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 05:36:33 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:17310 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZCCKgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 05:36:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=et9ybHt5PNggkEMFT/M6oLxlASHFuaT8e5poAeVEZ4afz33tA4ObX5AmKLLfVjhJ1N
         CqNQBcoeR8NAV0yOuajTJRIjSLRGdFZQ5nU0Wb+Q1XUcnsEBI/L0SRwQFcyrHodWDVqd
         HkJYWFisAQEAqqFGLOpBXCadLt63xIv9668m8=
Date: Tue, 3 Mar 2009 18:36:02 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH]some cleanup on drivers/base/sys.c
Message-ID: <20090303103602.GA9658@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


do some cleanup on drivers/base/sys.c

>From ca17f201964ccd9f305808617560fd1945bf4046 Mon Sep 17 00:00:00 2001
From: Zhenwen Xu <helight.xu@gmail.com>
Date: Tue, 3 Mar 2009 18:23:29 +0800
Subject: [PATCH] some cleanup on drivers/base/sys.c


Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 drivers/base/sys.c |   54 ++++++++++++++++++++++++++--------------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index b428c8c..cbd36cf 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -30,10 +30,10 @@
 
 
 static ssize_t
-sysdev_show(struct kobject * kobj, struct attribute * attr, char * buffer)
+sysdev_show(struct kobject *kobj, struct attribute *attr, char *buffer)
 {
-	struct sys_device * sysdev = to_sysdev(kobj);
-	struct sysdev_attribute * sysdev_attr = to_sysdev_attr(attr);
+	struct sys_device *sysdev = to_sysdev(kobj);
+	struct sysdev_attribute *sysdev_attr = to_sysdev_attr(attr);
 
 	if (sysdev_attr->show)
 		return sysdev_attr->show(sysdev, sysdev_attr, buffer);
@@ -42,11 +42,11 @@ sysdev_show(struct kobject * kobj, struct attribute * attr, char * buffer)
 
 
 static ssize_t
-sysdev_store(struct kobject * kobj, struct attribute * attr,
-	     const char * buffer, size_t count)
+sysdev_store(struct kobject *kobj, struct attribute *attr,
+	     const char *buffer, size_t count)
 {
-	struct sys_device * sysdev = to_sysdev(kobj);
-	struct sysdev_attribute * sysdev_attr = to_sysdev_attr(attr);
+	struct sys_device *sysdev = to_sysdev(kobj);
+	struct sysdev_attribute *sysdev_attr = to_sysdev_attr(attr);
 
 	if (sysdev_attr->store)
 		return sysdev_attr->store(sysdev, sysdev_attr, buffer, count);
@@ -63,13 +63,13 @@ static struct kobj_type ktype_sysdev = {
 };
 
 
-int sysdev_create_file(struct sys_device * s, struct sysdev_attribute * a)
+int sysdev_create_file(struct sys_device *s, struct sysdev_attribute *a)
 {
 	return sysfs_create_file(&s->kobj, &a->attr);
 }
 
 
-void sysdev_remove_file(struct sys_device * s, struct sysdev_attribute * a)
+void sysdev_remove_file(struct sys_device *s, struct sysdev_attribute *a)
 {
 	sysfs_remove_file(&s->kobj, &a->attr);
 }
@@ -84,7 +84,7 @@ EXPORT_SYMBOL_GPL(sysdev_remove_file);
 static ssize_t sysdev_class_show(struct kobject *kobj, struct attribute *attr,
 				 char *buffer)
 {
-	struct sysdev_class * class = to_sysdev_class(kobj);
+	struct sysdev_class *class = to_sysdev_class(kobj);
 	struct sysdev_class_attribute *class_attr = to_sysdev_class_attr(attr);
 
 	if (class_attr->show)
@@ -95,8 +95,8 @@ static ssize_t sysdev_class_show(struct kobject *kobj, struct attribute *attr,
 static ssize_t sysdev_class_store(struct kobject *kobj, struct attribute *attr,
 				  const char *buffer, size_t count)
 {
-	struct sysdev_class * class = to_sysdev_class(kobj);
-	struct sysdev_class_attribute * class_attr = to_sysdev_class_attr(attr);
+	struct sysdev_class *class = to_sysdev_class(kobj);
+	struct sysdev_class_attribute *class_attr = to_sysdev_class_attr(attr);
 
 	if (class_attr->store)
 		return class_attr->store(class, buffer, count);
@@ -128,7 +128,7 @@ EXPORT_SYMBOL_GPL(sysdev_class_remove_file);
 
 static struct kset *system_kset;
 
-int sysdev_class_register(struct sysdev_class * cls)
+int sysdev_class_register(struct sysdev_class *cls)
 {
 	pr_debug("Registering sysdev class '%s'\n", cls->name);
 
@@ -141,7 +141,7 @@ int sysdev_class_register(struct sysdev_class * cls)
 	return kset_register(&cls->kset);
 }
 
-void sysdev_class_unregister(struct sysdev_class * cls)
+void sysdev_class_unregister(struct sysdev_class *cls)
 {
 	pr_debug("Unregistering sysdev class '%s'\n",
 		 kobject_name(&cls->kset.kobj));
@@ -203,8 +203,8 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
  *	@cls:	Class driver belongs to.
  *	@drv:	Driver.
  */
-void sysdev_driver_unregister(struct sysdev_class * cls,
-			      struct sysdev_driver * drv)
+void sysdev_driver_unregister(struct sysdev_class *cls,
+			      struct sysdev_driver *drv)
 {
 	mutex_lock(&sysdev_drivers_lock);
 	list_del_init(&drv->entry);
@@ -229,10 +229,10 @@ EXPORT_SYMBOL_GPL(sysdev_driver_unregister);
  *	@sysdev:	device in question
  *
  */
-int sysdev_register(struct sys_device * sysdev)
+int sysdev_register(struct sys_device *sysdev)
 {
 	int error;
-	struct sysdev_class * cls = sysdev->cls;
+	struct sysdev_class *cls = sysdev->cls;
 
 	if (!cls)
 		return -EINVAL;
@@ -252,7 +252,7 @@ int sysdev_register(struct sys_device * sysdev)
 				     sysdev->id);
 
 	if (!error) {
-		struct sysdev_driver * drv;
+		struct sysdev_driver *drv;
 
 		pr_debug("Registering sys device '%s'\n",
 			 kobject_name(&sysdev->kobj));
@@ -274,9 +274,9 @@ int sysdev_register(struct sys_device * sysdev)
 	return error;
 }
 
-void sysdev_unregister(struct sys_device * sysdev)
+void sysdev_unregister(struct sys_device *sysdev)
 {
-	struct sysdev_driver * drv;
+	struct sysdev_driver *drv;
 
 	mutex_lock(&sysdev_drivers_lock);
 	list_for_each_entry(drv, &sysdev->cls->drivers, entry) {
@@ -305,19 +305,19 @@ void sysdev_unregister(struct sys_device * sysdev)
  */
 void sysdev_shutdown(void)
 {
-	struct sysdev_class * cls;
+	struct sysdev_class *cls;
 
 	pr_debug("Shutting Down System Devices\n");
 
 	mutex_lock(&sysdev_drivers_lock);
 	list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
-		struct sys_device * sysdev;
+		struct sys_device *sysdev;
 
 		pr_debug("Shutting down type '%s':\n",
 			 kobject_name(&cls->kset.kobj));
 
 		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
-			struct sysdev_driver * drv;
+			struct sysdev_driver *drv;
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
 			/* Call auxillary drivers first */
@@ -364,7 +364,7 @@ static void __sysdev_resume(struct sys_device *dev)
  */
 int sysdev_suspend(pm_message_t state)
 {
-	struct sysdev_class * cls;
+	struct sysdev_class *cls;
 	struct sys_device *sysdev, *err_dev;
 	struct sysdev_driver *drv, *err_drv;
 	int ret;
@@ -442,12 +442,12 @@ EXPORT_SYMBOL_GPL(sysdev_suspend);
  */
 int sysdev_resume(void)
 {
-	struct sysdev_class * cls;
+	struct sysdev_class *cls;
 
 	pr_debug("Resuming System Devices\n");
 
 	list_for_each_entry(cls, &system_kset->list, kset.kobj.entry) {
-		struct sys_device * sysdev;
+		struct sys_device *sysdev;
 
 		pr_debug("Resuming type '%s':\n",
 			 kobject_name(&cls->kset.kobj));
-- 
1.5.6.5

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn
