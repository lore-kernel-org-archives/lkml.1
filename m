Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbYCTUfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbYCTUfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760310AbYCTUag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:30:36 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:45951 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760340AbYCTUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:30:34 -0400
Message-ID: <47E2C968.8020102@tiscali.nl>
Date: Thu, 20 Mar 2008 21:30:32 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: sam@ravnborg.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] scripts/kconfig/lxdialog/inputbox.c: reversed draw_box(dlg.border.atr
 and dlg.dialog.atr) in dialog_inputbox()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not tested, please confirm it's right.
---
Fix reversal of dlg.border.atr and dlg.dialog.atr for draw_box()

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index 4946bd0..616c601 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -89,7 +89,7 @@ do_resize:
 	box_y = y + 2;
 	box_x = (width - box_width) / 2;
 	draw_box(dialog, y + 1, box_x - 1, 3, box_width + 2,
-		 dlg.border.atr, dlg.dialog.atr);
+		 dlg.dialog.atr, dlg.border.atr);
 
 	print_buttons(dialog, height, width, 0);
 
