Return-Path: <linux-kernel-owner+w=401wt.eu-S1761926AbZAWQT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761926AbZAWQT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 11:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbZAWQSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 11:18:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59677 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756301AbZAWQSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 11:18:39 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] mfd: Mark WM835x USB_SLV_500MA bit as accessible
Date: Fri, 23 Jan 2009 16:18:34 +0000
Message-Id: <1232727516-5049-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brings the data table into sync with the silicon.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-regmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
index 68887b8..9a4cc95 100644
--- a/drivers/mfd/wm8350-regmap.c
+++ b/drivers/mfd/wm8350-regmap.c
@@ -3188,7 +3188,7 @@ const struct wm8350_reg_access wm8350_reg_io_map[] = {
 	{ 0x7CFF, 0x0C00, 0x7FFF }, /* R1   - ID */
 	{ 0x0000, 0x0000, 0x0000 }, /* R2 */
 	{ 0xBE3B, 0xBE3B, 0x8000 }, /* R3   - System Control 1 */
-	{ 0xFCF7, 0xFCF7, 0xF800 }, /* R4   - System Control 2 */
+	{ 0xFEF7, 0xFEF7, 0xF800 }, /* R4   - System Control 2 */
 	{ 0x80FF, 0x80FF, 0x8000 }, /* R5   - System Hibernate */
 	{ 0xFB0E, 0xFB0E, 0x0000 }, /* R6   - Interface Control */
 	{ 0x0000, 0x0000, 0x0000 }, /* R7 */
-- 
1.5.6.5

