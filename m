Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZAERLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZAERLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZAERLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:11:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36505 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbZAERL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:11:29 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: video4linux-list@redhat.com
Cc: linux-kernel@vger.kernel.org, Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] remove duplicated defines in pxa_camera.c
Date: Mon,  5 Jan 2009 18:11:27 +0100
Message-Id: <1231175487-3293-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defines for CIR Registers have been moved to pxa_camera.h. So remove them from
pxa_camera.c to avoid compiler warnings.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/media/video/pxa_camera.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index cb8c5e1..4eda750 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -44,19 +44,6 @@
 #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
 #define PXA_CAM_DRV_NAME "pxa27x-camera"
 
-/* Camera Interface */
-#define CICR0		0x0000
-#define CICR1		0x0004
-#define CICR2		0x0008
-#define CICR3		0x000C
-#define CICR4		0x0010
-#define CISR		0x0014
-#define CIFR		0x0018
-#define CITOR		0x001C
-#define CIBR0		0x0028
-#define CIBR1		0x0030
-#define CIBR2		0x0038
-
 #define CICR0_DMAEN	(1 << 31)	/* DMA request enable */
 #define CICR0_PAR_EN	(1 << 30)	/* Parity enable */
 #define CICR0_SL_CAP_EN	(1 << 29)	/* Capture enable for slave mode */
-- 
1.5.6.5

