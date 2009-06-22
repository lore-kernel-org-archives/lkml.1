Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbZFVNi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbZFVNi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZFVNiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:38:19 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50737 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZFVNiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:38:18 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Pavel Machek <pavel@ucw.cz>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] lis3: fix typo
Date: Mon, 22 Jun 2009 15:38:05 +0200
Message-Id: <1245677888-16634-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bit 0x80 in CTRL_REG3 is an ACTIVE_LOW rather than an ACTIVE_HIGH
function, I got that wrong during my last change.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/lis3lv02d.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
index ad651f4..113778b 100644
--- a/include/linux/lis3lv02d.h
+++ b/include/linux/lis3lv02d.h
@@ -32,7 +32,7 @@ struct lis3lv02d_platform_data {
 #define LIS3_IRQ2_DATA_READY	(4 << 3)
 #define LIS3_IRQ2_CLICK		(7 << 3)
 #define LIS3_IRQ_OPEN_DRAIN	(1 << 6)
-#define LIS3_IRQ_ACTIVE_HIGH	(1 << 7)
+#define LIS3_IRQ_ACTIVE_LOW	(1 << 7)
 	unsigned char irq_cfg;
 };
 
-- 
1.6.3.1

