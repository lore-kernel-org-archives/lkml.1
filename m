Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZCIJVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZCIJVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZCIJVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:21:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:45472 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZCIJVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:21:06 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [v1 PATCH 1/1] PCI: Add AMD8111 PCI Bridge PCI Device ID
Date: Mon,  9 Mar 2009 17:09:03 +0800
Message-Id: <1236589743-4358-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1236589743-4358-1-git-send-email-qingtao.cao@windriver.com>
References: <1236589743-4358-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 09 Mar 2009 09:21:03.0944 (UTC) FILETIME=[5E9AB480:01C9A098]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the PCI Device ID for the PCI Bridge Controller on AMD8111 chip,
which is used by AMD8111 EDAC driver.

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

