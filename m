Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYJHCeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYJHCeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYJHCeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:34:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:34004 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbYJHCeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:34:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,376,1220252400"; 
   d="scan'208";a="448392128"
From: "Zhao, Yu" <yu.zhao@intel.com>
To: Javier Guerra Giraldez <javier@guerrag.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Wed, 8 Oct 2008 10:32:35 +0800
Subject: RE: [PATCH 0/6 v3] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/6 v3] PCI: Linux kernel SR-IOV support
Thread-Index: AckgzAvUIYxcMSpnS5qIvitt1UEggAIINAyg
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE08A3D24349@pdsmsx502.ccr.corp.intel.com>
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5EF@pdsmsx502.ccr.corp.intel.com>
 <200809271308.03547.javier@guerrag.com>
In-Reply-To: <200809271308.03547.javier@guerrag.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 28, 2008 2:08 AM, Javier Guerra Giraldez wrote:
>On Saturday 27 September 2008, Zhao, Yu wrote:
>> Greetings,
>>
>> Following patches are intended to support SR-IOV capability in the Linux
>> kernel. With these patches, people can turn a PCI device with the
>> capability into multiple ones from software perspective, which can benefit
>> KVM and achieve other purposes such as QoS, security, etc.
>
>sounds great, i think some Infiniband HBAs have this capability; they even
>suggested using on Xen for faster (no hypervisor intervention) communication
>between DomU's on the same box. (and transparently to out of the box, of
>course)

Thanks. We will also push Xen patches soon. And please feel free to let us know if you have any question when integrating these patches with your products.

>
>does it need an IOMMU (VT-d), or the whole magic is done by the PCI device?

For native Linux, we can use Virtual Function without IOMMU. For KVM, it requires IOMMU so the guest can use VFs.

For Xen HVM, it also requires IOMMU. For Xen PV, it doesn't need IOMMU.

>
>--
>Javier
