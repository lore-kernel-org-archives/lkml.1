Return-Path: <linux-kernel-owner+w=401wt.eu-S1764246AbXKNCJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764246AbXKNCJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759690AbXKNCFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:05:36 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4785 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761682AbXKNCFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:34 -0500
Subject: [PATCH] - [13/15] - remove defconfig ptr comparisons to 0 - init
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:05:35 -0800
Message-Id: <1195005935.5163.99.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 3ac5904..46dfd64 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -212,7 +212,7 @@ int __init rd_load_image(char *from)
 	}
 
 	buf = kmalloc(BLOCK_SIZE, GFP_KERNEL);
-	if (buf == 0) {
+	if (!buf) {
 		printk(KERN_ERR "RAMDISK: could not allocate buffer\n");
 		goto done;
 	}


