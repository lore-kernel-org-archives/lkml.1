Return-Path: <linux-kernel-owner+w=401wt.eu-S1760707AbYAYH3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707AbYAYH3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758343AbYAYHQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:16:49 -0500
Received: from mail.suse.de ([195.135.220.2]:52694 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757732AbYAYHQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:16:45 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 043/196] kobject: remove kobj_set_kset_s as no one is using it anymore
Date: Thu, 24 Jan 2008 23:09:41 -0800
Message-Id: <1201245134-4876-43-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What a confusing name for a macro...

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 5031565..0b97b3a 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -202,24 +202,6 @@ extern struct kset kernel_subsys;
 /* The global /sys/hypervisor/ subsystem  */
 extern struct kset hypervisor_subsys;
 
-/*
- * Helpers for setting the kset of registered objects.
- * Often, a registered object belongs to a kset embedded in a 
- * subsystem. These do no magic, just make the resulting code
- * easier to follow. 
- */
-
-/**
- *	kobj_set_kset_s(obj,subsys) - set kset for embedded kobject.
- *	@obj:		ptr to some object type.
- *	@subsys:	a subsystem object (not a ptr).
- *
- *	Can be used for any object type with an embedded ->kobj.
- */
-
-#define kobj_set_kset_s(obj,subsys) \
-	(obj)->kobj.kset = &(subsys)
-
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
 
-- 
1.5.3.8

