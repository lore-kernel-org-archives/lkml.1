Return-Path: <linux-kernel-owner+w=401wt.eu-S2992810AbXBIUiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992810AbXBIUiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 15:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992811AbXBIUiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 15:38:12 -0500
Received: from roc.holo.8d.com ([64.254.227.115]:40654 "EHLO roc.holo.8d.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992810AbXBIUiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 15:38:11 -0500
X-Greylist: delayed 1441 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 15:38:11 EST
Message-ID: <45CCD60D.5050001@8d.com>
Date: Fri, 09 Feb 2007 15:14:05 -0500
From: Raphael Assenat <raph@8d.com>
User-Agent: Mozilla Thunderbird 1.0 (X11/20050118)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add PCI device ID for IT8152 RISC-to-PCI chip
X-Enigmail-Version: 0.89.5.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: multipart/mixed;
 boundary="------------030805000506060703050206"
X-Spam-Score: -2.6
X-Spam-Report: -2.6 points, 5.0 required autolearn=no
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030805000506060703050206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds a PCI device ID (0x8152) for the IT8152F/G
Advanced RISC-to-PCI Companion Chip.

-- 
Raphael Assenat
8D Technologies Inc.

--------------030805000506060703050206
Content-Type: text/plain;
 name="it8152-pciid.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="it8152-pciid.diff"

This patch adds a PCI device ID for the IT8152F/G 
Advanced RISC-to-PCI Companion Chip.

Signed-off-by: Raphael Assenat <raph@8d.com>

--- linux-2.6.20/include/linux/pci_ids.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.20-8d/include/linux/pci_ids.h	2007-02-09 15:00:38.000000000 -0500
@@ -1626,6 +1626,7 @@
 #define PCI_VENDOR_ID_ROCKWELL		0x127A
 
 #define PCI_VENDOR_ID_ITE		0x1283
+#define PCI_DEVICE_ID_ITE_8152		0x8152
 #define PCI_DEVICE_ID_ITE_8211		0x8211
 #define PCI_DEVICE_ID_ITE_8212		0x8212
 #define PCI_DEVICE_ID_ITE_8872		0x8872

--------------030805000506060703050206--
