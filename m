Return-Path: <linux-kernel-owner+w=401wt.eu-S935414AbZDCQ0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935414AbZDCQ0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934846AbZDCQ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:26:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:35625 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935689AbZDCQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:26:17 -0400
Subject: Re: [patch 0/2] decouple interrupt remapping from x2apic
From: David Woodhouse <dwmw2@infradead.org>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       IOMMU <iommu@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <715D42877B251141A38726ABF5CABF2C01A2F7C3A5@pdsmsx503.ccr.corp.intel.com>
References: <715D42877B251141A38726ABF5CABF2C01A2F7C3A5@pdsmsx503.ccr.corp.intel.com>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 17:26:11 +0100
Message-Id: <1238775971.3494.48.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 17:15 +0800, Han, Weidong wrote:
> Current interrupt remapping is only enabled when x2apic is enabled. In
> fact, interrupt remapping can be used without x2apic. 
> 
> This patchset decouples interrupt remapping from x2apic, and then
> interrupt remapping can be used without x2apic.

Added to the tree at git://git.infradead.org/~dwmw2/iommu-suspend.git
which I'll ask Linus to pull as soon as he's taken the first batch from
the iommu-2.6.git tree.

Please could you check the second patch to ensure that I fixed it
correctly -- it didn't apply to Linus' HEAD.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

