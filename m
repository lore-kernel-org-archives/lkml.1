Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZBQPps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZBQPps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZBQPpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:45:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57541 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751123AbZBQPpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:45:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add support for WM8351 revision B
Date: Tue, 17 Feb 2009 15:45:31 +0000
Message-Id: <1234885531-5497-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No software visible difference from revision A.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index c384cd2..a285cc0 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1386,6 +1386,11 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 			wm8350->power.rev_g_coeff = 1;
 			break;
 
+		case 1:
+			dev_info(wm8350->dev, "WM8351 Rev B\n");
+			wm8350->power.rev_g_coeff = 1;
+			break;
+
 		default:
 			dev_err(wm8350->dev, "Unknown WM8351 CHIP_REV\n");
 			ret = -ENODEV;
-- 
1.6.1.3

