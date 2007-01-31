Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbXAaRC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbXAaRC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933028AbXAaRC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:02:28 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48169 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932995AbXAaRC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:02:27 -0500
Date: Wed, 31 Jan 2007 17:14:38 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: [PATCH] pata_via: Correct missing comments
Message-ID: <20070131171438.53481d42@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The 8237S was added to the chipsets but not to the comments. Fix this

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/ata/pata_via.c linux-2.6.20-rc6-mm3/drivers/ata/pata_via.c
--- linux.vanilla-2.6.20-rc6-mm3/drivers/ata/pata_via.c	2007-01-31 14:20:39.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/ata/pata_via.c	2007-01-31 14:32:49.000000000 +0000
@@ -23,6 +23,7 @@
  *	VIA VT8233c	-	UDMA100
  *	VIA VT8235	-	UDMA133
  *	VIA VT8237	-	UDMA133
+ *	VIA VT8237S	-	UDMA133
  *	VIA VT8251	-	UDMA133
  *
  *	Most registers remain compatible across chips. Others start reserved
@@ -61,7 +62,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_via"
-#define DRV_VERSION "0.2.0"
+#define DRV_VERSION "0.2.1"
 
 /*
  *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
