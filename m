Return-Path: <linux-kernel-owner+w=401wt.eu-S1752271AbZDMNFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbZDMNFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 09:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZDMNFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 09:05:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48587 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751886AbZDMNFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 09:05:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.30] mfd: Correct readability of WM8350 register 227
Date: Mon, 13 Apr 2009 14:05:02 +0100
Message-Id: <1239627902-25179-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2.2
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
index 9a4cc95..19fd8b7 100644
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
1.6.2.2

