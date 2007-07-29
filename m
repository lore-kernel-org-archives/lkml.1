Return-Path: <linux-kernel-owner+w=401wt.eu-S1765929AbXG2PMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765929AbXG2PMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764551AbXG2PAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:00:05 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47881 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764784AbXG2PAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:00:02 -0400
Date: Sun, 29 Jul 2007 16:59:39 +0200
From: Adrian Bunk <bunk@stusta.de>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport fb_prepare_logo
Message-ID: <20070729145939.GK16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The logo code is not and should not be used by modules.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/video/fbmem.c.old	2007-07-28 07:48:45.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/video/fbmem.c	2007-07-28 07:49:09.000000000 +0200
@@ -1653,7 +1653,6 @@ EXPORT_SYMBOL(register_framebuffer);
 EXPORT_SYMBOL(unregister_framebuffer);
 EXPORT_SYMBOL(num_registered_fb);
 EXPORT_SYMBOL(registered_fb);
-EXPORT_SYMBOL(fb_prepare_logo);
 EXPORT_SYMBOL(fb_show_logo);
 EXPORT_SYMBOL(fb_set_var);
 EXPORT_SYMBOL(fb_blank);

