Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbXKCAA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbXKCAA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbXKCAAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:34774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbXKCAAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 03/54] KOBJECT: remove kobj_set_kset_s as no one is using it anymore
Date: Fri,  2 Nov 2007 16:58:41 -0700
Message-Id: <1194047972-9850-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What a confusing name for a macro...

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 4dcf478..4e8a542 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -195,24 +195,6 @@ extern struct kset kernel_subsys;
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
1.5.3.4

