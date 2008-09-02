Return-Path: <linux-kernel-owner+w=401wt.eu-S1751386AbYIBLOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbYIBLOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 07:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYIBLOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 07:14:05 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:55079 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYIBLOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 07:14:03 -0400
X-BigFish: VPS5(zba6izzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K6KF6U-03-AX7-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] x86, pci: add northbridge pci ids for fam 0x11 processors
Date: Tue, 2 Sep 2008 13:13:39 +0200
Message-ID: <1220354020-4883-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1220354020-4883-1-git-send-email-joerg.roedel@amd.com>
References: <1220354020-4883-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Sep 2008 11:13:40.0645 (UTC) FILETIME=[F4407550:01C90CEC]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI device ids for AMD family 0x11 processors are missing in pci_ids.h.
This patch adds them.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/pci_ids.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index cad476d..e15854e 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -502,6 +502,11 @@
 #define PCI_DEVICE_ID_AMD_10H_NB_DRAM	0x1202
 #define PCI_DEVICE_ID_AMD_10H_NB_MISC	0x1203
 #define PCI_DEVICE_ID_AMD_10H_NB_LINK	0x1204
+#define PCI_DEVICE_ID_AMD_11H_NB_HT	0x1300
+#define PCI_DEVICE_ID_AMD_11H_NB_MAP	0x1301
+#define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
+#define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
+#define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
 #define PCI_DEVICE_ID_AMD_SCSI		0x2020
-- 
1.5.3.7


