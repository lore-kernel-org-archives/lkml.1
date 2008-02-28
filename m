Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbYB1Gsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbYB1Gsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbYB1Gpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:45:53 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52738 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755011AbYB1Gpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:46 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 07/12] include: Remove unnecessary inclusions of asm/semaphore.h
Date: Thu, 28 Feb 2008 01:33:56 -0500
Message-Id: <1204180441-8540-7-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204180441-8540-6-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
 <1204180441-8540-1-git-send-email-matthew@wil.cx>
 <1204180441-8540-2-git-send-email-matthew@wil.cx>
 <1204180441-8540-3-git-send-email-matthew@wil.cx>
 <1204180441-8540-4-git-send-email-matthew@wil.cx>
 <1204180441-8540-5-git-send-email-matthew@wil.cx>
 <1204180441-8540-6-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files use any of the functionality promised by
asm/semaphore.h.  It's possible that they (or some user of them) rely
on it dragging in some unrelated header file, but I can't build all
these files, so we'll have to fix any build failures as they come up.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/asm-blackfin/dma.h    |    1 -
 include/asm-ia64/sn/nodepda.h |    1 -
 include/asm-ppc/ocp.h         |    1 -
 include/linux/cpu.h           |    1 -
 include/linux/ide.h           |    1 -
 include/linux/if_pppox.h      |    1 -
 include/linux/jbd.h           |    2 --
 include/linux/jbd2.h          |    2 --
 include/linux/kernelcapi.h    |    1 -
 include/linux/raid/md.h       |    1 -
 include/linux/sched.h         |    1 -
 include/linux/syscalls.h      |    1 -
 include/scsi/libsas.h         |    1 -
 13 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/include/asm-blackfin/dma.h b/include/asm-blackfin/dma.h
index 5abaa2c..16d4935 100644
--- a/include/asm-blackfin/dma.h
+++ b/include/asm-blackfin/dma.h
@@ -33,7 +33,6 @@
 #include <linux/slab.h>
 #include <asm/irq.h>
 #include <asm/signal.h>
-#include <asm/semaphore.h>
 
 #include <linux/kernel.h>
 #include <asm/mach/dma.h>
diff --git a/include/asm-ia64/sn/nodepda.h b/include/asm-ia64/sn/nodepda.h
index 6f6d69e..ee118b9 100644
--- a/include/asm-ia64/sn/nodepda.h
+++ b/include/asm-ia64/sn/nodepda.h
@@ -9,7 +9,6 @@
 #define _ASM_IA64_SN_NODEPDA_H
 
 
-#include <asm/semaphore.h>
 #include <asm/irq.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/intr.h>
diff --git a/include/asm-ppc/ocp.h b/include/asm-ppc/ocp.h
index 1379a4f..3909a2e 100644
--- a/include/asm-ppc/ocp.h
+++ b/include/asm-ppc/ocp.h
@@ -31,7 +31,6 @@
 
 #include <asm/mmu.h>
 #include <asm/ocp_ids.h>
-#include <asm/semaphore.h>
 
 #ifdef CONFIG_PPC_OCP
 
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 0be8d65..f212fa9 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -23,7 +23,6 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/cpumask.h>
-#include <asm/semaphore.h>
 #include <linux/mutex.h>
 
 struct cpu {
diff --git a/include/linux/ide.h b/include/linux/ide.h
index a3b69c1..68510a0 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -23,7 +23,6 @@
 #include <asm/byteorder.h>
 #include <asm/system.h>
 #include <asm/io.h>
-#include <asm/semaphore.h>
 #include <asm/mutex.h>
 
 #if defined(CRIS) || defined(FRV)
diff --git a/include/linux/if_pppox.h b/include/linux/if_pppox.h
index 40743e0..6fb7f17 100644
--- a/include/linux/if_pppox.h
+++ b/include/linux/if_pppox.h
@@ -24,7 +24,6 @@
 #include <linux/if_ether.h>
 #include <linux/if.h>
 #include <linux/netdevice.h>
-#include <asm/semaphore.h>
 #include <linux/ppp_channel.h>
 #endif /* __KERNEL__ */
 #include <linux/if_pppol2tp.h>
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index b18fd3b..ec52d0b 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -32,8 +32,6 @@
 #include <linux/timer.h>
 #include <linux/lockdep.h>
 
-#include <asm/semaphore.h>
-
 #define journal_oom_retry 1
 
 /*
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 2cbf6fd..05e2b30 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -30,8 +30,6 @@
 #include <linux/bit_spinlock.h>
 #include <linux/mutex.h>
 #include <linux/timer.h>
-
-#include <asm/semaphore.h>
 #endif
 
 #define journal_oom_retry 1
diff --git a/include/linux/kernelcapi.h b/include/linux/kernelcapi.h
index 8c4350a..a53e932 100644
--- a/include/linux/kernelcapi.h
+++ b/include/linux/kernelcapi.h
@@ -48,7 +48,6 @@ typedef struct kcapi_carddef {
 #include <linux/list.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
-#include <asm/semaphore.h>
 
 #define	KCI_CONTRUP	0	/* arg: struct capi_profile */
 #define	KCI_CONTRDOWN	1	/* arg: NULL */
diff --git a/include/linux/raid/md.h b/include/linux/raid/md.h
index fbaeda7..8ab630b 100644
--- a/include/linux/raid/md.h
+++ b/include/linux/raid/md.h
@@ -19,7 +19,6 @@
 #define _MD_H
 
 #include <linux/blkdev.h>
-#include <asm/semaphore.h>
 #include <linux/major.h>
 #include <linux/ioctl.h>
 #include <linux/types.h>
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c9621f..601d100 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -61,7 +61,6 @@ struct sched_param {
 #include <linux/mm_types.h>
 
 #include <asm/system.h>
-#include <asm/semaphore.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include <asm/cputime.h>
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4c2577b..8df6d13 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -60,7 +60,6 @@ struct getcpu_cache;
 #include <linux/capability.h>
 #include <linux/list.h>
 #include <linux/sem.h>
-#include <asm/semaphore.h>
 #include <asm/siginfo.h>
 #include <asm/signal.h>
 #include <linux/quota.h>
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3ffd6b5..896db51 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -32,7 +32,6 @@
 #include <scsi/sas.h>
 #include <linux/libata.h>
 #include <linux/list.h>
-#include <asm/semaphore.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport_sas.h>
-- 
1.5.4.1

