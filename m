Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZKWTyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZKWTyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756449AbZKWTyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:54:37 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:42516 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411AbZKWTyg (ORCPT
	<rfc822;groupwise-GHaskins@novell.com:0:0>);
	Mon, 23 Nov 2009 14:54:36 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [-next PATCH 0/4] Minor fixes for alacrityvm/linux-next branch
To: linux-next@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net
Date: Mon, 23 Nov 2009 14:54:28 -0500
Message-ID: <20091123195136.8184.68042.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following are trivial fixes for the drivers in alacrityvm/linux-next

Patches 1-3 were necessary to enable the building of these drivers
as a KMP package for older distribution kernels. Patch 4/4 is just
a cleanup discovered during testing.

Kind Regards,
-Greg

---

Gregory Haskins (4):
      vbus: fix pcibridge busmaster support
      vbus: add autoprobe capability to guest
      venet: add missing ethtool include
      vbus: make library code properly declared as GPL


 drivers/net/vbus-enet.c     |    3 +++
 drivers/vbus/bus-proxy.c    |   33 ++++++++++++++++++++++++++++++++-
 drivers/vbus/pci-bridge.c   |    2 ++
 include/linux/vbus_driver.h |    2 ++
 lib/ioq.c                   |    4 ++++
 lib/shm_signal.c            |    4 ++++
 6 files changed, 47 insertions(+), 1 deletions(-)

-- 
Signature
