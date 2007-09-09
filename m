Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbXIIU20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbXIIU20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759076AbXIIUZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:25:23 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60735 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759502AbXIIUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:25:21 -0400
Date: Sun, 9 Sep 2007 22:25:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] unexport sys_{open,read}
Message-ID: <20070909202527.GT3563@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sys_{open,read} can finally be unexported.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 27 Aug 2007

 fs/open.c       |    1 -
 fs/read_write.c |    1 -
 2 files changed, 2 deletions(-)

6f6884f9ee675f2e804c6c58ca46337f9765dd0d 
diff --git a/fs/open.c b/fs/open.c
index 23f334d..c0814de 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1057,7 +1057,6 @@ asmlinkage long sys_open(const char __user *filename, int flags, int mode)
 	prevent_tail_call(ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sys_open);
 
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
 			   int mode)
diff --git a/fs/read_write.c b/fs/read_write.c
index 507ddff..d913d1e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -370,7 +370,6 @@ asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sys_read);
 
 asmlinkage ssize_t sys_write(unsigned int fd, const char __user * buf, size_t count)
 {

