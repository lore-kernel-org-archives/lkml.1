Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbYHDCih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbYHDCih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760920AbYHDCfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:35:04 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44596 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761348AbYHDCfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:35:02 -0400
Message-ID: <57601.166.70.238.45.1217816079.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 3 Aug 2008 20:14:39 -0600 (MDT)
Subject: [PATCH 2.6.26 24/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware Style Debugger for Linux written by Jeffrey Vernon Merkey

--- linux-2.6.26/lib/Kconfig.debug	2008-07-13 15:51:29.000000000 -0600 +++
linux-2.6.26-mdb/lib/Kconfig.debug	2008-08-03 12:49:01.000000000 -0600 @@
-131,6 +131,31 @@
 	  Say Y here if you are developing drivers or trying to debug and
identify kernel problems.

+config MDB
+	bool "Merkey's Kernel Debugger"
+	depends on DEBUG_KERNEL
+	select KALLSYMS
+	select KALLSYMS_ALL
+	help
+           NetWare style kernel debugger for Linux written by Jeffrey Vernon
+	   Merkey.
+
+config MDB_CONSOLE_REDIRECTION
+	bool "MDB Console Redirection Support"
+	depends on MDB
+	default y
+	help
+           Reset any Console Redirection to default system settings (0) 
+           when the MDB debugger is active.  The Debugger will restore  +
          the redirection to the custom settings when the debugger  +     
     is exited.  This feature is useful on systems which by default

+           redirect printk output and the screen debugger output to a log
+           file or system device, which can prevent the debugger screen
from
+           being visible.  Enabling this feature does not affect or disable
+           remote operations via serial port.  It is recommended to enable
+           this feature by default if intensive debugging is intended for
+           the target system.
+
 config DEBUG_SHIRQ
 	bool "Debug shared IRQ handlers"
 	depends on DEBUG_KERNEL && GENERIC_HARDIRQS


By making a contribution to this project, I certify that the contribution
was created in whole or in part by me and I have the right to submit it
under the open source license indicated in the file

Jeffrey Vernon Merkey





