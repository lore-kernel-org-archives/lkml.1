Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYANNtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYANNtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYANNs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:48:57 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:60309 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbYANNs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:48:56 -0500
Date: Mon, 14 Jan 2008 15:46:48 +0200 (IST)
From: Ohad Ben-Cohen <ohad@bencohen.org>
Subject: [PATCH] fs/binfmt_elf.c: spello fix
To: trivial@kernel.org
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.291d813247122b95@bencohen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/litle/little

Signed-off-by: Ohad Ben-Cohen <ohad@bencohen.org>
---
 fs/binfmt_elf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f0b3171..5465c63 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -116,7 +116,7 @@ static int padzero(unsigned long elf_bss)
 	return 0;
 }
 
-/* Let's use some macros to make this stack manipulation a litle clearer */
+/* Let's use some macros to make this stack manipulation a little clearer */
 #ifdef CONFIG_STACK_GROWSUP
 #define STACK_ADD(sp, items) ((elf_addr_t __user *)(sp) + (items))
 #define STACK_ROUND(sp, items) \
-- 
1.4.4.2


