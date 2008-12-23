Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbYLWQns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbYLWQns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLWQnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:43:40 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:34736 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYLWQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:43:39 -0500
From: Flavio Leitner <fleitner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Flavio Leitner <fleitner@redhat.com>
Subject: [PATCH] serial_8250: support for Sealevel Systems Model 7803 COMM+8
Date: Tue, 23 Dec 2008 14:42:26 -0200
Message-Id: <12300505464044-git-send-email-fleitner@redhat.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Sealevel Systems Model 7803 COMM+8

Signed-off-by: Flavio Leitner <fleitner@redhat.com>
---
 drivers/serial/8250_pci.c |    3 +++
 include/linux/pci_ids.h   |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 5450a0e..b50a8b7 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -2271,6 +2271,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_COMM8,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_8_115200 },
+	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_7803,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
+		pbn_b2_8_460800 },
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_UCOMM8,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_8_115200 },
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1800f1d..bd42556 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1795,6 +1795,7 @@
 #define PCI_DEVICE_ID_SEALEVEL_UCOMM232	0x7202
 #define PCI_DEVICE_ID_SEALEVEL_COMM4	0x7401
 #define PCI_DEVICE_ID_SEALEVEL_COMM8	0x7801
+#define PCI_DEVICE_ID_SEALEVEL_7803	0x7803
 #define PCI_DEVICE_ID_SEALEVEL_UCOMM8	0x7804
 
 #define PCI_VENDOR_ID_HYPERCOPE		0x1365
-- 
1.5.2.4

