Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbZKER5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbZKER5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757981AbZKER5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:57:06 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:45221 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbZKERzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:55:42 -0500
Message-Id: <20091105152702.035396736@linux-mips.org>
User-Agent: quilt/0.47-1
Date: Thu, 05 Nov 2009 16:25:57 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       netdev@vger.kernel.org
Subject: [PATCH 1/6] Staging: Octeon: Fix compile error in drivers/staging/octeon/ethernet-mdio.c
References: <20091105152555.227009519@linux-mips.org>
Content-Disposition: inline; filename=0002.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: netdev@vger.kernel.org
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 drivers/staging/octeon/ethernet-mdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: upstream-linus/drivers/staging/octeon/ethernet-mdio.c
===================================================================
--- upstream-linus.orig/drivers/staging/octeon/ethernet-mdio.c
+++ upstream-linus/drivers/staging/octeon/ethernet-mdio.c
@@ -170,7 +170,7 @@ static u32 cvm_oct_get_link(struct net_d
 	return ret;
 }
 
-struct const ethtool_ops cvm_oct_ethtool_ops = {
+const struct ethtool_ops cvm_oct_ethtool_ops = {
 	.get_drvinfo = cvm_oct_get_drvinfo,
 	.get_settings = cvm_oct_get_settings,
 	.set_settings = cvm_oct_set_settings,


