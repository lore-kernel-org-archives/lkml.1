Return-Path: <linux-kernel-owner+w=401wt.eu-S1161657AbXD3LnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161657AbXD3LnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161662AbXD3LnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:43:23 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48085 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161657AbXD3LnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:43:22 -0400
Date: Mon, 30 Apr 2007 13:41:43 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 19/36] Use menuconfig objects II - module menu
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301338510.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(This one depends on [PATCH 01/36] as `quilt graph` tells me.)

Change menuconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without entering its
menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 init/Kconfig |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- linux-2.6.21-mm_20070428.orig/init/Kconfig
+++ linux-2.6.21-mm_20070428/init/Kconfig
@@ -657,9 +657,7 @@ config BASE_SMALL
 	default 0 if BASE_FULL
 	default 1 if !BASE_FULL
 
-menu "Loadable module support"
-
-config MODULES
+menuconfig MODULES
 	bool "Enable loadable module support"
 	help
 	  Kernel modules are small pieces of compiled code which can
@@ -739,6 +737,5 @@ config STOP_MACHINE
 	depends on (SMP && MODULE_UNLOAD) || HOTPLUG_CPU
 	help
 	  Need stop_machine() primitive.
-endmenu
 
 source "block/Kconfig"
