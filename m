Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZCIIW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZCIIW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZCIIUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:20:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:37106 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbZCIIUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:20:30 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v1 PATCH 5/8] PCI: Add AMD8111 PCI Bridge PCI Device ID
Date: Mon,  9 Mar 2009 16:08:14 +0800
Message-Id: <1236586097-3830-6-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1236586097-3830-5-git-send-email-qingtao.cao@windriver.com>
References: <1236586097-3830-1-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-2-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-3-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-4-git-send-email-qingtao.cao@windriver.com>
 <1236586097-3830-5-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 09 Mar 2009 08:20:24.0400 (UTC) FILETIME=[E5445D00:01C9A08F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the PCI Device ID of the PCI Bridge Controller on AMD8111 chip.

(I will send this patch separately to the maintainer of pci_ids.h, 
it's here just to show the device used by AMD8111 EDAC driver)

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 include/linux/pci_ids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index aca8c45..15e2ccc 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -526,6 +526,7 @@
 #define PCI_DEVICE_ID_AMD_OPUS_7443	0x7443
 #define PCI_DEVICE_ID_AMD_VIPER_7443	0x7443
 #define PCI_DEVICE_ID_AMD_OPUS_7445	0x7445
+#define PCI_DEVICE_ID_AMD_8111_PCI	0x7460
 #define PCI_DEVICE_ID_AMD_8111_LPC	0x7468
 #define PCI_DEVICE_ID_AMD_8111_IDE	0x7469
 #define PCI_DEVICE_ID_AMD_8111_SMBUS2	0x746a
-- 
1.5.6.2

