Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbXKERMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbXKERMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbXKERHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:07:34 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59500 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756196AbXKERHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:07:32 -0500
Date: Mon, 5 Nov 2007 18:07:09 +0100
From: Adrian Bunk <bunk@kernel.org>
To: chris@zankel.net
Cc: linux-kernel@vger.kernel.org, "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [2.6 patch] xtensa/kernel/setup.c: remove dead code
Message-ID: <20071105170709.GI12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead code reported by Robert P. J. Day.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e801f21f9b0e708b32bb92f5dba792973576f7aa 
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 2e8d398..9f23a74 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -60,11 +60,6 @@ struct ide_ops *ide_ops;
 extern struct rtc_ops no_rtc_ops;
 struct rtc_ops *rtc_ops;
 
-#ifdef CONFIG_PC_KEYB
-extern struct kbd_ops no_kbd_ops;
-struct kbd_ops *kbd_ops;
-#endif
-
 #ifdef CONFIG_BLK_DEV_INITRD
 extern void *initrd_start;
 extern void *initrd_end;

