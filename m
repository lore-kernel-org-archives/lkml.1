Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbZIPANY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbZIPANY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 20:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZIPANU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 20:13:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:50012 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbZIPANT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 20:13:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,393,1249282800"; 
   d="scan'208";a="550917022"
From: "Kay, Allen M" <allen.m.kay@intel.com>
To: Daniel Walker <dwalker@fifo99.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Date: Tue, 15 Sep 2009 17:13:14 -0700
Subject: RE: [PATCH] enabling ACS P2P upstream forwarding
Thread-Topic: [PATCH] enabling ACS P2P upstream forwarding
Thread-Index: Aco2Yjy1tYPypA/RQEuwZIV2HE0u3gAACJgw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E05DC27E@orsmsx505.amr.corp.intel.com>
References: <57C9024A16AD2D4C97DC78E552063EA3E05DC218@orsmsx505.amr.corp.intel.com>
 <1253059937.11643.527.camel@desktop>
In-Reply-To: <1253059937.11643.527.camel@desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are you able to look at the file in the attachment?

-----Original Message-----
From: Daniel Walker [mailto:dwalker@fifo99.com] 
Sent: Tuesday, September 15, 2009 5:12 PM
To: Kay, Allen M
Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; jbarnes@virtuousgeek.org
Subject: Re: [PATCH] enabling ACS P2P upstream forwarding

On Tue, 2009-09-15 at 16:44 -0700, Kay, Allen M wrote:
> This patch enables P2P upstream forwarding in ACS capable PCIe switches.  This solves two potential problems in virtualization environment where a PCIe device is assigned to a guest domain using a HW iommu such as VT-d:
> 
> 1) Unintentional failure caused by guest physical address programmed into the device's DMA that happens to match the memory address range of other downstream ports in the same PCIe switch.  This causes the PCI transaction to go to the matching downstream port instead of go to the root complex to get translated by VT-d as it should be.
> 
> 2) Malicious guest software intentionally attacks another downstream PCIe device by programming the DMA address into the assigned device that matches memory address range of the downstream PCIe port.
> 
> We are in process of implementing device filtering software in KVM/XEN management software to allow device assignment of PCIe devices behind a PCIe switch only if it has ACS capability and with the P2P upstream forwarding bits enabled.  This patch is intended to work for both KVM and Xen environments.
> 
> Signed-off-by: Allen Kay allen.m.kay@intel.com


Both times that you've submitted this the patch has been corrupt.. Your
mailer, or something is adding little "=20" or "=3D" all over. For
instance,

"Signed-off-by: Allen Kay allen.m.kay@intel.com

---

 drivers/pci/pci.c        |   37 +++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h        |    1 +
 drivers/pci/probe.c      |    3 +++
 include/linux/pci_regs.h |   14 ++++++++++++++
 4 files changed, 55 insertions(+)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7b70312..e70abde 100644
..."


So there's no way to test or apply your patch .. Most reviewers are just
going to walk away if they see stuff like this..

Daniel

