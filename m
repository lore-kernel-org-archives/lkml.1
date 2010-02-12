Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab0BLV5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:57:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:36933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab0BLV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:57:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MbO1V+m6vjZSoaJ6+vTNx5ZqRKx354Mdn2TO113UrDRCf9OJKA32RUiMu3UIJ5Miqe
         boAQ6A0N8cSEUZB2bLTIE6NoxXrDj4elB3ojohBwxY1em4Ny6RvxWZi5J8S/QbpnDV//
         MItkDNwzbUJj+VMgzMRrEw13QAjMUSZE4hUTw=
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>,
       Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 2/4] power_supply: bq27x00: remove unused struct fields
Date: Fri, 12 Feb 2010 23:57:02 +0200
Message-Id: <1266011822-31774-1-git-send-email-notasas@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are probably leftover from old TI code.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/bq27x00_battery.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 537915c..3ae3e08 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -49,10 +49,6 @@ struct bq27x00_access_methods {
 struct bq27x00_device_info {
 	struct device 		*dev;
 	int			id;
-	int			voltage_uV;
-	int			current_uA;
-	int			temp_C;
-	int			charge_rsoc;
 	struct bq27x00_access_methods	*bus;
 	struct power_supply	bat;
 
-- 
1.6.3.3

