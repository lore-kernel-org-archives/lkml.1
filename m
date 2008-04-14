Return-Path: <linux-kernel-owner+w=401wt.eu-S1765072AbYDNSOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765072AbYDNSOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763933AbYDNSOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:14:32 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49278 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762857AbYDNSOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:14:31 -0400
Date: Mon, 14 Apr 2008 21:13:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: ysato@users.sourceforge.jp
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove include/asm-h8300/keyboard.h
Message-ID: <20080414181325.GB6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused include/asm-h8300/keyboard.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008

 include/asm-h8300/keyboard.h |   24 ------------------------
 1 file changed, 24 deletions(-)

372be646df287c70971a0a5a8a1e2ee5dbc5a47f diff --git a/include/asm-h8300/keyboard.h b/include/asm-h8300/keyboard.h
deleted file mode 100644
index 90efbd6..0000000
--- a/include/asm-h8300/keyboard.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- *  linux/include/asm-h8300/keyboard.h
- *  Created 04 Dec 2001 by Khaled Hassounah <khassounah@mediumware.net>
- *  This file contains the Dragonball architecture specific keyboard definitions
- */
-
-#ifndef _H8300_KEYBOARD_H
-#define _H8300_KEYBOARD_H
-
-
-/* dummy i.e. no real keyboard */
-#define kbd_setkeycode(x...)	(-ENOSYS)
-#define kbd_getkeycode(x...)	(-ENOSYS)
-#define kbd_translate(x...)	(0)
-#define kbd_unexpected_up(x...)	(1)
-#define kbd_leds(x...)		do {;} while (0)
-#define kbd_init_hw(x...)	do {;} while (0)
-#define kbd_enable_irq(x...)	do {;} while (0)
-#define kbd_disable_irq(x...)	do {;} while (0)
-
-#endif  /* _H8300_KEYBOARD_H */
-
-
-

