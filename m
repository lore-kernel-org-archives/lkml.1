Return-Path: <linux-kernel-owner+w=401wt.eu-S1763533AbXGEXZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763533AbXGEXZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762940AbXGEXXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:23:00 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52146 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763110AbXGEXW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:22:59 -0400
Date: Fri, 6 Jul 2007 01:23:28 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] ipc/shm.c: make 2 functions static
Message-ID: <20070705232328.GD3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

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

