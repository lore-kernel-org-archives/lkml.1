Return-Path: <linux-kernel-owner+w=401wt.eu-S932797AbZDHLmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbZDHLmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932233AbZDHL2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:28:06 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37856 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932202AbZDHL1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:53 -0400
X-Sasl-enc: 5RjOnmSbqi0AnEJp197kBFlP1YQqTrlH5IGL7kTczhyZ 1239190072
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 49/56] sparc: Remove void casts
Date: Wed,  8 Apr 2009 12:22:21 +0100
Message-Id: <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 arch/sparc/kernel/iommu.c     |    2 +-
 arch/sparc/kernel/signal32.c  |    6 ++----
 arch/sparc/kernel/signal_32.c |    6 ++----
 arch/sparc/kernel/signal_64.c |    3 +--
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index d8900e1..792c0e8 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -220,7 +220,7 @@ int iommu_table_init(struct iommu *iommu, int tsbsize,
 		printk(KERN_ERR "IOMMU: Error, gfp(tsb) failed.\n");
 		goto out_free_dummy_page;
 	}
-	iommu->page_table = (iopte_t *)page_address(page);
+	iommu->page_table = page_address(page);
 
 	for (i = 0; i < num_tsb_entries; i++)
 		iopte_make_dummy(iommu, &iommu->page_table[i]);
diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index ba5b09a..432a0ad 100644
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -468,8 +468,7 @@ static void setup_frame32(struct k_sigaction *ka, struct pt_regs *regs,
 	if (!(current_thread_info()->fpsaved[0] & FPRS_FEF))
 		sigframe_size -= sizeof(__siginfo_fpu_t);
 
-	sf = (struct signal_frame32 __user *)
-		get_sigframe(&ka->sa, regs, sigframe_size);
+	sf = get_sigframe(&ka->sa, regs, sigframe_size);
 	
 	if (invalid_frame_pointer(sf, sigframe_size))
 		goto sigill;
@@ -603,8 +602,7 @@ static void setup_rt_frame32(struct k_sigaction *ka, struct pt_regs *regs,
 	if (!(current_thread_info()->fpsaved[0] & FPRS_FEF))
 		sigframe_size -= sizeof(__siginfo_fpu_t);
 
-	sf = (struct rt_signal_frame32 __user *)
-		get_sigframe(&ka->sa, regs, sigframe_size);
+	sf = get_sigframe(&ka->sa, regs, sigframe_size);
 	
 	if (invalid_frame_pointer(sf, sigframe_size))
 		goto sigill;
diff --git a/arch/sparc/kernel/signal_32.c b/arch/sparc/kernel/signal_32.c
index 181d069..45ef48e 100644
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -326,8 +326,7 @@ static void setup_frame(struct k_sigaction *ka, struct pt_regs *regs,
 	if (!used_math())
 		sigframe_size -= sizeof(__siginfo_fpu_t);
 
-	sf = (struct signal_frame __user *)
-		get_sigframe(&ka->sa, regs, sigframe_size);
+	sf = get_sigframe(&ka->sa, regs, sigframe_size);
 
 	if (invalid_frame_pointer(sf, sigframe_size))
 		goto sigill_and_return;
@@ -402,8 +401,7 @@ static void setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
 	sigframe_size = RT_ALIGNEDSZ;
 	if (!used_math())
 		sigframe_size -= sizeof(__siginfo_fpu_t);
-	sf = (struct rt_signal_frame __user *)
-		get_sigframe(&ka->sa, regs, sigframe_size);
+	sf = get_sigframe(&ka->sa, regs, sigframe_size);
 	if (invalid_frame_pointer(sf, sigframe_size))
 		goto sigill;
 	if (current_thread_info()->w_saved != 0)
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index ec82d76..638bfe6 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -422,8 +422,7 @@ setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
 	if (!(current_thread_info()->fpsaved[0] & FPRS_FEF))
 		sigframe_size -= sizeof(__siginfo_fpu_t);
 
-	sf = (struct rt_signal_frame __user *)
-		get_sigframe(ka, regs, sigframe_size);
+	sf = get_sigframe(ka, regs, sigframe_size);
 	
 	if (invalid_frame_pointer (sf, sigframe_size))
 		goto sigill;
-- 
1.5.4.3

