Return-Path: <linux-kernel-owner+w=401wt.eu-S1946639AbXBIQqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946639AbXBIQqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946653AbXBIQjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51702 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946639AbXBIQjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:39:11 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] misc duplicate field initializers
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYmE-0006oZ-Mt@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:39:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/common/ir-keymaps.c |    1 -
 drivers/net/mv643xx_eth.c         |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/ir-keymaps.c b/drivers/media/common/ir-keymaps.c
index f51e02f..0e948a5 100644
--- a/drivers/media/common/ir-keymaps.c
+++ b/drivers/media/common/ir-keymaps.c
@@ -698,7 +698,6 @@ IR_KEYTAB_TYPE ir_codes_pinnacle_grey[IR_KEYTAB_SIZE] = {
 	[ 0x29 ] = KEY_TEXT,
 	[ 0x2a ] = KEY_MEDIA,
 	[ 0x18 ] = KEY_EPG,
-	[ 0x27 ] = KEY_RECORD,
 };
 
 EXPORT_SYMBOL_GPL(ir_codes_pinnacle_grey);
diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index b3bf864..d98e53e 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -2780,7 +2780,6 @@ static const struct ethtool_ops mv643xx_ethtool_ops = {
 	.get_link               = mv643xx_eth_get_link,
 	.get_sg			= ethtool_op_get_sg,
 	.set_sg			= ethtool_op_set_sg,
-	.get_strings            = mv643xx_get_strings,
 	.get_stats_count        = mv643xx_get_stats_count,
 	.get_ethtool_stats      = mv643xx_get_ethtool_stats,
 	.get_strings            = mv643xx_get_strings,
-- 
1.5.0-rc2.GIT


