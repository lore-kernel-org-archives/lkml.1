Return-Path: <linux-kernel-owner+w=401wt.eu-S2993154AbXEBNYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993154AbXEBNYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 09:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993161AbXEBNYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 09:24:04 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42416 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993154AbXEBNYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 09:24:02 -0400
X-Originating-Ip: 72.143.66.196
Date: Wed, 2 May 2007 09:23:44 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] VIDEO: Remove archaic if[] construct from Kconfig file.
Message-ID: <Pine.LNX.4.64.0705020920580.9346@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the obsolete "if [ ]" construct from the video console Kconfig
file.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  not sure who should have been CCed on this one.


diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index aa3935d..63b85bf 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -19,13 +19,6 @@ config VGA_CONSOLE

 	  Say Y.

-#	if [ "$CONFIG_PCI" = "y" -a "$CONFIG_VGA_CONSOLE" = "y" ]; then
-#	   bool '   Allow VGA on any bus?' CONFIG_VGA_HOSE
-#	   if [ "$CONFIG_VGA_HOSE" = "y" ]; then
-#	      define_bool CONFIG_DUMMY_CONSOLE y
-#	   fi
-#	fi
-
 config VGACON_SOFT_SCROLLBACK
        bool "Enable Scrollback Buffer in System RAM"
        depends on VGA_CONSOLE
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
