Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbZCXMLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbZCXMLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZCXMLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:11:35 -0400
Received: from smtp.nokia.com ([192.100.122.233]:58348 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbZCXMLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:11:35 -0400
Message-ID: <49C8CE1B.7000802@nokia.com>
Date: Tue, 24 Mar 2009 14:12:11 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: "Lavinen Jarkko (Nokia-M/Helsinki)" <jarkko.lavinen@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: MMC: Accept EXT_CSD rev 1.3 assuming it is backwards compatible with
 1.2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2009 12:11:24.0445 (UTC) FILETIME=[A6B1A4D0:01C9AC79]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a939998e34cbc263317d51b21ab52c8d5863a913 Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Thu, 27 Nov 2008 14:30:32 +0200
Subject: MMC: Accept EXT_CSD rev 1.3 assuming it is backwards compatible with 1.2

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 drivers/mmc/core/mmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index fdd7c76..3f5b089 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -208,7 +208,7 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 	}
 
 	ext_csd_struct = ext_csd[EXT_CSD_REV];
-	if (ext_csd_struct > 2) {
+	if (ext_csd_struct > 3) {
 		printk(KERN_ERR "%s: unrecognised EXT_CSD structure "
 			"version %d\n", mmc_hostname(card->host),
 			ext_csd_struct);
-- 
1.5.4.3
