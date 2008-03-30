Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbYC3X3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbYC3X3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbYC3X3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:29:05 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54357 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429AbYC3X3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:29:04 -0400
Date: Mon, 31 Mar 2008 02:28:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper extern for mdp_major
Message-ID: <20080330232851.GZ28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper extern for mdp_major in include/linux/raid/md.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/raid/md.h |    2 ++
 init/do_mounts_md.c     |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

1eeb5848dc2a1c4ecb179fba4ac3db377c35ef40 diff --git a/include/linux/raid/md.h b/include/linux/raid/md.h
index fbaeda7..20b694f 100644
--- a/include/linux/raid/md.h
+++ b/include/linux/raid/md.h
@@ -73,6 +73,8 @@
  */
 #define MD_PATCHLEVEL_VERSION           3
 
+extern int mdp_major;
+
 extern int register_md_personality (struct mdk_personality *p);
 extern int unregister_md_personality (struct mdk_personality *p);
 extern mdk_thread_t * md_register_thread (void (*run) (mddev_t *mddev),
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 753dc54..9589e99 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -24,7 +24,6 @@ static struct {
 
 static int md_setup_ents __initdata;
 
-extern int mdp_major;
 /*
  * Parse the command-line parameters given our kernel, but do not
  * actually try to invoke the MD device now; that is handled by

