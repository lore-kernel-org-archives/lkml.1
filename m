Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYEESX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYEESX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbYEESXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:23:13 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44445 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbYEESW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:22:59 -0400
Date: Mon, 5 May 2008 21:21:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make {pciehp,shpchp}_slot_with_bus static
Message-ID: <20080505182151.GE17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global {pciehp,shpchp}_slot_with_bus 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/pci/hotplug/pciehp_core.c |    2 +-
 drivers/pci/hotplug/shpchp_core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

41d6f1dab962d7363216746c042a4a81951e5116 diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 43d8ddb..60990be 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -41,7 +41,7 @@ int pciehp_debug;
 int pciehp_poll_mode;
 int pciehp_poll_time;
 int pciehp_force;
-int pciehp_slot_with_bus;
+static int pciehp_slot_with_bus;
 struct workqueue_struct *pciehp_wq;
 
 #define DRIVER_VERSION	"0.4"
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index 1648076..5132314 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -39,7 +39,7 @@
 int shpchp_debug;
 int shpchp_poll_mode;
 int shpchp_poll_time;
-int shpchp_slot_with_bus;
+static int shpchp_slot_with_bus;
 struct workqueue_struct *shpchp_wq;
 
 #define DRIVER_VERSION	"0.4"

