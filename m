Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbYJUMuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbYJUMuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYJUMtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:49:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:20878 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbYJUMta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:49:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,457,1220252400"; 
   d="scan'208";a="453868893"
Date: Tue, 21 Oct 2008 19:54:29 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 15/15 v5] PCI: document the new PCI boot parameters
Message-ID: <20081021115429.GP3185@yzhao12-linux.sh.intel.com>
References: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete document for the new PCI boot parameters.

---
 Documentation/kernel-parameters.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 53ba7c7..5482ae0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1677,6 +1677,16 @@ and is between 256 and 4096 characters. It is defined in the file
 		cbmemsize=nn[KMG]	The fixed amount of bus space which is
 				reserved for the CardBus bridge's memory
 				window. The default value is 64 megabytes.
+		assign-mmio=[dddd:]bb	[X86] reassign memory resources of all
+				devices under bus [dddd:]bb (dddd is the domain
+				number and bb is the bus number).
+		assign-pio=[dddd:]bb	[X86] reassign io port resources of all
+				devices under bus [dddd:]bb (dddd is the domain
+				number and bb is the bus number).
+		align-mmio=[dddd:]bb:dd.f  [X86] relocate memory resources of a
+				device with minimum PAGE_SIZE alignment (dddd
+				is the domain number and bb, dd and f is the
+				bus, device and function number).
 
 	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
 			Management.
-- 
1.5.6.4

