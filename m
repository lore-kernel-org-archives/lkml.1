Return-Path: <linux-kernel-owner+w=401wt.eu-S965600AbXBTALy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965600AbXBTALy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965598AbXBTALS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:11:18 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36158 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750964AbXBTAIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:08:13 -0500
Date: Tue, 20 Feb 2007 01:08:12 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [2.6 patch] unexport mac_hid_mouse_emulate_buttons
Message-ID: <20070220000812.GL13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused
EXPORT_SYMBOL(mac_hid_mouse_emulate_buttons).

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/drivers/macintosh/mac_hid.c.old	2007-02-19 15:37:13.000000000 +0100
+++ linux-2.6.20-mm2/drivers/macintosh/mac_hid.c	2007-02-19 15:37:22.000000000 +0100
@@ -102,8 +102,6 @@
 	return 0;
 }
 
-EXPORT_SYMBOL(mac_hid_mouse_emulate_buttons);
-
 static int emumousebtn_input_register(void)
 {
 	int ret;

