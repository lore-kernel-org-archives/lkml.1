Return-Path: <linux-kernel-owner+w=401wt.eu-S933773AbXDASOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbXDASOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933775AbXDASOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:14:05 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:38883 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933773AbXDASOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:14:03 -0400
Date: Sun, 1 Apr 2007 20:14:03 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/16] vt-pure-colors.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012002330.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Have the Linux kernel set a new VGA palette for the first 16 colors.
The new values reduce the saturation (white component) and therefore
increase contrast.

Already posted once: http://lkml.org/lkml/2006/1/15/149

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

 vt.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.21-rc5/drivers/char/vt.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/char/vt.c
+++ linux-2.6.21-rc5/drivers/char/vt.c
@@ -927,12 +927,12 @@ unsigned char color_table[] = { 0, 4, 2,
 				       8,12,10,14, 9,13,11,15 };
 
 /* the default colour table, for VGA+ colour systems */
-int default_red[] = {0x00,0xaa,0x00,0xaa,0x00,0xaa,0x00,0xaa,
-    0x55,0xff,0x55,0xff,0x55,0xff,0x55,0xff};
-int default_grn[] = {0x00,0x00,0xaa,0x55,0x00,0x00,0xaa,0xaa,
-    0x55,0x55,0xff,0xff,0x55,0x55,0xff,0xff};
-int default_blu[] = {0x00,0x00,0x00,0x00,0xaa,0xaa,0xaa,0xaa,
-    0x55,0x55,0x55,0x55,0xff,0xff,0xff,0xff};
+int default_red[] =
+{0x00,0xaa,0x00,0xaa,0x00,0xaa,0x00,0xaa,0x55,0xff,0x00,0xff,0x00,0xff,0x00,0xff};
+int default_grn[] =
+{0x00,0x00,0xaa,0x55,0x00,0x00,0xaa,0xaa,0x55,0x00,0xff,0xff,0x00,0x00,0xff,0xff};
+int default_blu[] =
+{0x00,0x00,0x00,0x00,0x90,0xaa,0xaa,0xaa,0x55,0x00,0x00,0x00,0xff,0xff,0xff,0xff};
 
 module_param_array(default_red, int, NULL, S_IRUGO | S_IWUSR);
 module_param_array(default_grn, int, NULL, S_IRUGO | S_IWUSR);
#<EOF>

