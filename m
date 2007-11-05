Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbXKERUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbXKERUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757972AbXKERI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:59 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59569 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757360AbXKERI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:57 -0500
Date: Mon, 5 Nov 2007 18:08:34 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: unexport __{read,write}_lock_failed
Message-ID: <20071105170834.GG12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused exports for __{read,write}_lock_failed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/i386_ksyms_32.c  |    7 -------
 arch/x86/kernel/x8664_ksyms_64.c |    7 -------
 2 files changed, 14 deletions(-)

c506e37e0e6cd6299ec355d4dd8d7d9bb2db3a51 
diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
index edd39cc..9c4f9bb 100644
--- a/arch/x86/kernel/i386_ksyms_32.c
+++ b/arch/x86/kernel/i386_ksyms_32.c
@@ -21,11 +21,4 @@ EXPORT_SYMBOL(__put_user_8);
 
 EXPORT_SYMBOL(strstr);
 
-#ifdef CONFIG_SMP
-extern void FASTCALL( __write_lock_failed(rwlock_t *rw));
-extern void FASTCALL( __read_lock_failed(rwlock_t *rw));
-EXPORT_SYMBOL(__write_lock_failed);
-EXPORT_SYMBOL(__read_lock_failed);
-#endif
-
 EXPORT_SYMBOL(csum_partial);
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 77c25b3..e28b533 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -34,13 +34,6 @@ EXPORT_SYMBOL(__copy_from_user_inatomic);
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
 
-#ifdef CONFIG_SMP
-extern void  __write_lock_failed(rwlock_t *rw);
-extern void  __read_lock_failed(rwlock_t *rw);
-EXPORT_SYMBOL(__write_lock_failed);
-EXPORT_SYMBOL(__read_lock_failed);
-#endif
-
 /* Export string functions. We normally rely on gcc builtin for most of these,
    but gcc sometimes decides not to inline them. */    
 #undef memcpy

