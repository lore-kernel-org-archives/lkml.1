Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYGHWGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYGHWGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYGHWGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:06:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:61404 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbYGHWGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:06:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,326,1212390000"; 
   d="scan'208";a="304319029"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [RESEND NET-NEXT PATCH 00/20] igb update for net-next
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Date: Tue, 08 Jul 2008 15:06:12 -0700
Message-ID: <20080708220046.1518.88457.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2008 22:06:14.0445 (UTC) FILETIME=[D69A35D0:01C8E146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the a resubmit of patches 8-18 from Davem's latest net-next tree.
Patches had to be updated with the changes made from Patrick McHardy's VLAN
patches.

In addition, 2 additional patches have been added to correct a un-used
variable warning and to improve multiqueue AIM support. 

---
Summary:
Alexander Duyck <alexander.h.duyck@intel.com>:
     igb: update ethtool stats to support multiqueue
     igb: add 82576 MAC support
     igb: Add support for quad port WOL and feature flags
     igb: add page recycling support
     igb: add support for in kernel LRO
     net: add netif_napi_del function to allow for removal of napistructs
     igb: update suspend resume
     [new] igb: unused variable warning in igb remove
     [new] igb: Improve multiqueue AIM support

Auke Kok <auke-jan.h.kok@intel.com>:
     igb: reenable CRC stripping in hardware
     igb: Increment driver version

Jeb Cramer <cramerj@intel.com>:
     igb: add DCA support

Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>:
     igb: Introduce multiple TX queues with infrastructure

---
 drivers/net/Kconfig             |    9 
 drivers/net/igb/e1000_82575.c   |  208 +++++++
 drivers/net/igb/e1000_82575.h   |   22 
 drivers/net/igb/e1000_defines.h |   10 
 drivers/net/igb/e1000_hw.h      |    8 
 drivers/net/igb/e1000_mac.c     |    3 
 drivers/net/igb/e1000_mac.h     |    1 
 drivers/net/igb/e1000_regs.h    |    9 
 drivers/net/igb/igb.h           |   53 +
 drivers/net/igb/igb_ethtool.c   |  205 +++++--
 drivers/net/igb/igb_main.c      | 1076 ++++++++++++++++++++++++++++------------
 include/linux/netdevice.h       |   13 
 12 files changed, 1243 insertions(+), 374 deletions(-)

-- 
Cheers,
Jeff
