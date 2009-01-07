Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbZAGOym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbZAGOym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZAGOyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:54:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:18671 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbZAGOyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:54:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,226,1231142400"; 
   d="scan'208";a="479647798"
Date: Wed, 7 Jan 2009 22:47:16 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org, dwmw2@infradead.org
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] ATS capability support for Intel IOMMU
Message-ID: <20090107144716.GA4697@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements Address Translation Service support for
the Intel IOMMU. ATS provides ability for the PCI Endpoint to request
the DMA address translation from the IOMMU and cache the translation
in the Endpoint to alleviate IOMMU pressure and improve the hardware
performance in the I/O virtualization environment.

[PATCH 1/6] PCI: support the ATS capability
[PATCH 2/6] VT-d: parse ATSR in DMA Remapping Reporting Structure
[PATCH 3/6] VT-d: add queue invalidation fault status support
[PATCH 4/6] VT-d: add device IOTLB invalidation support
[PATCH 5/6] VT-d: cleanup iommu_flush_iotlb_psi and flush_unmaps
[PATCH 6/6] VT-d: support the device IOTLB
