Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbYGHWO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbYGHWO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYGHWOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:14:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:54492 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbYGHWOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:14:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,326,1212390000"; 
   d="scan'208";a="304322995"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [NET-NEXT PATCH 19/20] [cosmetic] igb: unused variable warning in igb
	remove
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Alexander Duyck <alexander.h.duyck@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 08 Jul 2008 15:14:04 -0700
Message-ID: <20080708221343.1518.65778.stgit@localhost.localdomain>
In-Reply-To: <20080708220046.1518.88457.stgit@localhost.localdomain>
References: <20080708220046.1518.88457.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2008 22:14:04.0779 (UTC) FILETIME=[EEF17BB0:01C8E147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>

Wrap hw variable declaration in DCA flags to prevent unused variable
warning during compilation.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 drivers/net/igb/igb_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 00e2e8d..2a5303c 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -1360,7 +1360,9 @@ static void __devexit igb_remove(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
+#ifdef CONFIG_DCA
 	struct e1000_hw *hw = &adapter->hw;
+#endif
 
 	/* flush_scheduled work may reschedule our watchdog task, so
 	 * explicitly disable watchdog tasks from being rescheduled  */

