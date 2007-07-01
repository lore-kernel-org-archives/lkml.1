Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbXGAU2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbXGAU2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbXGAUXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:23:19 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46894 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759480AbXGAUXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:23:15 -0400
Date: Sun, 1 Jul 2007 22:23:41 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/slub.c: make code static
Message-ID: <20070701202341.GW10869@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes some needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.22-rc6-mm1/mm/slub.c.old	2007-07-01 00:34:07.000000000 +0200
+++ linux-2.6.22-rc6-mm1/mm/slub.c	2007-07-01 00:35:26.000000000 +0200
@@ -240,7 +240,7 @@
 
 /* A list of all slab caches on the system */
 static DECLARE_RWSEM(slub_lock);
-LIST_HEAD(slab_caches);
+static LIST_HEAD(slab_caches);
 
 /*
  * Tracking user of a slab.
@@ -3658,7 +3658,7 @@
 	.filter = uevent_filter,
 };
 
-decl_subsys(slab, &slab_ktype, &slab_uevent_ops);
+static decl_subsys(slab, &slab_ktype, &slab_uevent_ops);
 
 #define ID_STR_LENGTH 64
 
@@ -3756,7 +3756,7 @@
 	struct saved_alias *next;
 };
 
-struct saved_alias *alias_list;
+static struct saved_alias *alias_list;
 
 static int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 {

