Return-Path: <linux-kernel-owner+w=401wt.eu-S1759094AbYD2B4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094AbYD2B4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYD2BxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:53:13 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43971 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752441AbYD2BxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:53:03 -0400
Message-Id: <20080429015301.641029381@sgi.com>
References: <20080429015231.908196699@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 18:52:37 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 6/9] x86: thread_info: PREEMPT_ACTIVE
Content-Disposition: inline; filename=merge_preempt_active
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same for both 32 and 64 bit so simply put it in to the common area.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/thread_info.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/include/asm-x86/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info.h	2008-04-28 17:48:36.029891123 -0700
+++ linux-2.6/include/asm-x86/thread_info.h	2008-04-28 17:49:29.299897238 -0700
@@ -62,9 +62,10 @@ struct thread_info {
 
 #endif
 
+#define PREEMPT_ACTIVE		0x10000000
+
 #ifdef CONFIG_X86_32
 
-#define PREEMPT_ACTIVE		0x10000000
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SIZE            (4096)
 #else
@@ -286,8 +287,6 @@ static inline struct thread_info *stack_
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
 
-#define PREEMPT_ACTIVE     0x10000000
-
 #endif /* !X86_32 */
 
 /*

-- 
