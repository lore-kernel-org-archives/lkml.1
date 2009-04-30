Return-Path: <linux-kernel-owner+w=401wt.eu-S1763220AbZD3Nol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763220AbZD3Nol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762098AbZD3Noc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:44:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51486 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761973AbZD3Nob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:44:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Mark WM8350 mask revision as readable to match silicon
Date: Thu, 30 Apr 2009 14:44:29 +0100
Message-Id: <1241099069-17778-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No impact unless someone has written additional kernel code.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-regmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
index 9a4cc95..97d6aad 100644
--- a/drivers/mfd/wm8350-regmap.c
+++ b/drivers/mfd/wm8350-regmap.c
@@ -3186,7 +3186,7 @@ const struct wm8350_reg_access wm8350_reg_io_map[] = {
 	/*  read    write volatile */
 	{ 0xFFFF, 0xFFFF, 0xFFFF }, /* R0   - Reset/ID */
 	{ 0x7CFF, 0x0C00, 0x7FFF }, /* R1   - ID */
-	{ 0x0000, 0x0000, 0x0000 }, /* R2 */
+	{ 0x007F, 0x0000, 0x0000 }, /* R2   - ROM Mask ID */
 	{ 0xBE3B, 0xBE3B, 0x8000 }, /* R3   - System Control 1 */
 	{ 0xFEF7, 0xFEF7, 0xF800 }, /* R4   - System Control 2 */
 	{ 0x80FF, 0x80FF, 0x8000 }, /* R5   - System Hibernate */
-- 
1.6.2.4

