Return-Path: <linux-kernel-owner+w=401wt.eu-S970405AbXFHQTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970405AbXFHQTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969383AbXFHQRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:17:15 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:24623 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S969500AbXFHQRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:17:12 -0400
Date: Fri, 08 Jun 2007 09:52:47 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 4/6]
Message-ID: <46697b4f.9LHHFdS+5Is2R+M0%dougthompson@xmission.com>
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
