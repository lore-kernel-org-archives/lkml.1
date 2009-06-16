Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZFPPv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZFPPv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZFPPvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:51:18 -0400
Received: from aun.it.uu.se ([130.238.12.36]:41423 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbZFPPvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:51:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18999.49010.127368.554600@pilspetsen.it.uu.se>
Date: Tue, 16 Jun 2009 17:51:14 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: adaplas@gmail.com
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.30] nvidiafb: fix missing space in log message
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On bootup nvidiafb prints the following on my Apple G5:

	nvidiafb: CRTC 1appears to have a CRT attached

There should be a space between the '1' and the 'appears'.

Fix: add the space

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

diff -rupN linux-2.6.30/drivers/video/nvidia/nv_setup.c linux-2.6.30.nvidiafb-logmsg-missing-space/drivers/video/nvidia/nv_setup.c
--- linux-2.6.30/drivers/video/nvidia/nv_setup.c	2009-06-10 12:00:46.000000000 +0200
+++ linux-2.6.30.nvidiafb-logmsg-missing-space/drivers/video/nvidia/nv_setup.c	2009-06-16 17:41:21.000000000 +0200
@@ -543,7 +543,7 @@ int NVCommonSetup(struct fb_info *info)
 		} else if (analog_on_B) {
 			CRTCnumber = outputBfromCRTC;
 			FlatPanel = 0;
-			printk("nvidiafb: CRTC %i"
+			printk("nvidiafb: CRTC %i "
 			       "appears to have a "
 			       "CRT attached\n", CRTCnumber);
 		} else if (slaved_on_A) {
