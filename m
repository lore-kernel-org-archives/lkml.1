Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbYGUEfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbYGUEfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYGUEfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:35:45 -0400
Received: from www.swissdisk.com ([216.66.254.197]:38440 "EHLO
	swissweb.swissdisk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYGUEfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:35:44 -0400
X-Greylist: delayed 2470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2008 00:35:44 EDT
From: Chuck Short <zulcss@ubuntu.com>
Date: Fri, 18 Jan 2008 13:21:16 -0500
Subject: [PATCH 2/7] ata: blacklist FUJITSU MHW2160BH PL
CC: linux-ide@vger.kernel.org
To: linux-kernel@vger.kernel.org
In-Reply-To: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
Message-Id: <E1KKl4I-00068E-Ob@swissweb.swissdisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reference: https://launchpad.net/bugs/175834

CC: linux-ide@vger.kernel.org
Signed-off-by: Chuck Short <zulcss@ubuntu.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Ben Collins <ben.collins@canonical.com>
---
 drivers/ata/libata-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9bef1a8..2664082 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3935,6 +3935,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
+	{ "FUJITSU MHW2160BH PL", "0084001E",   ATA_HORKAGE_NONCQ, },
 
 	/* devices which puke on READ_NATIVE_MAX */
 	{ "HDS724040KLSA80",	"KFAOA20N",	ATA_HORKAGE_BROKEN_HPA, },
-- 
1.5.4.3

