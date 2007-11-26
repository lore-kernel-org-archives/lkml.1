Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbXKZXZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbXKZXZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbXKZXZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:25:14 -0500
Received: from ns.suse.de ([195.135.220.2]:59574 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117AbXKZXZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:25:12 -0500
Subject: patch kobject-two-typo-fixes.patch added to gregkh-2.6 tree
To: johannes@sipsolutions.net, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Mon, 26 Nov 2007 15:24:42 -0800
In-Reply-To: <1194267551.13501.2.camel@johannes.berg>
Message-Id: <20071126232510.C4A0E1454447@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: kobject: two typo fixes

to my gregkh-2.6 tree.  Its filename is

     kobject-two-typo-fixes.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From johannes@sipsolutions.net  Mon Nov 26 15:12:16 2007
From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 05 Nov 2007 13:59:11 +0100
Subject: kobject: two typo fixes
To: trivial@kernel.org
Cc: Greg KH <gregkh@suse.de>, Linux Kernel list <linux-kernel@vger.kernel.org>
Message-ID: <1194267551.13501.2.camel@johannes.berg>


This fixes two typos from commit
34358c26a2c96b2a068dc44e0ac602106a466bce.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/kobject.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -377,8 +377,8 @@ int kobject_rename(struct kobject * kobj
 		struct kobject *temp_kobj;
 		temp_kobj = kset_find_obj(kobj->kset, new_name);
 		if (temp_kobj) {
-			printk(KERN_WARNING "kobject '%s' can not be renamed "
-			       "to '%s' as '%s' is already in existance.\n",
+			printk(KERN_WARNING "kobject '%s' cannot be renamed "
+			       "to '%s' as '%s' is already in existence.\n",
 			       kobject_name(kobj), new_name, new_name);
 			kobject_put(temp_kobj);
 			return -EINVAL;


Patches currently in gregkh-2.6 which might be from johannes@sipsolutions.net are

driver/kobject-two-typo-fixes.patch
