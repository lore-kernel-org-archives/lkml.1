Return-Path: <linux-kernel-owner+w=401wt.eu-S934455AbXG2PUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934455AbXG2PUk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765472AbXG2PDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:03:41 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47946 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765418AbXG2PDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:03:16 -0400
Date: Sun, 29 Jul 2007 17:02:53 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] ipc/shm.c: make 2 functions static
Message-ID: <20070729150253.GC16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 6 Jul 2007

 ipc/shm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc6-mm1/ipc/shm.c.old	2007-07-05 16:08:24.000000000 +0200
+++ linux-2.6.22-rc6-mm1/ipc/shm.c	2007-07-05 16:08:44.000000000 +0200
@@ -234,7 +234,7 @@
 }
 
 #ifdef CONFIG_NUMA
-int shm_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
+static int shm_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
 {
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
@@ -244,7 +244,8 @@
 	return err;
 }
 
-struct mempolicy *shm_get_policy(struct vm_area_struct *vma, unsigned long addr)
+static struct mempolicy *shm_get_policy(struct vm_area_struct *vma,
+					unsigned long addr)
 {
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);

