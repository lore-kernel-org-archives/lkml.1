Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbXKGJWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbXKGJWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbXKGJWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:22:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:9705 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXKGJWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:22:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=L4PkHZlaNP1VnJ37gecGoSzGhYF9oopPMHh7Je978shVq+5QmhpLEFRDi1IvoceuHTGZ4r6D9Y/4VkTbqD/cwhQ2BTDXgxbxRQYQpBgAyKGwNrxNmtm6PE5hC8/NzjTrxHABidc3/rAe2P4bv2rSMyg/kXUYlNJP3oOfGUfv9Xg=
Message-ID: <473183BE.3020101@gmail.com>
Date: Wed, 07 Nov 2007 10:22:06 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: Removing duplicit #includes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Removing duplicit #includes for kernel/
Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
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
