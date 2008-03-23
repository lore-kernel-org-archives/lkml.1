Return-Path: <linux-kernel-owner+w=401wt.eu-S1762729AbYCWIWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762729AbYCWIWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758425AbYCWIJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:04 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2267 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759329AbYCWIJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:00 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 063/148] include/asm-x86/linkage.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:38 -0700
Message-Id: <1206259443-13210-64-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/linkage.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/linkage.h b/include/asm-x86/linkage.h
index 4e1c2ca..3c7b440 100644
--- a/include/asm-x86/linkage.h
+++ b/include/asm-x86/linkage.h
@@ -11,7 +11,7 @@
 
 #ifdef CONFIG_X86_32
 #define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
-#define prevent_tail_call(ret) __asm__ ("" : "=r" (ret) : "0" (ret))
+#define prevent_tail_call(ret) asm("" : "=r" (ret) : "0" (ret))
 /*
  * For 32-bit UML - mark functions implemented in assembly that use
  * regparm input parameters:
-- 
1.5.4.rc2

