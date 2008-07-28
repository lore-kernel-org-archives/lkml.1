Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbYG1VLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbYG1VLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYG1VJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:36 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49590 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYG1VJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:35 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 04/24] x86: kernel/efi.c cleanup
Date: Mon, 28 Jul 2008 18:09:11 -0300
Message-Id: <1217279371-4410-5-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces and tabs.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/efi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 06cc8d4..9fb2959 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -44,7 +44,7 @@
 #include <asm/tlbflush.h>
 
 #define EFI_DEBUG	1
-#define PFX 		"EFI: "
+#define PFX		"EFI: "
 
 int efi_enabled;
 EXPORT_SYMBOL(efi_enabled);
@@ -184,9 +184,9 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 int efi_set_rtc_mmss(unsigned long nowtime)
 {
 	int real_seconds, real_minutes;
-	efi_status_t 	status;
-	efi_time_t 	eft;
-	efi_time_cap_t 	cap;
+	efi_status_t status;
+	efi_time_t eft;
+	efi_time_cap_t cap;
 
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS) {
-- 
1.5.4.5

