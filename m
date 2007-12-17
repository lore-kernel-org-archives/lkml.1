Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbXLQUeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbXLQUeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbXLQUd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:33:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbXLQUd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:33:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Dave Young <hidave.darkstar@gmail.com>
Subject: [PATCH 1/7] kobject: fix the documentation of how kobject_set_name works
Date: Mon, 17 Dec 2007 12:33:17 -0800
Message-Id: <1197923603-6752-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <20071217185654.GC4330@kroah.com>
References: <20071217185654.GC4330@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Dave Young <hidave.darkstar@gmail.com> for pointing out that I
forgot to update the comment when I rewrote kobject_set_name.

Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index b52e9f4..3590f02 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -234,13 +234,13 @@ int kobject_register(struct kobject * kobj)
 
 
 /**
- *	kobject_set_name - Set the name of an object
- *	@kobj:	object.
- *	@fmt:	format string used to build the name
+ * kobject_set_name - Set the name of a kobject
+ * @kobj: kobject to name
+ * @fmt: format string used to build the name
  *
- *	If strlen(name) >= KOBJ_NAME_LEN, then use a dynamically allocated
- *	string that @kobj->k_name points to. Otherwise, use the static 
- *	@kobj->name array.
+ * This sets the name of the kobject.  If you have already added the
+ * kobject to the system, you must call kobject_rename() in order to
+ * change the name of the kobject.
  */
 int kobject_set_name(struct kobject * kobj, const char * fmt, ...)
 {
-- 
1.5.3.7

