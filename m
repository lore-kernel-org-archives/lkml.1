Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbXHaWfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbXHaWfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 18:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXHaWfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 18:35:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48614 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751941AbXHaWfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 18:35:20 -0400
Date: Fri, 31 Aug 2007 23:43:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pci.h: Add PCI identifiers for mainpine cards
Message-ID: <20070831234345.3c7a8a62@the-village.bc.nu>
In-Reply-To: <20070831152058.92306a0c.akpm@linux-foundation.org>
References: <20070822230527.649f3714@the-village.bc.nu>
	<20070831152058.92306a0c.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/serial/8250_pci.c:2584: error: 'PCI_VENDOR_ID_MAINPINE' undeclared here (not in a function)
> drivers/serial/8250_pci.c:2584: error: 'PCI_DEVICE_ID_MAINPINE_PBRIDGE' undeclared here (not in a function)

Doh.....

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc3-mm1/include/linux/pci_ids.h linux-2.6.23rc3-mm1/include/linux/pci_ids.h
--- linux.vanilla-2.6.23rc3-mm1/include/linux/pci_ids.h	2007-08-22 17:23:14.000000000 +0100
+++ linux-2.6.23rc3-mm1/include/linux/pci_ids.h	2007-08-22 17:50:52.000000000 +0100
@@ -1976,6 +1977,8 @@
 #define PCI_VENDOR_ID_TOPIC		0x151f
 #define PCI_DEVICE_ID_TOPIC_TP560	0x0000
 
+#define PCI_VENDOR_ID_MAINPINE		0x1522
+#define PCI_DEVICE_ID_MAINPINE_PBRIDGE	0x0100
 #define PCI_VENDOR_ID_ENE		0x1524
 #define PCI_DEVICE_ID_ENE_CB712_SD	0x0550
 #define PCI_DEVICE_ID_ENE_CB712_SD_2	0x0551


