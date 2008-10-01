Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYJAQ40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYJAQ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYJAQ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:56:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:11741 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbYJAQ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:56:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,344,1220252400"; 
   d="scan'208";a="445799841"
Date: Wed, 1 Oct 2008 09:56:06 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH 0/2]Add Variable Page Size and IA64 Support in Intel IOMMU
Message-ID: <20081001165606.GA21279@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following two patches (Intel IOMMU generic patch and ia64 specific patch) together enable Intel IOMMU on IA64 platform. They are applied cleanly on the latest linux-next tree which contains Intel IOMMU interrupt remapping and VT-d driver KVM support code.

If applying only the generic patch on x86-64 kernel, x86-64 IOMMU is working fine, i.e. the generic patch doesn't have compilation and functionality impact on x86-64 IOMMU. If applying only the ia64 specific patch on ia64 kernel, ia64 is working as non-IOMMU/swiotlb case. If applying both of the patches and set CONFIG_DMAR=y, ia64 IOMMU is working.

Thanks.

-Fenghua
