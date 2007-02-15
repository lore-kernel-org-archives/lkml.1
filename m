Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbXBOV4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbXBOV4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932483AbXBOV4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:56:06 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58048 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932382AbXBOV4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:56:03 -0500
Date: Thu, 15 Feb 2007 22:56:09 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Tilman Schmidt <tilman@imap.cc>, Hansjoerg Lipp <hjlipp@web.de>
Cc: gigaset307x-common@lists.sourceforge.net, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] correct CONFIG_GIGASET_M101 Makefile entry
Message-ID: <20070215215609.GH13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Advanced Mathematics, lesson 1:
101 != 105

;-)

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm1/drivers/isdn/gigaset/Makefile.old	2007-02-15 17:38:23.000000000 +0100
+++ linux-2.6.20-mm1/drivers/isdn/gigaset/Makefile	2007-02-15 17:38:41.000000000 +0100
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
 obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o gigaset.o
-obj-$(CONFIG_GIGASET_M105) += ser_gigaset.o gigaset.o
+obj-$(CONFIG_GIGASET_M101) += ser_gigaset.o gigaset.o

