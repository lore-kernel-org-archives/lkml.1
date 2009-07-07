Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbZGGOi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbZGGOi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758669AbZGGOgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:36:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:42766 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758663AbZGGOgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:36:19 -0400
Subject: [PATCH 17/22] trivial: fix typo "this this" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:53:24 +0530
Message-Id: <1246976604.3613.34.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "this this" with "this" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/powerpc/kernel/process.c       |    4 ++--
 drivers/net/tulip/xircom_cb.c       |    4 ++--
 drivers/net/wireless/orinoco/main.h |    2 +-
 fs/ext3/inode.c                     |    2 +-
 fs/ext4/inode.c                     |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 892a9f2..fa71472 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -352,7 +352,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 
 #else  /* CONFIG_SMP */
 #ifdef CONFIG_ALTIVEC
-	/* Avoid the trap.  On smp this this never happens since
+	/* Avoid the trap.  On smp this never happens since
 	 * we don't set last_task_used_altivec -- Cort
 	 */
 	if (new->thread.regs && last_task_used_altivec == new)
@@ -363,7 +363,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 		new->thread.regs->msr |= MSR_VSX;
 #endif /* CONFIG_VSX */
 #ifdef CONFIG_SPE
-	/* Avoid the trap.  On smp this this never happens since
+	/* Avoid the trap.  On smp this never happens since
 	 * we don't set last_task_used_spe
 	 */
 	if (new->thread.regs && last_task_used_spe == new)
diff --git a/drivers/net/tulip/xircom_cb.c b/drivers/net/tulip/xircom_cb.c
index c2ca9f4..47060c5 100644
--- a/drivers/net/tulip/xircom_cb.c
+++ b/drivers/net/tulip/xircom_cb.c
@@ -793,7 +793,7 @@ static void activate_receiver(struct xircom_private *card)
 
 /*
 deactivate_receiver disables the receiver on the card.
-To achieve this this code disables the receiver first;
+To achieve this code disables the receiver first;
 then it waits for the receiver to become inactive.
 
 must be called with the lock held and interrupts disabled.
@@ -884,7 +884,7 @@ static void activate_transmitter(struct xircom_private *card)
 
 /*
 deactivate_transmitter disables the transmitter on the card.
-To achieve this this code disables the transmitter first;
+To achieve this code disables the transmitter first;
 then it waits for the transmitter to become inactive.
 
 must be called with the lock held and interrupts disabled.
diff --git a/drivers/net/wireless/orinoco/main.h b/drivers/net/wireless/orinoco/main.h
index af2bae4..7154d07 100644
--- a/drivers/net/wireless/orinoco/main.h
+++ b/drivers/net/wireless/orinoco/main.h
@@ -12,7 +12,7 @@
 /* Compile time configuration and compatibility stuff               */
 /********************************************************************/
 
-/* We do this this way to avoid ifdefs in the actual code */
+/* We do this way to avoid ifdefs in the actual code */
 #ifdef WIRELESS_SPY
 #define SPY_NUMBER(priv)	(priv->spy_data.spy_number)
 #else
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5f51fed..56093fd 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2269,7 +2269,7 @@ static void ext3_free_branches(handle_t *handle, struct inode *inode,
 			ext3_forget(handle, 1, inode, bh, bh->b_blocknr);
 
 			/*
-			 * Everything below this this pointer has been
+			 * Everything below this pointer has been
 			 * released.  Now let this top-of-subtree go.
 			 *
 			 * We want the freeing of this indirect block to be
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 60a26f3..d431c3a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3979,7 +3979,7 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 			ext4_forget(handle, 1, inode, bh, bh->b_blocknr);
 
 			/*
-			 * Everything below this this pointer has been
+			 * Everything below this pointer has been
 			 * released.  Now let this top-of-subtree go.
 			 *
 			 * We want the freeing of this indirect block to be
-- 
1.6.0.6



