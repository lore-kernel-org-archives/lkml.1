Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYHLOki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYHLOki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYHLOjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:39:25 -0400
Received: from multi.imgtec.com ([194.200.65.239]:20506 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbYHLOjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:39:21 -0400
From: Will Newton <will.newton@imgtec.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       leoli@freescale.com, Will Newton <will.newton@gmail.com>
Subject: [PATCH 07/11] fsl_usb2_udc: Rename the arguments of the fsl_writel macro.
Date: Tue, 12 Aug 2008 15:39:13 +0100
Message-Id: <1218551957-17091-8-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1218551957-17091-7-git-send-email-will.newton@imgtec.com>
References: <1218551957-17091-1-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-2-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-3-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-4-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-5-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-6-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-7-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 12 Aug 2008 14:39:18.0290 (UTC) FILETIME=[3362EF20:01C8FC89]
X-SEF-Processed: 6_0_1_111__2008_08_12_15_39_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Rename the arguments of the fsl_writel macro to match their use.
Remove a couple of unnecessary prototypes.

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Li Yang <leoli@freescale.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 21f5616..92323c4 100644
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

