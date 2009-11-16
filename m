Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbZKPOUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbZKPOUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZKPOTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:19:49 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:20230
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753352AbZKPOQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:21 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ2-02-PYZ-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 12/21] amd64_edac: remove superfluous dbg printk
Date: Mon, 16 Nov 2009 15:16:39 +0100
Message-ID: <1258381008-18783-13-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0063 (UTC) FILETIME=[5A28D170:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 7e67054..86742aa 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1336,9 +1336,6 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 	/* Read from the ECS data register for the HIGH portion */
 	amd64_read_pci_cfg(pvt->addr_f1_ctl, high_offset, &high_limit);
 
-	debugf0("  HW Regs: BASE=0x%08x-%08x      LIMIT=  0x%08x-%08x\n",
-		high_base, low_base, high_limit, low_limit);
-
 	pvt->dram_DstNode[dram] = (low_limit & 0x7);
 	pvt->dram_IntlvSel[dram] = (low_limit >> 8) & 0x7;
 
-- 
1.6.4.3


