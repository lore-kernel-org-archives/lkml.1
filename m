Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbZAERKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbZAERKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZAERJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:09:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44413 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbZAERJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:09:52 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: video4linux-list@redhat.com
Cc: linux-kernel@vger.kernel.org, Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] include mach specific dma.h in pxa_camera.c 
Date: Mon,  5 Jan 2009 18:09:49 +0100
Message-Id: <1231175389-3199-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pxa_camera.c uses structs defined in mach specific dma.h. Since mach/dma.h no
longer included by asm/dma.h in arm, compiling this file will fail. We add
the include manualy to fix this.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/media/video/pxa_camera.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 9d33de2..cb8c5e1 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -35,6 +35,7 @@
 #include <linux/videodev2.h>
 
 #include <asm/dma.h>
+#include <mach/dma.h>
 #include <mach/pxa-regs.h>
 #include <mach/camera.h>
 
-- 
1.5.6.5

