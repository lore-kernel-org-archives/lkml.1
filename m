Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZFEIYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZFEIYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbZFEIHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37592 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbZFEIGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 56/62] Blackfin: punt duplicated search_exception_table() prototype
Date: Fri,  5 Jun 2009 04:05:05 -0400
Message-Id: <1244189111-19639-57-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common code already has a prototype for this function and we don't use
it anywhere in the Blackfin code, so punt it from the Blackfin headers.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/uaccess.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/include/asm/uaccess.h b/arch/blackfin/include/asm/uaccess.h
index 97729be..01f42b0 100644
--- a/arch/blackfin/include/asm/uaccess.h
+++ b/arch/blackfin/include/asm/uaccess.h
@@ -83,9 +83,6 @@ struct exception_table_entry {
 	unsigned long insn, fixup;
 };
 
-/* Returns 0 if exception not found and fixup otherwise.  */
-extern unsigned long search_exception_table(unsigned long);
-
 /*
  * These are the main single-value transfer routines.  They automatically
  * use the right size if we just have the right pointer type.
-- 
1.6.3.1

