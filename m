Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYA3UH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYA3UH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759823AbYA3UCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:02:15 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37600 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759713AbYA3UCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:02:11 -0500
Date: Wed, 30 Jan 2008 22:02:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Auke Kok <auke-jan.h.kok@intel.com>, Jeff Garzik <jeff@garzik.org>,
       jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com,
       john.ronciak@intel.com
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] make e1000_dump_eeprom() static
Message-ID: <20080130200245.GZ29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global e1000_dump_eeprom() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b5fd924a1388d4aaa94cf05e42e317c2b1fb5748 
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 7f5b2ae..8a6645b 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -820,7 +820,7 @@ e1000_reset(struct e1000_adapter *adapter)
 /**
  *  Dump the eeprom for users having checksum issues
  **/
-void e1000_dump_eeprom(struct e1000_adapter *adapter)
+static void e1000_dump_eeprom(struct e1000_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	struct ethtool_eeprom eeprom;

