Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbZCTD1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbZCTD1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbZCTDY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:24:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:53819 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbZCTDYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:24:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="396042891"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v12 7/8] PCI: document SR-IOV sysfs entries
Date: Fri, 20 Mar 2009 11:25:17 +0800
Message-Id: <1237519518-24048-8-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
References: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Randy Dunlap <rdunlap@xenotime.net>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-pci |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index e638e15..36edf03 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -52,3 +52,30 @@ Description:
 		that some devices may have malformatted data.  If the
 		underlying VPD has a writable section then the
 		corresponding section of this file will be writable.
+
+What:		/sys/bus/pci/devices/.../virtfnN
+Date:		March 2009
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This symbolic link appears when hardware supports the SR-IOV
+		capability and the Physical Function driver has enabled it.
+		The symbolic link points to the PCI device sysfs entry of the
+		Virtual Function whose index is N (0...MaxVFs-1).
+
+What:		/sys/bus/pci/devices/.../dep_link
+Date:		March 2009
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This symbolic link appears when hardware supports the SR-IOV
+		capability and the Physical Function driver has enabled it,
+		and this device has vendor specific dependencies with others.
+		The symbolic link points to the PCI device sysfs entry of
+		Physical Function this device depends on.
+
+What:		/sys/bus/pci/devices/.../physfn
+Date:		March 2009
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This symbolic link appears when a device is a Virtual Function.
+		The symbolic link points to the PCI device sysfs entry of the
+		Physical Function this device associates with.
-- 
1.5.6.4

