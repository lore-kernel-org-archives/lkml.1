Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbYCWIxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbYCWIxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbYCWILn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:43 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2340 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760109AbYCWILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:36 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 032/148] include/asm-x86/efi.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:07 -0700
Message-Id: <1206259443-13210-33-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/efi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/efi.h b/include/asm-x86/efi.h
index ea9734b..d53004b 100644
--- a/include/asm-x86/efi.h
+++ b/include/asm-x86/efi.h
@@ -20,7 +20,7 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
  */
 
 #define efi_call_virt(f, args...) \
-     ((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
+	((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
 
 #define efi_call_virt0(f)		efi_call_virt(f)
 #define efi_call_virt1(f, a1)		efi_call_virt(f, a1)
-- 
1.5.4.rc2

