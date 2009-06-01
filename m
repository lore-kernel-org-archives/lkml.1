Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZFAHpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZFAHpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbZFAHou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:44:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:40912 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbZFAHot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:44:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,283,1241420400"; 
   d="scan'208";a="149128836"
From: "Han, Weidong" <weidong.han@intel.com>
To: "mingo@elte.hu" <mingo@elte.hu>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
Date: Mon, 1 Jun 2009 15:43:52 +0800
Subject: RE: [PATCH v3 0/2] Intel-IOMMU: source-id checking for interrupt
 remapping
Thread-Topic: [PATCH v3 0/2] Intel-IOMMU: source-id checking for interrupt
 remapping
Thread-Index: AcnauSgH5xaowD6UQZWH3a8sy/IfGQH0yqCw
Message-ID: <715D42877B251141A38726ABF5CABF2C054587E14F@pdsmsx503.ccr.corp.intel.com>
References: <1243010475-7411-1-git-send-email-weidong.han@intel.com>
In-Reply-To: <1243010475-7411-1-git-send-email-weidong.han@intel.com>
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

Any comments on the patchset? Thanks. 

Regards,
Weidong

Han, Weidong wrote:
> Support source-id checking for interrupt remapping, and then
> isolates interrupts for guests/VMs with assigned devices.
> 
> Eric raised pci rebalance issue with VT-d. Yes, it's an issue now.
> Linux needs to handle pci rebalance changes to DRHD scopes. It's
> tricky to support it. This patch just supports source-id for
> interrupt remapping, won't touch that.
> 
> The patchset can be applied on linux-2.6-tip tree.
> 
> v2 -> v3 changelog:
> 	As Ingo suggested, restructured some code and fixed some code
> style issues.
> 
> v1 -> v2 changelog:
>         Access PCI directly (read_pci_config_byte) to parse IOAPIC,
> instead of PCI related discovery, because PCI subsystem is not
> initialized at that time.
> 
> 
> Weidong Han (2):
>   Intel-IOMMU, intr-remap: set the whole 128bits of irte when
>     modify/free it
>   Intel-IOMMU, intr-remap: source-id checking
> 
>  arch/x86/kernel/apic/io_apic.c |    6 ++
>  drivers/pci/intr_remapping.c   |  160
>  +++++++++++++++++++++++++++++++++++---- drivers/pci/intr_remapping.h
>  |    2 + include/linux/dmar.h           |   11 +++
>  4 files changed, 162 insertions(+), 17 deletions(-)

