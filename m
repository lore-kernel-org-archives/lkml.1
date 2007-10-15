Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXJOUsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXJOUsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759096AbXJOUsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:48:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401AbXJOUsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:48:07 -0400
From: Jeremy Katz <katzj@redhat.com>
To: hmh@hmh.eng.br
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       davej@redhat.com, Jeremy Katz <katzj@redhat.com>
Subject: [PATCH] Map volume and brightness events on thinkpads
Date: Mon, 15 Oct 2007 16:45:10 -0400
Message-Id: <1192481110-9299-1-git-send-email-katzj@redhat.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are standard keycodes for brightness and volume; map the events to
emit them so that things work properly

Signed-off-by: Jeremy Katz <katzj@redhat.com>
---
 drivers/misc/thinkpad_acpi.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 6c0b2f0..64ae4b4 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -945,15 +945,15 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 		KEY_UNKNOWN,	/* 0x0C: FN+BACKSPACE */
 		KEY_UNKNOWN,	/* 0x0D: FN+INSERT */
 		KEY_UNKNOWN,	/* 0x0E: FN+DELETE */
-		KEY_RESERVED,	/* 0x0F: FN+HOME (brightness up) */
+		KEY_BRIGHTNESSUP,	/* 0x0F: FN+HOME (brightness up) */
 		/* Scan codes 0x10 to 0x1F: Extended ACPI HKEY hot keys */
-		KEY_RESERVED,	/* 0x10: FN+END (brightness down) */
+		KEY_BRIGHTNESSDOWN,	/* 0x10: FN+END (brightness down) */
 		KEY_RESERVED,	/* 0x11: FN+PGUP (thinklight toggle) */
 		KEY_UNKNOWN,	/* 0x12: FN+PGDOWN */
 		KEY_ZOOM,	/* 0x13: FN+SPACE (zoom) */
-		KEY_RESERVED,	/* 0x14: VOLUME UP */
-		KEY_RESERVED,	/* 0x15: VOLUME DOWN */
-		KEY_RESERVED,	/* 0x16: MUTE */
+		KEY_VOLUMEUP,	/* 0x14: VOLUME UP */
+		KEY_VOLUMEDOWN,	/* 0x15: VOLUME DOWN */
+		KEY_MUTE,	/* 0x16: MUTE */
 		KEY_VENDOR,	/* 0x17: Thinkpad/AccessIBM/Lenovo */
 		/* (assignments unknown, please report if found) */
 		KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN,
@@ -974,9 +974,9 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 		KEY_RESERVED,	/* 0x11: FN+PGUP (thinklight toggle) */
 		KEY_UNKNOWN,	/* 0x12: FN+PGDOWN */
 		KEY_ZOOM,	/* 0x13: FN+SPACE (zoom) */
-		KEY_RESERVED,	/* 0x14: VOLUME UP */
-		KEY_RESERVED,	/* 0x15: VOLUME DOWN */
-		KEY_RESERVED,	/* 0x16: MUTE */
+		KEY_VOLUMEUP,	/* 0x14: VOLUME UP */
+		KEY_VOLUMEDOWN,	/* 0x15: VOLUME DOWN */
+		KEY_MUTE,	/* 0x16: MUTE */
 		KEY_VENDOR,	/* 0x17: Thinkpad/AccessIBM/Lenovo */
 		/* (assignments unknown, please report if found) */
 		KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN, KEY_UNKNOWN,
-- 
1.5.3.4

