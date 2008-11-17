Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbYKQSlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbYKQSlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYKQSk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:40:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:22260 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751327AbYKQSk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:40:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,619,1220252400"; 
   d="scan'208";a="361153596"
From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 0/3] net: New flags for Fibre Channel over Ethernet (FCoE)
	(Resubmit)
To: davem@davemloft.net
Cc: jeff@garzik.org, linux-netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 17 Nov 2008 10:30:16 -0800
Message-ID: <20081117182659.15776.58181.stgit@zychongqing.jf.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
These are the patches adding flags for Fiber Channel over Ethernet (FCoE) that
have been updated to the current tip of net-next.git. The original submission
can be found by the following thread: 
http://marc.info/?l=linux-netdev&m=122228979113312&w=2

Please consider inclusion of these flags.

Many thanks.

yi

---

Chris Leech (2):
      net: define feature flags for FCoE offloads
      net: reclaim 8 upper bits of the netdev->features from GSO

Yi Zou (1):
      net: add ETH_P_FCOE for Fibre Channel over Ethernet (FCoE)


 drivers/net/xen-netfront.c |    2 +-
 include/linux/if_ether.h   |    1 +
 include/linux/netdevice.h  |    5 ++++-
 include/linux/skbuff.h     |    2 ++
 4 files changed, 8 insertions(+), 2 deletions(-)

-- 
Signature: Yi Zou <yi.zou@intel.com>
