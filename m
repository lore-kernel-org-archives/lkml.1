Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYCQQbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYCQQbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYCQQbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:31:39 -0400
Received: from hansmi.home.forkbomb.ch ([213.144.146.165]:7520 "EHLO
	hansmi.home.forkbomb.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYCQQbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:31:39 -0400
X-Greylist: delayed 788 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2008 12:31:38 EDT
Date: Mon, 17 Mar 2008 17:18:26 +0100
From: Michael Hanselmann <linux-kernel@hansmi.ch>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, michel@tungstengraphics.com
Subject: [PATCH] Update key codes for Apple aluminium keyboards
Message-ID: <20080317161826.GA29601@hansmi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a discussion with the autor of the original patch adding support
for Apple's new aluminium keyboards
(a45d82d19a6c2a717bcc33cff243199b77fa0082), Michel Dänzer, we decided
that some changes should be done.

Please push this patch into 2.6.25 before it's released. Changing the
key codes later might confuse users.

Signed-off-by: Michael Hanselmann <linux-kernel@hansmi.ch>

---
--- linux-2.6.25-rc6.orig/drivers/hid/hid-input.c	2008-03-17 15:46:52.000000000 +0100
+++ linux-2.6.25-rc6/drivers/hid/hid-input.c	2008-03-17 15:52:37.000000000 +0100
@@ -98,18 +98,16 @@ struct hidinput_key_translation {
 
 static struct hidinput_key_translation apple_fn_keys[] = {
 	{ KEY_BACKSPACE, KEY_DELETE },
-	{ KEY_F1,       KEY_BRIGHTNESSDOWN,     APPLE_FLAG_FKEY },
-	{ KEY_F2,       KEY_BRIGHTNESSUP,       APPLE_FLAG_FKEY },
-	{ KEY_F3,       KEY_CYCLEWINDOWS,       APPLE_FLAG_FKEY }, /* Exposé */
-	{ KEY_F4,       KEY_FN_F4,              APPLE_FLAG_FKEY }, /* Dashboard */
-	{ KEY_F5,       KEY_FN_F5 },
-	{ KEY_F6,       KEY_FN_F6 },
-	{ KEY_F7,       KEY_BACK,               APPLE_FLAG_FKEY },
-	{ KEY_F8,       KEY_PLAYPAUSE,          APPLE_FLAG_FKEY },
-	{ KEY_F9,       KEY_FORWARD,            APPLE_FLAG_FKEY },
-	{ KEY_F10,      KEY_MUTE,               APPLE_FLAG_FKEY },
-	{ KEY_F11,      KEY_VOLUMEDOWN,         APPLE_FLAG_FKEY },
-	{ KEY_F12,      KEY_VOLUMEUP,           APPLE_FLAG_FKEY },
+	{ KEY_F1,       KEY_BRIGHTNESSDOWN, APPLE_FLAG_FKEY },
+	{ KEY_F2,       KEY_BRIGHTNESSUP,   APPLE_FLAG_FKEY },
+	{ KEY_F3,       KEY_FN_F5,          APPLE_FLAG_FKEY }, /* Exposé */
+	{ KEY_F4,       KEY_FN_F4,          APPLE_FLAG_FKEY }, /* Dashboard */
+	{ KEY_F7,       KEY_PREVIOUSSONG,   APPLE_FLAG_FKEY },
+	{ KEY_F8,       KEY_PLAYPAUSE,      APPLE_FLAG_FKEY },
+	{ KEY_F9,       KEY_NEXTSONG,       APPLE_FLAG_FKEY },
+	{ KEY_F10,      KEY_MUTE,           APPLE_FLAG_FKEY },
+	{ KEY_F11,      KEY_VOLUMEDOWN,     APPLE_FLAG_FKEY },
+	{ KEY_F12,      KEY_VOLUMEUP,       APPLE_FLAG_FKEY },
 	{ KEY_UP,       KEY_PAGEUP },
 	{ KEY_DOWN,     KEY_PAGEDOWN },
 	{ KEY_LEFT,     KEY_HOME },
