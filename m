Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZBQDbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZBQDbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 22:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbZBQD3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 22:29:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:17603 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbZBQD31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 22:29:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,220,1233561600"; 
   d="scan'208";a="111302144"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v9 6/7] PCI: document SR-IOV sysfs entries
Date: Mon, 16 Feb 2009 21:28:39 +0800
Message-Id: <1234790920-1810-7-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234790920-1810-1-git-send-email-yu.zhao@intel.com>
References: <1234790920-1810-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-pci |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index ceddcff..84dc100 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -9,3 +9,30 @@ Description:
 		that some devices may have malformatted data.  If the
 		underlying VPD has a writable section then the
 		corresponding section of this file will be writable.
+
+What:		/sys/bus/pci/devices/.../virtfn/N
+Date:		February 2009
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This symbol link appears when hardware supports SR-IOV
+		capability and Physical Function driver has enabled it.
+		The symbol link points to the PCI device sysfs entry of
+		Virtual Function whose index is N (0...MaxVFs-1).
+
+What:		/sys/bus/pci/devices/.../virtfn/dep_link
+Date:		February 2009
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This symbol link appears when hardware supports SR-IOV
+		capability and Physical Function driver has enabled it,
+		and this device has vendor specific dependencies with
+		others. The symbol link points to the PCI device sysfs
+		entry of Physical Function this device depends on.
+
+What:		/sys/bus/pci/devices/.../physfn
+Date:		February 2009
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This symbol link appears when a device is Virtual Function.
+		The symbol link points to the PCI device sysfs entry of
+		Physical Function this device associates with.
-- 
1.5.6.4

