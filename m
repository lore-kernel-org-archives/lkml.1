Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbXDJTyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbXDJTyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXDJTyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:54:40 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:37986 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbXDJTyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:54:39 -0400
Date: Tue, 10 Apr 2007 21:53:29 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/30] Use menuconfig objects - connector
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102152550.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/drivers/connector/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/connector/Kconfig
+++ linux-2.6.21-rc5/drivers/connector/Kconfig
@@ -1,6 +1,5 @@
-menu "Connector - unified userspace <-> kernelspace linker"
 
-config CONNECTOR
+menuconfig CONNECTOR
 	tristate "Connector - unified userspace <-> kernelspace linker"
 	depends on NET
 	---help---
@@ -10,6 +9,8 @@ config CONNECTOR
 	  Connector support can also be built as a module.  If so, the module
 	  will be called cn.ko.
 
+if CONNECTOR
+
 config PROC_EVENTS
 	boolean "Report process events to userspace"
 	depends on CONNECTOR=y
@@ -18,4 +19,4 @@ config PROC_EVENTS
 	  Provide a connector that reports process events to userspace. Send
 	  events such as fork, exec, id change (uid, gid, suid, etc), and exit.
 
-endmenu
+endif # CONNECTOR
#<EOF>
