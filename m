Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbYGOP14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbYGOP14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbYGOPZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:25:15 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2275 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbYGOPY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:24:58 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, leoli@freescale.com, tanya.jiang@freescale.com,
       gregkh@suse.de, Will Newton <will.newton@gmail.com>
Subject: [PATCH 07/11] fsl_usb2_udc: Rename the arguments of the fsl_writel macro.
Date: Tue, 15 Jul 2008 16:24:46 +0100
Message-Id: <1216135490-21656-8-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1216135490-21656-7-git-send-email-will.newton@imgtec.com>
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-2-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-3-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-4-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-5-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-6-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-7-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 15 Jul 2008 15:24:53.0230 (UTC) FILETIME=[EDF8A8E0:01C8E68E]
X-SEF-Processed: 6_0_1_111__2008_07_15_16_24_55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Rename the arguments of the fsl_writel macro to match their use.
Remove a couple of unnecessary prototypes.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index e7bdec0..4b452bd 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -71,16 +71,14 @@ fsl_ep0_desc = {
 	.wMaxPacketSize =	USB_MAX_CTRL_PAYLOAD,
 };
 
-static int fsl_udc_suspend(struct platform_device *pdev, pm_message_t state);
-static int fsl_udc_resume(struct platform_device *pdev);
 static void fsl_ep_fifo_flush(struct usb_ep *_ep);
 
 #ifdef CONFIG_PPC32
 #define fsl_readl(addr)		in_le32(addr)
-#define fsl_writel(addr, val32) out_le32(val32, addr)
+#define fsl_writel(val32, addr) out_le32(addr, val32)
 #else
 #define fsl_readl(addr)		readl(addr)
-#define fsl_writel(addr, val32) writel(addr, val32)
+#define fsl_writel(val32, addr) writel(val32, addr)
 #endif
 
 /********************************************************************
-- 
1.5.5.2

