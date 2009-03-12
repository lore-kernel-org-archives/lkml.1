Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZCLKRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZCLKRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZCLKRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:17:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47083 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751749AbZCLKRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:17:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Mark WM8350 mask revision as readable to match silicon
Date: Thu, 12 Mar 2009 10:17:16 +0000
Message-Id: <1236853036-4438-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2
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
1.6.2

