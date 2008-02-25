Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbYBYAKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbYBYAKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbYBYAIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:08:49 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44530 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792AbYBYAIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:08:47 -0500
Date: Mon, 25 Feb 2008 02:07:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper prototypes for vread/vwrite
Message-ID: <20080225000752.GH2088@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper prototypes for vread/vwrite in 
include/linux/vmalloc.h 

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/char/mem.c      |    3 ---
 include/linux/vmalloc.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

ce4fe62358ed9369d3ff4e67d621164b381234ab diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 20070b7..da6319f 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -350,9 +350,6 @@ static ssize_t read_oldmem(struct file *file, char __user *buf,
 }
 #endif
 
-extern long vread(char *buf, char *addr, unsigned long count);
-extern long vwrite(char *buf, char *addr, unsigned long count);
-
 /*
  * This function reads the *virtual* memory as seen by the kernel.
  */
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index ce8e7da..7bdd809 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -55,6 +55,9 @@ extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
 void vmalloc_sync_all(void);
  
+long vread(char *buf, char *addr, unsigned long count);
+long vwrite(char *buf, char *addr, unsigned long count);
+
 /*
  *	Lowlevel-APIs (not for driver use!)
  */

