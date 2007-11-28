Return-Path: <linux-kernel-owner+w=401wt.eu-S1762254AbXK1Wyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254AbXK1Wyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762022AbXK1Wxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:53:36 -0500
Received: from mail.suse.de ([195.135.220.2]:57423 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762011AbXK1Wxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:53:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/6] kobject: two typo fixes
Date: Wed, 28 Nov 2007 14:52:19 -0800
Message-Id: <1196290340-28828-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071128224746.GA28410@kroah.com>
References: <20071128224746.GA28410@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

This fixes two typos from commit
34358c26a2c96b2a068dc44e0ac602106a466bce.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index a7e3bf4..b52e9f4 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -313,8 +313,8 @@ int kobject_rename(struct kobject * kobj, const char *new_name)
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
-- 
1.5.3.4

