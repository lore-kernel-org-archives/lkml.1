Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYJVJ6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYJVJ6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYJVJ6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:58:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45004 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751923AbYJVJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:58:38 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Don't mark WM8350 security register as volatile
Date: Wed, 22 Oct 2008 10:58:35 +0100
Message-Id: <1224669516-16538-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to read this back from the chip each time.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-regmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
index 974678d..aaf394a 100644
--- a/drivers/mfd/wm8350-regmap.c
+++ b/drivers/mfd/wm8350-regmap.c
@@ -1307,7 +1307,7 @@ const struct wm8350_reg_access wm8350_reg_io_map[] = {
 	{ 0xFF3F, 0xE03F, 0x0000 }, /* R216 - Main Bandgap Control */
 	{ 0xEF2F, 0xE02F, 0x0000 }, /* R217 - OSC Control */
 	{ 0xF3FF, 0xB3FF, 0xc000 }, /* R218 - RTC Tick Control */
-	{ 0xFFFF, 0xFFFF, 0xFFFF }, /* R219 */
+	{ 0xFFFF, 0xFFFF, 0x0000 }, /* R219 - Security */
 	{ 0x09FF, 0x01FF, 0x0000 }, /* R220 - RAM BIST 1 */
 	{ 0x0000, 0x0000, 0x0000 }, /* R221 */
 	{ 0xFFFF, 0xFFFF, 0xFFFF }, /* R222 */
-- 
1.5.6.5

