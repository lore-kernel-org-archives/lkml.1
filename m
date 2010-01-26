Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796Ab0AZXki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0AZXki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193Ab0AZXkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:40:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58644 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab0AZXke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:40:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AGvX9nSfbHj0fAGCZJzRCUsnKWiKc9BPsgXAy1CaMQu1dLj8mjIjih2NC8ueM5ZznC
         XuwRg2e++zwTmXi+ZbkKKAdEaEe2ldUNHAm8k4AlPKKTHfRrB3VCIFyKkiWRa1AYwSUb
         fJwoLDEDjigC4fJKmkyPGq03yw7/2RT8YUJxY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Clean-up a few comments.
Date: Tue, 26 Jan 2010 15:39:38 -0800
Message-Id: <1264549178-2874-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 arch/x86/kernel/setup.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f7b8b98..1bd37e9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -245,7 +245,7 @@ struct edd edd;
 #ifdef CONFIG_EDD_MODULE
 EXPORT_SYMBOL(edd);
 #endif
-/**
+/*
  * copy_edd() - Copy the BIOS EDD information
  *              from boot_params into a safe place.
  *
@@ -398,8 +398,8 @@ static void __init reserve_initrd(void)
 
 	if (ramdisk_end <= end_of_lowmem) {
 		/* All in lowmem, easy case */
-		/*
-		 * don't need to reserve again, already reserved early
+		
+		/* don't need to reserve again, already reserved early
 		 * in i386_start_kernel
 		 */
 		initrd_start = ramdisk_image + PAGE_OFFSET;
@@ -665,8 +665,7 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
  * for initialization.  Note, the efi init code path is determined by the
  * global efi_enabled. This allows the same kernel image to be used on existing
  * systems (with a traditional BIOS) as well as on EFI systems.
- */
-/*
+ *
  * setup_arch - architecture-specific boot-time initializations
  *
  * Note: On x86_64, fixmaps are ready for use even before this is called.
-- 
1.6.5.GIT

