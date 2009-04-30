Return-Path: <linux-kernel-owner+w=401wt.eu-S1763571AbZD3NuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763571AbZD3NuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763458AbZD3Nsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:48:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55929 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763454AbZD3Nsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:48:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.30 1/2] mfd: Correct readability of WM8350 register 227
Date: Thu, 30 Apr 2009 14:48:35 +0100
Message-Id: <1241099316-17948-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes the USB current limit status override which is used in the
power management driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-regmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
index 97d6aad..7ccc1ea 100644
--- a/drivers/mfd/wm8350-regmap.c
+++ b/drivers/mfd/wm8350-regmap.c
@@ -3411,7 +3411,7 @@ const struct wm8350_reg_access wm8350_reg_io_map[] = {
 	{ 0x0000, 0x0000, 0x0000 }, /* R224 */
 	{ 0x8F3F, 0x0000, 0xFFFF }, /* R225 - DCDC/LDO status */
 	{ 0x0000, 0x0000, 0xFFFF }, /* R226 - Charger status */
-	{ 0x0000, 0x0000, 0xFFFF }, /* R227 */
+	{ 0x34FE, 0x0000, 0xFFFF }, /* R227 */
 	{ 0x0000, 0x0000, 0x0000 }, /* R228 */
 	{ 0x0000, 0x0000, 0x0000 }, /* R229 */
 	{ 0xFFFF, 0x1FFF, 0xFFFF }, /* R230 - GPIO Pin Status */
-- 
1.6.2.4

