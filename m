Return-Path: <linux-kernel-owner+w=401wt.eu-S933770AbXDASOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbXDASOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933775AbXDASOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:14:06 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:38888 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770AbXDASOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:14:04 -0400
Date: Sun, 1 Apr 2007 20:13:48 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH 1/16] vt-sysfs-for-colors.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Allow for the palette to be exposed and changed via sysfs. A call to
/usr/bin/reset will slurp the new definitions in for the current
console.

Already posted at http://lkml.org/lkml/2006/1/15/149

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

 vt.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.21-rc5/drivers/char/vt.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/char/vt.c
+++ linux-2.6.21-rc5/drivers/char/vt.c
@@ -934,6 +934,10 @@ int default_grn[] = {0x00,0x00,0xaa,0x55
 int default_blu[] = {0x00,0x00,0x00,0x00,0xaa,0xaa,0xaa,0xaa,
     0x55,0x55,0x55,0x55,0xff,0xff,0xff,0xff};
 
+module_param_array(default_red, int, NULL, S_IRUGO | S_IWUSR);
+module_param_array(default_grn, int, NULL, S_IRUGO | S_IWUSR);
+module_param_array(default_blu, int, NULL, S_IRUGO | S_IWUSR);
+
 /*
  * gotoxy() must verify all boundaries, because the arguments
  * might also be negative. If the given position is out of
#<EOF>

