Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbXKEOuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbXKEOuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 09:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXKEOtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 09:49:55 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:35003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbXKEOtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 09:49:55 -0500
Subject: [PATCH] kobject: two typo fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: trivial@kernel.org
Cc: Greg KH <gregkh@suse.de>, Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 13:59:11 +0100
Message-Id: <1194267551.13501.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes two typos from commit
34358c26a2c96b2a068dc44e0ac602106a466bce.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 lib/kobject.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.orig/lib/kobject.c	2007-11-05 13:51:34.004672254 +0100
+++ linux-2.6/lib/kobject.c	2007-11-05 13:51:52.304652018 +0100
@@ -313,8 +313,8 @@ int kobject_rename(struct kobject * kobj
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


