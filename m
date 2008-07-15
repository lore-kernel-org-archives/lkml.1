Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbYGOP0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbYGOP0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbYGOPZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:25:03 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2275 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbYGOPY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:24:57 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, leoli@freescale.com, tanya.jiang@freescale.com,
       gregkh@suse.de, Will Newton <will.newton@gmail.com>
Subject: [PATCH 05/11] fsl_usb2_udc: Clean up whitespace in /proc debugging output.
Date: Tue, 15 Jul 2008 16:24:44 +0100
Message-Id: <1216135490-21656-6-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1216135490-21656-5-git-send-email-will.newton@imgtec.com>
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-2-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-3-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-4-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-5-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 15 Jul 2008 15:24:53.0058 (UTC) FILETIME=[EDDE6A20:01C8E68E]
X-SEF-Processed: 6_0_1_111__2008_07_15_16_24_55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Missing spaces were causing the /proc debugging output to be rather
unreadable.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 18f4881..130a59d 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -1909,7 +1909,7 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 	tmp_reg = fsl_readl(&dr_regs->usbsts);
 	t = scnprintf(next, size,
 			"USB Status Reg:\n"
-			"Dr Suspend: %d" "Reset Received: %d" "System Error: %s"
+			"Dr Suspend: %d Reset Received: %d System Error: %s "
 			"USB Error Interrupt: %s\n\n",
 			(tmp_reg & USB_STS_SUSPEND) ? 1 : 0,
 			(tmp_reg & USB_STS_RESET) ? 1 : 0,
@@ -1921,11 +1921,11 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 	tmp_reg = fsl_readl(&dr_regs->usbintr);
 	t = scnprintf(next, size,
 			"USB Intrrupt Enable Reg:\n"
-			"Sleep Enable: %d" "SOF Received Enable: %d"
+			"Sleep Enable: %d SOF Received Enable: %d "
 			"Reset Enable: %d\n"
-			"System Error Enable: %d"
+			"System Error Enable: %d "
 			"Port Change Dectected Enable: %d\n"
-			"USB Error Intr Enable: %d" "USB Intr Enable: %d\n\n",
+			"USB Error Intr Enable: %d USB Intr Enable: %d\n\n",
 			(tmp_reg & USB_INTR_DEVICE_SUSPEND) ? 1 : 0,
 			(tmp_reg & USB_INTR_SOF_EN) ? 1 : 0,
 			(tmp_reg & USB_INTR_RESET_EN) ? 1 : 0,
@@ -1938,21 +1938,21 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 
 	tmp_reg = fsl_readl(&dr_regs->frindex);
 	t = scnprintf(next, size,
-			"USB Frame Index Reg:" "Frame Number is 0x%x\n\n",
+			"USB Frame Index Reg: Frame Number is 0x%x\n\n",
 			(tmp_reg & USB_FRINDEX_MASKS));
 	size -= t;
 	next += t;
 
 	tmp_reg = fsl_readl(&dr_regs->deviceaddr);
 	t = scnprintf(next, size,
-			"USB Device Address Reg:" "Device Addr is 0x%x\n\n",
+			"USB Device Address Reg: Device Addr is 0x%x\n\n",
 			(tmp_reg & USB_DEVICE_ADDRESS_MASK));
 	size -= t;
 	next += t;
 
 	tmp_reg = fsl_readl(&dr_regs->endpointlistaddr);
 	t = scnprintf(next, size,
-			"USB Endpoint List Address Reg:"
+			"USB Endpoint List Address Reg: "
 			"Device Addr is 0x%x\n\n",
 			(tmp_reg & USB_EP_LIST_ADDRESS_MASK));
 	size -= t;
@@ -1961,11 +1961,12 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 	tmp_reg = fsl_readl(&dr_regs->portsc1);
 	t = scnprintf(next, size,
 		"USB Port Status&Control Reg:\n"
-		"Port Transceiver Type : %s" "Port Speed: %s \n"
-		"PHY Low Power Suspend: %s" "Port Reset: %s"
-		"Port Suspend Mode: %s \n" "Over-current Change: %s"
+		"Port Transceiver Type : %s Port Speed: %s\n"
+		"PHY Low Power Suspend: %s Port Reset: %s "
+		"Port Suspend Mode: %s\n"
+		"Over-current Change: %s "
 		"Port Enable/Disable Change: %s\n"
-		"Port Enabled/Disabled: %s"
+		"Port Enabled/Disabled: %s "
 		"Current Connect Status: %s\n\n", ( {
 			char *s;
 			switch (tmp_reg & PORTSCX_PTS_FSLS) {
@@ -2010,7 +2011,7 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 
 	tmp_reg = fsl_readl(&dr_regs->usbmode);
 	t = scnprintf(next, size,
-			"USB Mode Reg:" "Controller Mode is : %s\n\n", ( {
+			"USB Mode Reg: Controller Mode is: %s\n\n", ( {
 				char *s;
 				switch (tmp_reg & USB_MODE_CTRL_MODE_HOST) {
 				case USB_MODE_CTRL_MODE_IDLE:
@@ -2029,7 +2030,7 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 
 	tmp_reg = fsl_readl(&dr_regs->endptsetupstat);
 	t = scnprintf(next, size,
-			"Endpoint Setup Status Reg:" "SETUP on ep 0x%x\n\n",
+			"Endpoint Setup Status Reg: SETUP on ep 0x%x\n\n",
 			(tmp_reg & EP_SETUP_STATUS_MASK));
 	size -= t;
 	next += t;
@@ -2042,12 +2043,12 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 		next += t;
 	}
 	tmp_reg = fsl_readl(&dr_regs->endpointprime);
-	t = scnprintf(next, size, "EP Prime Reg = [0x%x]\n", tmp_reg);
+	t = scnprintf(next, size, "EP Prime Reg = [0x%x]\n\n", tmp_reg);
 	size -= t;
 	next += t;
 
 	tmp_reg = usb_sys_regs->snoop1;
-	t = scnprintf(next, size, "\nSnoop1 Reg : = [0x%x]\n\n", tmp_reg);
+	t = scnprintf(next, size, "Snoop1 Reg : = [0x%x]\n\n", tmp_reg);
 	size -= t;
 	next += t;
 
@@ -2071,7 +2072,7 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 	} else {
 		list_for_each_entry(req, &ep->queue, queue) {
 			t = scnprintf(next, size,
-				"req %p actual 0x%x length 0x%x  buf %p\n",
+				"req %p actual 0x%x length 0x%x buf %p\n",
 				&req->req, req->req.actual,
 				req->req.length, req->req.buf);
 			size -= t;
@@ -2097,7 +2098,7 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 			} else {
 				list_for_each_entry(req, &ep->queue, queue) {
 					t = scnprintf(next, size,
-						"req %p actual 0x%x length"
+						"req %p actual 0x%x length "
 						"0x%x  buf %p\n",
 						&req->req, req->req.actual,
 						req->req.length, req->req.buf);
-- 
1.5.5.2

