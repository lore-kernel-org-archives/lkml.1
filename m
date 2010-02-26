Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965323Ab0BZQdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:33:36 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:59508 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965309Ab0BZQde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:33:34 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: platform-driver-x86@vger.kernel.org
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org, don@syst.com.br,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] classmate-laptop: Added some keys present in other devices
Date: Fri, 26 Feb 2010 13:26:51 -0300
Message-Id: <1267201611-4134-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some new devices have extra keys, which we add to our list. Currently,
they all generate events that allow us to use a simple table/array,
without need for the sparse keymap.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/platform/x86/classmate-laptop.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index e315019..9bdd269 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -508,6 +508,10 @@ static int cmpc_keys_codes[] = {
 	KEY_BRIGHTNESSDOWN,
 	KEY_BRIGHTNESSUP,
 	KEY_VENDOR,
+	KEY_UNKNOWN,
+	KEY_CAMERA,
+	KEY_BACK,
+	KEY_FORWARD,
 	KEY_MAX
 };
 
-- 
1.6.6.1

