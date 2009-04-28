Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbZD1Oet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbZD1Oet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbZD1Oeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:34:36 -0400
Received: from mail.spamt.net ([78.46.151.67]:54403 "EHLO mail.spamt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZD1Oef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:34:35 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Apr 2009 10:34:35 EDT
From: Ulrich Dangel <uli@spamt.net>
To: linux-input@vger.kernel.org, jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, Ulrich Dangel <uli@spamt.net>
Subject: [PATCH] HID: Fix the support for apple mini aluminium keyboard
Date: Tue, 28 Apr 2009 16:23:51 +0200
Message-Id: <1240928631-19320-1-git-send-email-uli@spamt.net>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quirks for the apple mini keyboard was recently added but keyboard
was recognized as a powerbook keyboard. Adjusted boundary to the lowest
product id for the apple mini keyboard to get the right translation.

Signed-off-by: Ulrich Dangel <uli@spamt.net>
---
 drivers/hid/hid-apple.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 7359d9d..acbce57 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -151,7 +151,7 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 	if (fnmode) {
 		int do_translate;
 
-		trans = apple_find_translation((hid->product < 0x220 ||
+		trans = apple_find_translation((hid->product < 0x21d ||
 					hid->product >= 0x300) ?
 					powerbook_fn_keys : apple_fn_keys,
 					usage->code);
-- 
1.6.2.1

