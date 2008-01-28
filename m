Return-Path: <linux-kernel-owner+w=401wt.eu-S1762767AbYA1WMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762767AbYA1WMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758957AbYA1WKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:10:15 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47967 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842AbYA1WKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:10:13 -0500
Date: Tue, 29 Jan 2008 00:10:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport sys_{open,read}
Message-ID: <20080128221040.GQ8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that they are unused we can finally unexport sys_{open,read}.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/open.c       |    1 -
 fs/read_write.c |    1 -
 2 files changed, 2 deletions(-)

eb86553917b5d7dc5c22e584145360ad0460372e 
diff --git a/fs/open.c b/fs/open.c
index 4932b4d..21acf85 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1061,7 +1061,6 @@ asmlinkage long sys_open(const char __user *filename, int flags, int mode)
 	prevent_tail_call(ret);
 	return ret;
 }
-EXPORT_UNUSED_SYMBOL_GPL(sys_open); /* To be deleted for 2.6.25 */
 
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
 			   int mode)
diff --git a/fs/read_write.c b/fs/read_write.c
index c4d3d17..af2c82f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -366,7 +366,6 @@ asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
 
 	return ret;
 }
-EXPORT_UNUSED_SYMBOL_GPL(sys_read); /* to be deleted for 2.6.25 */
 
 asmlinkage ssize_t sys_write(unsigned int fd, const char __user * buf, size_t count)
 {

