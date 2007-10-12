Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXJLW6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXJLW6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760758AbXJLWXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:23:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:50030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760680AbXJLWW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:22:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 68/75] Driver core: rename ktype_class
Date: Fri, 12 Oct 2007 15:17:12 -0700
Message-Id: <119222776277-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922277571933-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
 <11922276763650-git-send-email-gregkh@suse.de>
 <1192227681926-git-send-email-gregkh@suse.de>
 <11922276862914-git-send-email-gregkh@suse.de>
 <11922276913288-git-send-email-gregkh@suse.de>
 <1192227695547-git-send-email-gregkh@suse.de>
 <11922276993289-git-send-email-gregkh@suse.de>
 <11922277041450-git-send-email-gregkh@suse.de>
 <11922277091389-git-send-email-gregkh@suse.de>
 <11922277133374-git-send-email-gregkh@suse.de>
 <11922277181565-git-send-email-gregkh@suse.de>
 <11922277222714-git-send-email-gregkh@suse.de>
 <11922277261501-git-send-email-gregkh@suse.de>
 <1192227731677-git-send-email-gregkh@suse.de>
 <11922277364080-git-send-email-gregkh@suse.de>
 <11922277403355-git-send-email-gregkh@suse.de>
 <11922277441791-git-send-email-gregkh@suse.de>
 <11922277493627-git-send-email-gregkh@suse.de>
 <11922277571933-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it a bit more sane when trying to figure out how to clean up
the ktype mess.

Based on a larger patch from Kay Sievers

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 5b9cf06..a863bb0 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -65,13 +65,13 @@ static struct sysfs_ops class_sysfs_ops = {
 	.store	= class_attr_store,
 };
 
-static struct kobj_type ktype_class = {
+static struct kobj_type class_ktype = {
 	.sysfs_ops	= &class_sysfs_ops,
 	.release	= class_release,
 };
 
 /* Hotplug events for classes go to the class_obj subsys */
-static decl_subsys(class, &ktype_class, NULL);
+static decl_subsys(class, &class_ktype, NULL);
 
 
 int class_create_file(struct class * cls, const struct class_attribute * attr)
@@ -323,7 +323,7 @@ static void class_dev_release(struct kobject * kobj)
 	}
 }
 
-static struct kobj_type ktype_class_device = {
+static struct kobj_type class_device_ktype = {
 	.sysfs_ops	= &class_dev_sysfs_ops,
 	.release	= class_dev_release,
 };
@@ -332,7 +332,7 @@ static int class_uevent_filter(struct kset *kset, struct kobject *kobj)
 {
 	struct kobj_type *ktype = get_ktype(kobj);
 
-	if (ktype == &ktype_class_device) {
+	if (ktype == &class_device_ktype) {
 		struct class_device *class_dev = to_class_dev(kobj);
 		if (class_dev->class)
 			return 1;
@@ -452,7 +452,7 @@ static struct kset_uevent_ops class_uevent_ops = {
 	.uevent =	class_uevent,
 };
 
-static decl_subsys(class_obj, &ktype_class_device, &class_uevent_ops);
+static decl_subsys(class_obj, &class_device_ktype, &class_uevent_ops);
 
 
 static int class_device_add_attrs(struct class_device * cd)
-- 
1.5.3.4

