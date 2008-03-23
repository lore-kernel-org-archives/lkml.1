Return-Path: <linux-kernel-owner+w=401wt.eu-S1764073AbYCWIcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764073AbYCWIcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbYCWIJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:55 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2289 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759569AbYCWIJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:54 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 111/148] include/asm-x86/sigcontext32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:26 -0700
Message-Id: <1206259443-13210-112-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/sigcontext32.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/sigcontext32.h b/include/asm-x86/sigcontext32.h
index 6ffab4f..57a9686 100644
--- a/include/asm-x86/sigcontext32.h
+++ b/include/asm-x86/sigcontext32.h
@@ -26,7 +26,7 @@ struct _fpstate_ia32 {
 	__u32 	cw;
 	__u32	sw;
 	__u32	tag;	/* not compatible to 64bit twd */
-	__u32	ipoff;			
+	__u32	ipoff;
 	__u32	cssel;
 	__u32	dataoff;
 	__u32	datasel;
@@ -39,7 +39,7 @@ struct _fpstate_ia32 {
 	__u32	mxcsr;
 	__u32	reserved;
 	struct _fpxreg	_fxsr_st[8];
-	struct _xmmreg	_xmm[8];	/* It's actually 16 */ 
+	struct _xmmreg	_xmm[8];	/* It's actually 16 */
 	__u32	padding[56];
 };
 
-- 
1.5.4.rc2

