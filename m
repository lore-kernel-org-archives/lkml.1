Return-Path: <linux-kernel-owner+w=401wt.eu-S935188AbYBBX6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188AbYBBX6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbYBBX5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:57:49 -0500
Received: from ns.suse.de ([195.135.220.2]:37315 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109AbYBBX5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:57:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/10] kobject: kerneldoc comment fix
Date: Sat,  2 Feb 2008 15:55:56 -0800
Message-Id: <1201996564-21951-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080202234357.GA21721@suse.de>
References: <20080202234357.GA21721@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

Fix kerneldoc comment of kobject_create.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 1d63ead..d784dae 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -637,7 +637,7 @@ struct kobject *kobject_create(void)
  * @name: the name for the kset
  * @parent: the parent kobject of this kobject, if any.
  *
- * This function creates a kset structure dynamically and registers it
+ * This function creates a kobject structure dynamically and registers it
  * with sysfs.  When you are finished with this structure, call
  * kobject_put() and the structure will be dynamically freed when
  * it is no longer being used.
-- 
1.5.3.8

