Return-Path: <linux-kernel-owner+w=401wt.eu-S1763908AbYEESjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763908AbYEESjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbYEES3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:29:50 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44946 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761489AbYEES3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:29:48 -0400
Date: Mon, 5 May 2008 21:28:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] init/do_mounts.c should #include <linux/initrd.h>
Message-ID: <20080505182841.GQ17139@cs181133002.pp.htv.fi>
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
- 22 Apr 2008
- 14 Apr 2008
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


