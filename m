Return-Path: <linux-kernel-owner+w=401wt.eu-S933712AbYCWI6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbYCWI6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759574AbYCWIL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:59 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2357 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbYCWILr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:47 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 052/148] include/asm-x86/ipi.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:27 -0700
Message-Id: <1206259443-13210-53-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/ipi.h |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/ipi.h b/include/asm-x86/ipi.h
index 6d011bd..ecc80f3 100644
--- a/include/asm-x86/ipi.h
+++ b/include/asm-x86/ipi.h
@@ -27,7 +27,8 @@
  * We use 'broadcast', CPU->CPU IPIs and self-IPIs too.
  */
 
-static inline unsigned int __prepare_ICR (unsigned int shortcut, int vector, unsigned int dest)
+static inline unsigned int __prepare_ICR(unsigned int shortcut, int vector,
+					 unsigned int dest)
 {
 	unsigned int icr = shortcut | dest;
 
@@ -42,12 +43,13 @@ static inline unsigned int __prepare_ICR (unsigned int shortcut, int vector, uns
 	return icr;
 }
 
-static inline int __prepare_ICR2 (unsigned int mask)
+static inline int __prepare_ICR2(unsigned int mask)
 {
 	return SET_APIC_DEST_FIELD(mask);
 }
 
-static inline void __send_IPI_shortcut(unsigned int shortcut, int vector, unsigned int dest)
+static inline void __send_IPI_shortcut(unsigned int shortcut, int vector,
+				       unsigned int dest)
 {
 	/*
 	 * Subtle. In the case of the 'never do double writes' workaround
@@ -78,7 +80,8 @@ static inline void __send_IPI_shortcut(unsigned int shortcut, int vector, unsign
  * This is used to send an IPI with no shorthand notation (the destination is
  * specified in bits 56 to 63 of the ICR).
  */
-static inline void __send_IPI_dest_field(unsigned int mask, int vector, unsigned int dest)
+static inline void __send_IPI_dest_field(unsigned int mask, int vector,
+					 unsigned int dest)
 {
 	unsigned long cfg;
 
-- 
1.5.4.rc2

