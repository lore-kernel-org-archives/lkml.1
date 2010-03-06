Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab0CFXxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 18:53:09 -0500
Received: from mail-bw0-f222.google.com ([209.85.218.222]:53175 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0CFXxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 18:53:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bA/xiKMVG0lyZJV3XOd3mqe0qVqOanGILqwf6hhum3QieSMjFdqt7Sj0ezElMgxa6l
         zZxmwybqpg7gb0OBu///XrEBNqsCrIHRVK7nJri6qSq5sBmfugmxnwMf+wV5R6pUOROF
         WxHltWwXtQwiysEppH0iCuGW/vRLdL9sNLxHA=
From: Niels Egberts <niels.egberts@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Niels Egberts <niels.egberts@gmail.com>
Subject: [PATCH] Power: fix brace coding style issue in pda_power.c This is a patch to the pda_power.c file that fixes up a brace warning found by the checkpatch.pl tool Signed-off-by: Niels Egberts <niels.egberts@gmail.com>
Date: Sun,  7 Mar 2010 00:52:56 +0100
Message-Id: <1267919576-15566-1-git-send-email-niels.egberts@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/power/pda_power.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index a232de6..9d7f091 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -305,9 +305,9 @@ static int pda_power_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_USB_OTG_UTILS
 	transceiver = otg_get_transceiver();
-	if (transceiver && !pdata->is_usb_online) {
+	if (transceiver && !pdata->is_usb_online)
 		pdata->is_usb_online = otg_is_usb_online;
-	}
+
 #endif
 
 	if (pdata->is_usb_online) {
-- 
1.7.0

