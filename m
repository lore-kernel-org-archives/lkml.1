Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229Ab0AZWsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab0AZWsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788Ab0AZWs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:48:29 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:41825 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0AZWs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:48:29 -0500
X-Greylist: delayed 2246 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 17:48:28 EST
X-Originating-Ip: 216.16.235.2
Date: Tue, 26 Jan 2010 17:10:56 -0500
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] ide: fixed section mismatch warning in cmd640.c
Message-ID: <20100126221056.GA19192@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Frey <cdfrey@foursquare.net>
---
 drivers/ide/cmd640.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
index 1a32d62..cb11938 100644
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -605,7 +605,7 @@ static void cmd640_set_pio_mode(ide_drive_t *drive, const u8 pio)
 }
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
-static void cmd640_init_dev(ide_drive_t *drive)
+static void __init cmd640_init_dev(ide_drive_t *drive)
 {
 	unsigned int i = drive->hwif->channel * 2 + (drive->dn & 1);
 
-- 
1.6.2.5

