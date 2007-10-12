Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbXJLXE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbXJLXE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbXJLWXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:23:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:53625 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760951AbXJLWXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:23:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 72/75] kset: add some kerneldoc to help describe what these strange things are
Date: Fri, 12 Oct 2007 15:17:16 -0700
Message-Id: <11922277801964-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227776447-git-send-email-gregkh@suse.de>
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
 <119222776277-git-send-email-gregkh@suse.de>
 <11922277663827-git-send-email-gregkh@suse.de>
 <11922277711448-git-send-email-gregkh@suse.de>
 <1192227776447-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 05cc5b2..973aa7b 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -117,29 +117,30 @@ struct kset_uevent_ops {
 		      struct kobj_uevent_env *env);
 };
 
-/*
- *	struct kset - a set of kobjects of a specific type, belonging
- *	to a specific subsystem.
- *
- *	All kobjects of a kset should be embedded in an identical 
- *	type. This type may have a descriptor, which the kset points
- *	to. This allows there to exist sets of objects of the same
- *	type in different subsystems.
+/**
+ * struct kset - a set of kobjects of a specific type, belonging to a specific subsystem.
  *
- *	A subsystem does not have to be a list of only one type 
- *	of object; multiple ksets can belong to one subsystem. All 
- *	ksets of a subsystem share the subsystem's lock.
+ * A kset defines a group of kobjects.  They can be individually
+ * different "types" but overall these kobjects all want to be grouped
+ * together and operated on in the same manner.  ksets are used to
+ * define the attribute callbacks and other common events that happen to
+ * a kobject.
  *
- *	Each kset can support specific event variables; it can
- *	supress the event generation or add subsystem specific
- *	variables carried with the event.
+ * @ktype: the struct kobj_type for this specific kset
+ * @list: the list of all kobjects for this kset
+ * @list_lock: a lock for iterating over the kobjects
+ * @kobj: the embedded kobject for this kset (recursion, isn't it fun...)
+ * @uevent_ops: the set of uevent operations for this kset.  These are
+ * called whenever a kobject has something happen to it so that the kset
+ * can add new environment variables, or filter out the uevents if so
+ * desired.
  */
 struct kset {
-	struct kobj_type	* ktype;
+	struct kobj_type	*ktype;
 	struct list_head	list;
 	spinlock_t		list_lock;
 	struct kobject		kobj;
-	struct kset_uevent_ops	* uevent_ops;
+	struct kset_uevent_ops	*uevent_ops;
 };
 
 
-- 
1.5.3.4

