Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbYIALVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYIALVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYIALUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:20:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:34350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941AbYIALUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:20:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,307,1217833200"; 
   d="scan'208";a="331166415"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 0/4 v2] PCI: Linux kernel SR-IOV support
Date: Mon, 1 Sep 2008 19:20:36 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E110177EB6C@pdsmsx414.ccr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/4 v2] PCI: Linux kernel SR-IOV support
Thread-Index: AckMJMHs7liUAZDfRkmZm6h71gkEtQ==
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, "Greg KH" <greg@kroah.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       <xen-devel@lists.xensource.com>
X-OriginalArrivalTime: 01 Sep 2008 11:20:39.0389 (UTC) FILETIME=[C36DF8D0:01C90C24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Following patches add SR-IOV capability support to the Linux kernel. With these patches, people can turn a PCI device with the capability into multiple ones from software perspective.

[PATCH 1/4 v2] PCI: introduce new base functions
[PATCH 2/4 v2] PCI: support ARI capability
[PATCH 3/4 v2] PCI: support SR-IOV capability
[PATCH 4/4 v2] PCI: document the change

Thanks to Randy Dunlap for carefully reviewing the document change.
And also thank Greg KH, Grant Grundler and Jesse Barnes for their comments on the initial version.

---
Single Root I/O Virtualization (SR-IOV) capability defined by PCI-SIG is intended to enable multiple system software to share PCI hardware resources. PCI device that supports this capability can be extended to one Physical Functions plus multiple Virtual Functions. Physical Function, which could be considered as the "real" PCI device, reflects the hardware instance and manages all physical resources. Virtual Functions are associated with a Physical Function and shares physical resources with the Physical Function. Software can control allocation of Virtual Functions via registers encapsulated in the capability structure.

SR-IOV specification can be found at http://www.pcisig.com/members/downloads/specifications/iov/sr-iov1.0_11Sep07.pdf

Devices that support SR-IOV are available from following vendors:
http://download.intel.com/design/network/ProdBrf/320025.pdf
http://www.netxen.com/products/chipsolutions/NX3031.html
http://www.neterion.com/products/x3100.html
