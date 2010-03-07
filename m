Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab0CGX47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 18:56:59 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61654 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0CGX46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 18:56:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GU520S3XvlwSORC+kP1b0orhQlbvRLy5UUl32t9F5F5izfxRtYQC70SmWd7eXk77Z1
         9A0hjuTTJaHzJea2mO+4y/FzlwY70KToyvVW3AvmpV0leeP4di2wQfXqVa6Op6yN4j3U
         L4xlFT7z4U+79RdZI9kJY1fnJ/COQENIjty2I=
From: Stewart Malik <mali0037@gmail.com>
To: mj@ucw.cz, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, linux-video@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, Stewart Malik <mali0037@gmail.com>
Subject: [PATCH] ARCH: x86: fix coding style issues in video-vesa.c
Date: Mon,  8 Mar 2010 10:26:42 +1030
Message-Id: <1268006202-12486-1-git-send-email-mali0037@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/x86/boot/video-vesa.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 11e8c6e..426d330 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -263,15 +263,14 @@ void vesa_store_edid(void)
 	/* ireg.cx = 0; */		/* Controller 0 */
 	/* ireg.dx = 0;	*/		/* EDID block number */
 	ireg.es = ds();
-	ireg.di =(size_t)&boot_params.edid_info; /* (ES:)Pointer to block */
+	ireg.di = (size_t)&boot_params.edid_info; /* (ES:)Pointer to block */
 	intcall(0x10, &ireg, &oreg);
 #endif /* CONFIG_FIRMWARE_EDID */
 }
 
 #endif /* not _WAKEUP */
 
-static __videocard video_vesa =
-{
+static __videocard video_vesa = {
 	.card_name	= "VESA",
 	.probe		= vesa_probe,
 	.set_mode	= vesa_set_mode,
-- 
1.6.0.4

