Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbZFYFP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbZFYFP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZFYFNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:13:46 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1442 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZFYFNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:13:43 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/19] drivers/memstick: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:23 -0700
Message-Id: <a4f45a1f8ff897933c8bb8d614676e210f5f508d.1245906152.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/memstick/host/jmb38x_ms.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index f4a162a..cdd89be 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -982,8 +982,7 @@ static void jmb38x_ms_remove(struct pci_dev *dev)
 }
 
 static struct pci_device_id jmb38x_ms_id_tbl [] = {
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB38X_MS, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB38X_MS), 0 },
 	{ }
 };
 
-- 
1.6.3.1.10.g659a0.dirty

