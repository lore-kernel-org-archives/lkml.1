Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbYDUWww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbYDUWww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757625AbYDUWvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:51:12 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:35350 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818AbYDUWvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:51:11 -0400
Date: Tue, 22 Apr 2008 01:50:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make init/do_mounts.c:root_device_name static
Message-ID: <20080421225039.GL2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global root_device_name static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 14 Apr 2008
- 31 Mar 2008
- 1 Mar 2008

 init/do_mounts.c |    2 +-
 init/do_mounts.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

eab4ea6c40eb148a52a4cbbb8523b203a379c20c foobar
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 3885e70..56e3b17 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -22,7 +22,7 @@
 int __initdata rd_doload;	/* 1 = load RAM disk, 0 = don't load */
 
 int root_mountflags = MS_RDONLY | MS_SILENT;
-char * __initdata root_device_name;
+static char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
 static int __initdata root_wait;
 
diff --git a/init/do_mounts.h b/init/do_mounts.h
index 735705d..9aa968d 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -11,7 +11,6 @@ void  change_floppy(char *fmt, ...);
 void  mount_block_root(char *name, int flags);
 void  mount_root(void);
 extern int root_mountflags;
-extern char *root_device_name;
 
 static inline int create_dev(char *name, dev_t dev)
 {

