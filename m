Return-Path: <linux-kernel-owner+w=401wt.eu-S1765285AbXEYSsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765285AbXEYSsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764973AbXEYSrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:47:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33381 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764934AbXEYSrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:47:49 -0400
Date: Fri, 25 May 2007 11:53:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] kconfig: no STRANGE misc. devices
Message-Id: <20070525115347.c9d1ef64.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

This config symbol name is confusing and unneeded/unwanted, so just
change it to MISC_DEVICES.

*
* Misc devices
*
Misc devices (MISC_STRANGE_DEV) [Y/n] (NEW)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/misc/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.22-rc2-mm1.orig/drivers/misc/Kconfig
+++ linux-2.6.22-rc2-mm1/drivers/misc/Kconfig
@@ -2,11 +2,11 @@
 # Misc strange devices
 #
 
-menuconfig MISC_STRANGE_DEV
+menuconfig MISC_DEVICES
 	bool "Misc devices"
 	default y
 
-if MISC_STRANGE_DEV
+if MISC_DEVICES
 
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
@@ -205,4 +205,4 @@ config EEPROM_93CX6
 	  This is a driver for the EEPROM chipsets 93c46 and 93c66.
 	  The driver supports both read as well as write commands.
 
-endif # MISC_STRANGE_DEV
+endif # MISC_DEVICES
