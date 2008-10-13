Return-Path: <linux-kernel-owner+w=401wt.eu-S1761061AbYJMLgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061AbYJMLgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbYJMLgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:36:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40149 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757214AbYJMLge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:36:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Fix warning in WM8350
Date: Mon, 13 Oct 2008 12:36:32 +0100
Message-Id: <1223897792-32031-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223897792-32031-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081013113509.GA31973@rakim.wolfsonmicro.main>
 <1223897792-32031-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 8554855..35f4557 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1161,7 +1161,6 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 {
 	int ret = -EINVAL;
 	u16 id1, id2, mask, mode;
-	int i;
 
 	/* get WM8350 revision and config mode */
 	wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
-- 
1.5.6.5

