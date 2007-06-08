Return-Path: <linux-kernel-owner+w=401wt.eu-S1030644AbXFHQnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030644AbXFHQnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969663AbXFHQmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:42:12 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:25233 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S969519AbXFHQmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:42:11 -0400
Date: Fri, 08 Jun 2007 10:45:10 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 4/6] include linux pci_id-h add amd northbridge defines
Message-ID: <46698796.gjBYQfxJb/tGpgvg%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

pci_ids.h needs two of the AMD NB device-ids namely,
Addressmap and the Memory Controller devices

This patch adds those to the pci_id.h include file

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
Cc:	alan@lxorguk.ukuu.org.uk
---
 pci_ids.h |    2 ++
 1 file changed, 2 insertions(+)


Index: linux-2.6.22-rc4-mm1/include/linux/pci_ids.h
===================================================================
--- linux-2.6.22-rc4-mm1.orig/include/linux/pci_ids.h
+++ linux-2.6.22-rc4-mm1/include/linux/pci_ids.h
@@ -489,6 +489,8 @@
 
 #define PCI_VENDOR_ID_AMD		0x1022
 #define PCI_DEVICE_ID_AMD_K8_NB		0x1100
+#define PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP	0x1101
+#define PCI_DEVICE_ID_AMD_K8_NB_MEMCTL	0x1102
 #define PCI_DEVICE_ID_AMD_K8_NB_MISC	0x1103
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
