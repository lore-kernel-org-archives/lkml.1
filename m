Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbXA0HGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbXA0HGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 02:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXA0HGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 02:06:32 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:41485 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbXA0HGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 02:06:30 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 27 Jan 2007 01:55:18 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, len.brown@intel.com
Subject: [PATCH] ACPI: Correct apparent typo "CONFIG_ACPI_DEBUG_OUTPUT".
Message-ID: <Pine.LNX.4.64.0701270145540.32670@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Replace the apparent typo CONFIG_ACPI_DEBUG_OUTPUT with
the non-Kconfig conditional ACPI_DEBUG_OUTPUT, which is what every
other file uses.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 698a154..d65142a 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -891,7 +891,7 @@ static int acpi_device_set_context(struct acpi_device *device, int type)
 static void acpi_device_get_debug_info(struct acpi_device *device,
 				       acpi_handle handle, int type)
 {
-#ifdef CONFIG_ACPI_DEBUG_OUTPUT
+#ifdef ACPI_DEBUG_OUTPUT
 	char *type_string = NULL;
 	char name[80] = { '?', '\0' };
 	struct acpi_buffer buffer = { sizeof(name), name };
@@ -928,7 +928,7 @@ static void acpi_device_get_debug_info(struct acpi_device *device,
 	}

 	printk(KERN_DEBUG "Found %s %s [%p]\n", type_string, name, handle);
-#endif				/*CONFIG_ACPI_DEBUG_OUTPUT */
+#endif				/* ACPI_DEBUG_OUTPUT */
 }

 static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
