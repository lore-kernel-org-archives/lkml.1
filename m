Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYHLOkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYHLOkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYHLOjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:39:24 -0400
Received: from multi.imgtec.com ([194.200.65.239]:46465 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbYHLOjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:39:21 -0400
From: Will Newton <will.newton@imgtec.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       leoli@freescale.com, Will Newton <will.newton@imgtec.com>
Subject: [PATCH 01/11] fsl_usb2_udc: Make dr_ep_setup function static.
Date: Tue, 12 Aug 2008 15:39:07 +0100
Message-Id: <1218551957-17091-2-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1218551957-17091-1-git-send-email-will.newton@imgtec.com>
References: <1218551957-17091-1-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 12 Aug 2008 14:39:17.0790 (UTC) FILETIME=[3316A3E0:01C8FC89]
X-SEF-Processed: 6_0_1_111__2008_08_12_15_39_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make dr_ep_setup function static as it's never used outside this file.

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Li Yang <leoli@freescale.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 1cfccf1..6a927da 100644
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

