Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbXJLWgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbXJLWgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXJLWUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:53284 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760445AbXJLWUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/75] Driver core: kerneldoc - kobject_uevent_env is not "usually KOBJ_MOVE"
Date: Fri, 12 Oct 2007 15:16:36 -0700
Message-Id: <1192227589276-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275843236-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index a8efb48..2e4eae5 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -77,7 +77,7 @@ out:
 /**
  * kobject_uevent_env - send an uevent with environmental data
  *
- * @action: action that is happening (usually KOBJ_MOVE)
+ * @action: action that is happening
  * @kobj: struct kobject that the action is happening to
  * @envp_ext: pointer to environmental data
  *
@@ -102,9 +102,9 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 
 	/* search the kset we belong to */
 	top_kobj = kobj;
-	while (!top_kobj->kset && top_kobj->parent) {
+	while (!top_kobj->kset && top_kobj->parent)
 		top_kobj = top_kobj->parent;
-	}
+
 	if (!top_kobj->kset) {
 		pr_debug("kobject attempted to send uevent without kset!\n");
 		return -EINVAL;
@@ -237,7 +237,7 @@ EXPORT_SYMBOL_GPL(kobject_uevent_env);
 /**
  * kobject_uevent - notify userspace by ending an uevent
  *
- * @action: action that is happening (usually KOBJ_ADD and KOBJ_REMOVE)
+ * @action: action that is happening
  * @kobj: struct kobject that the action is happening to
  *
  * Returns 0 if kobject_uevent() is completed with success or the
-- 
1.5.3.4

