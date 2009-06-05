Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbZFEIYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbZFEIYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZFEIHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:05 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37508 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbZFEIGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 53/62] Blackfin: document the lsl variants of the L1 allocator
Date: Fri,  5 Jun 2009 04:05:02 -0400
Message-Id: <1244189111-19639-54-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure the meaning of "lsl" is covered somewhere and it is clear why we
somewhat duplicate the sram alloc/free functions.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mm/sram-alloc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mm/sram-alloc.c b/arch/blackfin/mm/sram-alloc.c
index fa54a4e..0bc3c4e 100644
--- a/arch/blackfin/mm/sram-alloc.c
+++ b/arch/blackfin/mm/sram-alloc.c
@@ -743,6 +743,10 @@ found:
 }
 EXPORT_SYMBOL(sram_free_with_lsl);
 
+/* Allocate memory and keep in L1 SRAM List (lsl) so that the resources are
+ * tracked.  These are designed for userspace so that when a process exits,
+ * we can safely reap their resources.
+ */
 void *sram_alloc_with_lsl(size_t size, unsigned long flags)
 {
 	void *addr = NULL;
-- 
1.6.3.1

