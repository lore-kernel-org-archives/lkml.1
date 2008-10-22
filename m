Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbYJVJox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbYJVJox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYJVJlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:41:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:47879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298AbYJVJlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:41:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,463,1220252400"; 
   d="scan'208";a="351088229"
Date: Wed, 22 Oct 2008 16:45:15 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 15/16 v6] PCI: document the SR-IOV sysfs entries
Message-ID: <20081022084515.GO3773@yzhao12-linux.sh.intel.com>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the SR-IOV sysfs entries.

Cc: Alex Chiang <achiang@hp.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 Documentation/ABI/testing/sysfs-bus-pci |   33 +++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index ceddcff..41cce8f 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -9,3 +9,36 @@ Description:
 		that some devices may have malformatted data.  If the
 		underlying VPD has a writable section then the
 		corresponding section of this file will be writable.
+
+What:		/sys/bus/pci/devices/.../iov/enable
+Date:		October 2008
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This file appears when a device has the SR-IOV capability.
+		It holds the status of the capability, and could be written
+		(0/1) to disable and enable the capability if the PF driver
+		supports this operation.
+
+What:		/sys/bus/pci/devices/.../iov/initialvfs
+Date:		October 2008
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This file appears when a device has the SR-IOV capability.
+		It holds the number of initial Virtual Functions (read-only).
+
+What:		/sys/bus/pci/devices/.../iov/totalvfs
+Date:		October 2008
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This file appears when a device has the SR-IOV capability.
+		It holds the number of total Virtual Functions (read-only).
+
+
+What:		/sys/bus/pci/devices/.../iov/numvfs
+Date:		October 2008
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This file appears when a device has the SR-IOV capability.
+		It holds the number of available Virtual Functions, and
+		could be written (1 ~ InitialVFs) to change the number if
+		the PF driver supports this operation.
-- 
1.5.6.4

