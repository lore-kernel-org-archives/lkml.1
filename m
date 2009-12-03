Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZLCQip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZLCQip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 11:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZLCQio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 11:38:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZLCQio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 11:38:44 -0500
From: Michal Marek <mmarek@suse.cz>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org
Subject: [PATCH] m32r: really fix arch/m32r/boot/compressed/Makefile
Date: Thu,  3 Dec 2009 16:38:17 +0000
Message-Id: <1259858297-7516-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a556bec changed the variable from suffix_y to suffix-y only in
one place, change the rest to make it work again.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/m32r/boot/compressed/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m32r/boot/compressed/Makefile b/arch/m32r/boot/compressed/Makefile
index 177716b..01729c2 100644
--- a/arch/m32r/boot/compressed/Makefile
+++ b/arch/m32r/boot/compressed/Makefile
@@ -43,9 +43,9 @@ endif
 
 OBJCOPYFLAGS += -R .empty_zero_page
 
-suffix_$(CONFIG_KERNEL_GZIP)	= gz
-suffix_$(CONFIG_KERNEL_BZIP2)	= bz2
-suffix_$(CONFIG_KERNEL_LZMA)	= lzma
+suffix-$(CONFIG_KERNEL_GZIP)	= gz
+suffix-$(CONFIG_KERNEL_BZIP2)	= bz2
+suffix-$(CONFIG_KERNEL_LZMA)	= lzma
 
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix-y) FORCE
 	$(call if_changed,ld)
-- 
1.6.5.3

