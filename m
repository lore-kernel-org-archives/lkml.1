Return-Path: <linux-kernel-owner+w=401wt.eu-S1763460AbXHVJIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763460AbXHVJIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758839AbXHVIxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:45 -0400
Received: from 1wt.eu ([62.212.114.60]:2156 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758765AbXHVIxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:43 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084041.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:36 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Tejun Heo <htejun@gmail.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jeff Garzik <jeff@garzik.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 52/58] ata_piix: update map 10b for ich8m
Content-Disposition: inline; filename=0052-ata_piix-update-map-10b-for-ich8m.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix map entry 10b for ich8.  It's [P0 P2 IDE IDE] like ich6 / ich6m.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/ata/ata_piix.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 57c0db3..0c646dc 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -431,7 +431,7 @@ static const struct piix_map_db ich8_map_db = {
 		/* PM   PS   SM   SS       MAP */
 		{  P0,  P2,  P1,  P3 }, /* 00b (hardwired when in AHCI) */
 		{  RV,  RV,  RV,  RV },
-		{  IDE,  IDE,  NA,  NA }, /* 10b (IDE mode) */
+		{  P0,  P2, IDE, IDE }, /* 10b (IDE mode) */
 		{  RV,  RV,  RV,  RV },
 	},
 };
-- 
1.5.2.5

-- 
