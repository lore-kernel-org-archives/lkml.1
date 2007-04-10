Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbXDJTwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbXDJTwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXDJTwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:52:22 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:36856 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbXDJTwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:52:21 -0400
Date: Tue, 10 Apr 2007 21:52:01 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jens Axboe <axboe@kernel.dk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/30] Use menuconfig objects - block layer
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102150380.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/block/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/block/Kconfig
+++ linux-2.6.21-rc5/block/Kconfig
@@ -1,7 +1,7 @@
 #
 # Block layer core configuration
 #
-config BLOCK
+menuconfig BLOCK
        bool "Enable the block layer" if EMBEDDED
        default y
        help
@@ -49,6 +49,6 @@ config LSF
 
 	  If unsure, say Y.
 
-endif
+endif # BLOCK
 
 source block/Kconfig.iosched
#<EOF>
