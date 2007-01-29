Return-Path: <linux-kernel-owner+w=401wt.eu-S933170AbXA2GIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbXA2GIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 01:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbXA2GID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 01:08:03 -0500
Received: from lixom.net ([66.141.50.11]:46058 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933170AbXA2GIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 01:08:02 -0500
Date: Mon, 29 Jan 2007 00:14:24 -0600
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add PA Semi PCI vendor id
Message-ID: <20070129061424.GB7814@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Olof Johansson <olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add PA Semi's PCI vendor ID (0x1959).


Signed-off-by: Olof Johansson <olof@lixom.net>

---

Submitting this separately -- several drivers that have recently been
posted could make use of it. I didn't want to include it in each of them
and have patch conflicts when they're combined upstream.



Index: merge/include/linux/pci_ids.h
===================================================================
--- merge.orig/include/linux/pci_ids.h
+++ merge/include/linux/pci_ids.h
@@ -2078,6 +2078,8 @@
 #define PCI_VENDOR_ID_TDI               0x192E
 #define PCI_DEVICE_ID_TDI_EHCI          0x0101
 
+#define PCI_VENDOR_ID_PASEMI		0x1959
+
 #define PCI_VENDOR_ID_JMICRON		0x197B
 #define PCI_DEVICE_ID_JMICRON_JMB360	0x2360
 #define PCI_DEVICE_ID_JMICRON_JMB361	0x2361
