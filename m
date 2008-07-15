Return-Path: <linux-kernel-owner+w=401wt.eu-S1762112AbYGOQ6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112AbYGOQ6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759305AbYGOQ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:57:37 -0400
Received: from smtp.movial.fi ([62.236.91.34]:53432 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758668AbYGOQ5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:57:35 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [MIPS] add missing prototypes to asm/page.h
Date: Tue, 15 Jul 2008 19:57:32 +0300
Message-Id: <1216141052-28005-4-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1216141052-28005-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1216141052-28005-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

>>>>>>>>>>>>>>>>>>
arch/mips/mm/page.c:284:16: warning: symbol
'build_clear_page' was not declared. Should it be static?

arch/mips/mm/page.c:426:16: warning: symbol 'build_copy_page'
was not declared. Should it be static?
>>>>>>>>>>>>>>>>>>

The fix is to add appropriate prototypes to the header
include/asm-mips/page.h.

Build-tested against Malta defconfig.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 include/asm-mips/page.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/asm-mips/page.h b/include/asm-mips/page.h
index 8735aa0..494f00b 100644
--- a/include/asm-mips/page.h
+++ b/include/asm-mips/page.h
@@ -34,6 +34,9 @@
 #include <linux/pfn.h>
 #include <asm/io.h>
 
+extern void build_clear_page(void);
+extern void build_copy_page(void);
+
 /*
  * It's normally defined only for FLATMEM config but it's
  * used in our early mem init code for all memory models.
-- 
1.5.6

