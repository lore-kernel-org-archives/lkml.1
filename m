Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZCWPFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZCWPFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757851AbZCWPE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:04:29 -0400
Received: from mx1.emlix.com ([193.175.82.87]:46584 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600AbZCWPE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:04:28 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 5/5] xtensa: enable at24 driver in s6105_defconfig
Date: Mon, 23 Mar 2009 16:05:18 +0100
Message-Id: <1237820718-30607-5-git-send-email-dg@emlix.com>
In-Reply-To: <1237820718-30607-1-git-send-email-dg@emlix.com>
References: <1237820718-30607-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/configs/s6105_defconfig |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index a9a0de9..e398710 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -251,7 +251,17 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
 # CONFIG_BLK_DEV_HD is not set
-# CONFIG_MISC_DEVICES is not set
+CONFIG_MISC_DEVICES=y
+# CONFIG_ICS932S401 is not set
+# CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_C2PORT is not set
+
+#
+# EEPROM support
+#
+CONFIG_EEPROM_AT24=y
+# CONFIG_EEPROM_LEGACY is not set
+# CONFIG_EEPROM_93CX6 is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
-- 
1.6.2.107.ge47ee

