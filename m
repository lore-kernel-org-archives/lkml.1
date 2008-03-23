Return-Path: <linux-kernel-owner+w=401wt.eu-S1765660AbYCWIyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765660AbYCWIyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbYCWILp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:45 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2335 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760106AbYCWILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:36 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 005/148] include/asm-x86/apic.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:40 -0700
Message-Id: <1206259443-13210-6-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/apic.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index 73d1635..31b0faa 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -67,7 +67,7 @@ static inline void native_apic_write(unsigned long reg, u32 v)
 
 static inline void native_apic_write_atomic(unsigned long reg, u32 v)
 {
-	(void) xchg((u32*)(APIC_BASE + reg), v);
+	(void)xchg((u32 *)(APIC_BASE + reg), v);
 }
 
 static inline u32 native_apic_read(unsigned long reg)
-- 
1.5.4.rc2

