Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbXKDPJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbXKDPJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 10:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbXKDPJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 10:09:42 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:3251 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbXKDPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 10:09:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FqMOZC8+3e77BZ2l5uAahUWx0EwooJvkAs2bKIO6721YLx0/TIVvRwnKb++rNnSRpPnFLVppGMIVnjfNoFHprZ2BrWbrvUAsK7e6iahO51peVxKohJeLPZl7BCwjNCp/QOhJhVQL8Lhg7nguE4NpbDXe22VNsODFPdWdG1DyKAA=
Message-ID: <e5bfff550711040709i146196e5i569753ac4bf90674@mail.gmail.com>
Date: Sun, 4 Nov 2007 16:09:41 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Remove some duplicated include under kernel directory
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marco Costalba <mcostalba@gmail.com>
---
 kernel/printk.c  |    1 -
 kernel/profile.c |    2 --
 kernel/sysctl.c  |    1 -
 3 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index a30fe33..3f06748 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -32,7 +32,6 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
-#include <linux/jiffies.h>

 #include <asm/uaccess.h>

diff --git a/kernel/profile.c b/kernel/profile.c
index 5e95330..92b71ea 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -20,7 +20,6 @@
 #include <linux/mm.h>
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
-#include <linux/profile.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
 #include <asm/sections.h>
@@ -425,7 +424,6 @@ void profile_tick(int type)
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
 #include <asm/uaccess.h>
-#include <asm/ptrace.h>

 static int prof_cpu_mask_read_proc (char *page, char **start, off_t off,
 			int count, int *eof, void *data)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3b4efbe..5aec15e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -37,7 +37,6 @@
 #include <linux/highuid.h>
 #include <linux/writeback.h>
 #include <linux/hugetlb.h>
-#include <linux/security.h>
 #include <linux/initrd.h>
 #include <linux/times.h>
 #include <linux/limits.h>
-- 
1.5.3.5.532.g5c38-dirty
