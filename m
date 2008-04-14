Return-Path: <linux-kernel-owner+w=401wt.eu-S934825AbYDNSqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934825AbYDNSqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934302AbYDNSm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:42:56 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35305 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764126AbYDNSmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:42:54 -0400
Date: Mon, 14 Apr 2008 21:40:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] init/do_mounts.c should #include <linux/initrd.h>
Message-ID: <20080414184045.GE6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the externs for its 
global code (in this case for rd_doload).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
- 1 Mar 2008

e5c6b847745aa7cb3d345ff3943c1b4c61b8ae91 foobar
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 56e3b17..a1c52ba 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -12,6 +12,7 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/initrd.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>


