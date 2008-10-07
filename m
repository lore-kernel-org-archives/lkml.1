Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYJGACe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYJGACe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYJGAC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:02:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:56174 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbYJGACZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:02:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,370,1220252400"; 
   d="scan'208";a="388313868"
Date: Mon, 6 Oct 2008 17:01:36 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: [PATCH V2 0/2] Add Variable Page Size and IA64 Support in Intel IOMMU
Message-ID: <20081007000136.GA22959@linux-os.sc.intel.com>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001165606.GA21279@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patche set (Intel IOMMU generic patch and ia64 specific patch) together enable Intel IOMMU on IA64 platform. They are applied cleanly on the latest linux-next tree which contains Intel IOMMU interrupt remapping and VT-d driver KVM support code.
 
If applying only the generic patch on x86-64 kernel, x86-64 IOMMU is working fine, i.e. the generic patch doesn't have compilation and functionality impact on x86-64 IOMMU. If applying only the ia64 specific patch on ia64 kernel, ia64 is working as non-IOMMU/swiotlb case. If applying both of the patches and set CONFIG_DMAR=y, ia64 IOMMU is working.
 
Thanks.
 
-Fenghua
