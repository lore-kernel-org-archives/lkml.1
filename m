Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbYA3UKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbYA3UKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759741AbYA3UCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:02:12 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40712 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759584AbYA3UCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:02:08 -0500
Date: Wed, 30 Jan 2008 22:02:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Joe Perches <joe@perches.com>, Auke Kok <auke-jan.h.kok@intel.com>,
       Jeff Garzik <jeff@garzik.org>, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, john.ronciak@intel.com
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] e1000e/ethtool.c: make a function static
Message-ID: <20080130200243.GY29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global reg_pattern_test_array() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ed72e457f06311390d9a9e51a00c904939466aff 
diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
index 6d9c27f..a2034cf 100644
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -690,8 +690,8 @@ err_setup:
 	return err;
 }
 
-bool reg_pattern_test_array(struct e1000_adapter *adapter, u64 *data,
-			    int reg, int offset, u32 mask, u32 write)
+static bool reg_pattern_test_array(struct e1000_adapter *adapter, u64 *data,
+				   int reg, int offset, u32 mask, u32 write)
 {
 	int i;
 	u32 read;

