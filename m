Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbYGOPZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbYGOPZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYGOPYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:24:55 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2275 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbYGOPYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:24:54 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, leoli@freescale.com, tanya.jiang@freescale.com,
       gregkh@suse.de, Will Newton <will.newton@gmail.com>
Subject: [PATCH 01/11] fsl_usb2_udc: Make dr_ep_setup function static.
Date: Tue, 15 Jul 2008 16:24:40 +0100
Message-Id: <1216135490-21656-2-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 15 Jul 2008 15:24:52.0730 (UTC) FILETIME=[EDAC5DA0:01C8E68E]
X-SEF-Processed: 6_0_1_111__2008_07_15_16_24_53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Make dr_ep_setup function static as it's never used outside this file.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 1868754..b2a703e 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -315,7 +315,8 @@ static void dr_controller_stop(struct fsl_udc *udc)
 	return;
 }
 
-void dr_ep_setup(unsigned char ep_num, unsigned char dir, unsigned char ep_type)
+static void dr_ep_setup(unsigned char ep_num, unsigned char dir,
+			unsigned char ep_type)
 {
 	unsigned int tmp_epctrl = 0;
 
-- 
1.5.5.2

