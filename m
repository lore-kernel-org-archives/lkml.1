Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbXDFI7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbXDFI7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 04:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766521AbXDFI7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 04:59:35 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36397 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbXDFI7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 04:59:34 -0400
Date: Fri, 6 Apr 2007 10:55:57 +0200
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 2.6.20.4] pci-calgary: cleanup of unneeded macros
Message-ID: <20070406085557.GB11218@bull.net>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/04/2007 11:01:53,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/04/2007 11:01:54,
	Serialize complete at 06/04/2007 11:01:54
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup unneeded macros used for register space address calculation. 
Now we are using the EBDA to find the space address.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@bull.net>
---
 pci-calgary.c |    5 -----
 1 file changed, 5 deletions(-)
Index: linux-2.6.20.4/arch/x86_64/kernel/pci-calgary.c
===================================================================
--- linux-2.6.20.4.orig/arch/x86_64/kernel/pci-calgary.c	2007-04-06 09:42:12.000000000 +0200
+++ linux-2.6.20.4/arch/x86_64/kernel/pci-calgary.c	2007-04-06 09:42:20.000000000 +0200
@@ -53,11 +53,6 @@
 #define PCI_VENDOR_DEVICE_ID_CALGARY \
 	(PCI_VENDOR_ID_IBM | PCI_DEVICE_ID_IBM_CALGARY << 16)
 
-/* we need these for register space address calculation */
-#define START_ADDRESS           0xfe000000
-#define CHASSIS_BASE            0
-#define ONE_BASED_CHASSIS_NUM   1
-
 /* register offsets inside the host bridge space */
 #define CALGARY_CONFIG_REG	0x0108
 #define PHB_CSR_OFFSET		0x0110 /* Channel Status */
