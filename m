Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZFEIOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZFEIOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZFEIGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:23 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37508 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbZFEIFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 26/62] Blackfin: delete unused sys_getpagesize() function
Date: Fri,  5 Jun 2009 04:04:35 -0400
Message-Id: <1244189111-19639-27-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/sys_bfin.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/kernel/sys_bfin.c b/arch/blackfin/kernel/sys_bfin.c
index fce49d7..a8f1329 100644
--- a/arch/blackfin/kernel/sys_bfin.c
+++ b/arch/blackfin/kernel/sys_bfin.c
@@ -78,11 +78,6 @@ asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 	return do_mmap2(addr, len, prot, flags, fd, pgoff);
 }
 
-asmlinkage int sys_getpagesize(void)
-{
-	return PAGE_SIZE;
-}
-
 asmlinkage void *sys_sram_alloc(size_t size, unsigned long flags)
 {
 	return sram_alloc_with_lsl(size, flags);
-- 
1.6.3.1

