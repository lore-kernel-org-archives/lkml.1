Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbYKUTl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbYKUTl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbYKUTkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:40:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:32658 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758148AbYKUTkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:40:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,645,1220252400"; 
   d="scan'208";a="465875089"
Date: Sat, 22 Nov 2008 02:43:59 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "achiang@hp.com" <achiang@hp.com>,
       "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "horms@verge.net.au" <horms@verge.net.au>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 12/13 v7] PCI: document the SR-IOV sysfs entries
Message-ID: <20081121184359.GM7810@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the SR-IOV sysfs entries.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 Documentation/ABI/testing/sysfs-bus-pci |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index ceddcff..d66d63d 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -9,3 +9,29 @@ Description:
 		that some devices may have malformatted data.  If the
 		underlying VPD has a writable section then the
 		corresponding section of this file will be writable.
+
+What:		/sys/bus/pci/devices/.../iov/total_virtfn
+Date:		November 2008
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This file appears when a device has the SR-IOV capability
+		and the device driver (PF driver) support this operation.
+		It holds the number of total Virtual Functions (read-only).
+
+What:		/sys/bus/pci/devices/.../iov/initial_virtfn
+Date:		November 2008
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This file appears when a device has the SR-IOV capability
+		and the device driver (PF driver) support this operation.
+		It holds the number of initial Virtual Functions (read-only).
+
+What:		/sys/bus/pci/devices/.../iov/nr_virtfn
+Date:		November 2008
+Contact:	Yu Zhao <yu.zhao@intel.com>
+Description:
+		This file appears when a device has the SR-IOV capability
+		and the device driver (PF driver) support this operation.
+		It holds the number of available Virtual Functions, and
+		could be written (0 ~ InitialVFs) to change the number of
+		the Virtual Functions.
-- 
1.5.6.4

