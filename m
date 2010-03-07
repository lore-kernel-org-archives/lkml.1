Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0CGHl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 02:41:58 -0500
Received: from iron1.emtelworld.com ([196.192.81.95]:57979 "EHLO
	iron1.emtelworld.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab0CGHl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 02:41:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMDlkkvEwFEi/2dsb2JhbACbSXOpa4xShHgEgxI
From: Michael Tate <michael.tate@wanadoo.fr>
To: gregkh@suse.de, alan@linux.intel.com, o.hartmann@telovital.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Michael Tate <michael.tate@wanadoo.fr>
Subject: [PATCH 4/5] staging: et131x: et1310_eeprom: Fix code style issues from checkpatch.pl
Date: Sun,  7 Mar 2010 11:41:36 +0400
Message-Id: <1267947696-4528-1-git-send-email-michael.tate@wanadoo.fr>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes 1 error and 2 warnings reported by checkpatch.pl
Use of spaces replaced by tabs and one comment block edited to
remain within the 80 char guidelines.

Signed-off-by: Michael Tate <michael.tate@wanadoo.fr>
---
 drivers/staging/et131x/et1310_eeprom.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/et131x/et1310_eeprom.c b/drivers/staging/et131x/et1310_eeprom.c
index bcca1f8..9ac5a4f 100644
--- a/drivers/staging/et131x/et1310_eeprom.c
+++ b/drivers/staging/et131x/et1310_eeprom.c
@@ -278,7 +278,7 @@ static int eeprom_read(struct et131x_adapter *etdev, u32 addr, u8 *pdata)
 	err = eeprom_wait_ready(pdev, NULL);
 	if (err)
 		return err;
- 	/*
+	/*
 	 * Write to the LBCIF Control Register:  bit 7=1, bit 6=0, bit 3=0,
 	 * and bits 1:0 both =0.  Bit 5 should be set according to the type
 	 * of EEPROM being accessed (1=two byte addressing, 0=one byte
@@ -359,9 +359,9 @@ int et131x_init_eeprom(struct et131x_adapter *etdev)
 
 			/* This error could mean that there was an error
 			 * reading the eeprom or that the eeprom doesn't exist.
-			 * We will treat each case the same and not try to gather
-			 * additional information that normally would come from the
-			 * eeprom, like MAC Address
+			 * We will treat each case the same and not try to
+			 * gather additional information that normally would
+			 * come from the eeprom, like MAC Address
 			 */
 			etdev->has_eeprom = 0;
 			return -EIO;
-- 
1.6.3.3

