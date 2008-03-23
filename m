Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbYCWIMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbYCWIMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758722AbYCWIH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:07:57 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2175 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758709AbYCWIHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:55 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 001/148] include/asm-x86/acpi.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:36 -0700
Message-Id: <1206259443-13210-2-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/acpi.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/acpi.h b/include/asm-x86/acpi.h
index 7a72d6a..14411c9 100644
--- a/include/asm-x86/acpi.h
+++ b/include/asm-x86/acpi.h
@@ -67,16 +67,16 @@ int __acpi_release_global_lock(unsigned int *lock);
  */
 #define ACPI_DIV_64_BY_32(n_hi, n_lo, d32, q32, r32) \
 	asm("divl %2;"				     \
-	    :"=a"(q32), "=d"(r32)		     \
-	    :"r"(d32),				     \
+	    : "=a"(q32), "=d"(r32)		     \
+	    : "r"(d32),				     \
 	     "0"(n_lo), "1"(n_hi))
 
 
 #define ACPI_SHIFT_RIGHT_64(n_hi, n_lo) \
 	asm("shrl   $1,%2	;"	\
 	    "rcrl   $1,%3;"		\
-	    :"=r"(n_hi), "=r"(n_lo)	\
-	    :"0"(n_hi), "1"(n_lo))
+	    : "=r"(n_hi), "=r"(n_lo)	\
+	    : "0"(n_hi), "1"(n_lo))
 
 #ifdef CONFIG_ACPI
 extern int acpi_lapic;
-- 
1.5.4.rc2

