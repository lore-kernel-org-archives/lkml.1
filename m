Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbZLVLmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbZLVLmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZLVLm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:42:29 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:59084
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752763AbZLVLls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:41:48 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzab9bhzz1202hzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KV1XTB-02-GEH-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 6/6] edac, pci: remove pesky debug printk
Date: Tue, 22 Dec 2009 12:41:17 +0100
Message-ID: <1261482077-23733-7-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
References: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 22 Dec 2009 11:41:35.0270 (UTC) FILETIME=[B708F460:01CA82FB]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not spam the logs needlessly with the sole info that
edac_pci_dev_parity_clear is being called.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_pci_sysfs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 422728c..fb60a87 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -534,8 +534,6 @@ static void edac_pci_dev_parity_clear(struct pci_dev *dev)
 {
 	u8 header_type;
 
-	debugf0("%s()\n", __func__);
-
 	get_pci_parity_status(dev, 0);
 
 	/* read the device TYPE, looking for bridges */
-- 
1.6.5.4


