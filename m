Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYACQdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYACQdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYACQd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:33:29 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50747 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751005AbYACQd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:33:29 -0500
Date: Thu, 3 Jan 2008 16:31:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lenb@kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: its a directory not a folder....
Message-ID: <20080103163142.55f3a0ab@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed this while fixing some other stuff. The kernel help consistently
uses 'directory', except for ACPI

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/acpi/Kconfig linux-2.6.24-rc6-mm1/drivers/acpi/Kconfig
--- linux.vanilla-2.6.24-rc6-mm1/drivers/acpi/Kconfig	2008-01-02 16:03:58.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/acpi/Kconfig	2008-01-02 16:12:08.000000000 +0000
@@ -68,20 +68,20 @@
 
 	  Say N to delete /proc/acpi/ files that have moved to /sys/
 config ACPI_PROCFS_POWER
-	bool "Deprecated power /proc/acpi folders"
+	bool "Deprecated power /proc/acpi directories"
 	depends on PROC_FS
 	default y
 	---help---
 	  For backwards compatibility, this option allows
-          deprecated power /proc/acpi/ folders to exist, even when
+          deprecated power /proc/acpi/ directories to exist, even when
           they have been replaced by functions in /sys.
-          The deprecated folders (and their replacements) include:
+          The deprecated directories (and their replacements) include:
 	  /proc/acpi/battery/* (/sys/class/power_supply/*)
 	  /proc/acpi/ac_adapter/* (sys/class/power_supply/*)
-	  This option has no effect on /proc/acpi/ folders
+	  This option has no effect on /proc/acpi/ directories
 	  and functions, which do not yet exist in /sys
 
-	  Say N to delete power /proc/acpi/ folders that have moved to /sys/
+	  Say N to delete power /proc/acpi/ directories that have moved to /sys/
 config ACPI_PROC_EVENT
 	bool "Deprecated /proc/acpi/event support"
 	depends on PROC_FS


