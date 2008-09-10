Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbYIJHfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbYIJHfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 03:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYIJHfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 03:35:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:11438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYIJHfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 03:35:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,371,1217833200"; 
   d="scan'208";a="378666575"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 2/4 v2] PCI: support ARI capability
Date: Wed, 10 Sep 2008 15:35:06 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E110181CAB3@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <20080901152734.GC16796@ldl.fc.hp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/4 v2] PCI: support ARI capability
Thread-Index: AckMR3X8lXT3JaPhSse5ihFmI7ZkiQG0CU3g
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6E@pdsmsx414.ccr.corp.intel.com> <20080901152734.GC16796@ldl.fc.hp.com>
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Alex Chiang" <achiang@hp.com>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Greg KH" <greg@kroah.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       <xen-devel@lists.xensource.com>
X-OriginalArrivalTime: 10 Sep 2008 07:35:08.0366 (UTC) FILETIME=[C00776E0:01C91317]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 01, 2008 11:28 PM, Alex Chiang wrote:
>* Zhao, Yu <yu.zhao@intel.com>:
>> Support Alternative Routing-ID Interpretation (ARI), which increases the
>number of functions that can be supported by a PCIe endpoint. ARI is required
>by SR-IOV.
>>
>> PCI-SIG ARI specification can be found at
>http://www.pcisig.com/specifications/pciexpress/specifications/ECN-alt-rid-
>interpretation-070604.pdf
>>
>> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
>> Signed-off-by: Eddie Dong <eddie.dong@intel.com>
>>
>> ---
>>  drivers/pci/Kconfig      |    7 ++++
>>  drivers/pci/Makefile     |    2 +
>>  drivers/pci/ari.c        |   71
>++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/pci/pci.h        |    8 +++++
>>  drivers/pci/probe.c      |    3 ++
>>  include/linux/pci.h      |   25 ++++++++++++++++
>>  include/linux/pci_regs.h |   14 +++++++++
>>  7 files changed, 130 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/pci/ari.c
>>
>> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
>> index e1ca425..f43cc46 100644
>> --- a/drivers/pci/Kconfig
>> +++ b/drivers/pci/Kconfig
>> @@ -50,3 +50,10 @@ config HT_IRQ
>>  	   This allows native hypertransport devices to use interrupts.
>>
>>  	   If unsure say Y.
>> +
>> +config PCI_ARI
>> +	bool "PCI ARI support"
>> +	depends on PCI
>> +	default n
>> +	help
>> +	  This enables PCI Alternative Routing-ID Interpretation.
>
>This Kconfig help text is a little weak. Why not include the text
>you've already written here:
>
>	Support Alternative Routing-ID Interpretation (ARI), which
>	increases the number of functions that can be supported by a PCIe
>	endpoint. ARI is required by SR-IOV.
>
>In the Kconfig text, you might want to expand the SR-IOV acronym
>too.

Thanks. Will do in next version.

>
>Thanks.
>
>/ac

