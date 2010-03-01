Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0CAN0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:26:39 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:58849
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751457Ab0CAN0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:26:37 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h6bh87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLULG-01-6WX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/4] x86/amd-iommu: Remove double NULL check in check_device
Date: Mon, 1 Mar 2010 14:24:39 +0100
Message-ID: <1267449882-1415-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267449882-1415-1-git-send-email-joerg.roedel@amd.com>
References: <1267449882-1415-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 01 Mar 2010 13:24:48.0724 (UTC) FILETIME=[911FC940:01CAB942]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

dev was tested just above, so drop the second test.

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index adb0ba0..2c4a501 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -118,7 +118,7 @@ static bool check_device(struct device *dev)
 		return false;
 
 	/* No device or no PCI device */
-	if (!dev || dev->bus != &pci_bus_type)
+	if (dev->bus != &pci_bus_type)
 		return false;
 
 	devid = get_device_id(dev);
-- 
1.7.0


