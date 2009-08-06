Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZHFTUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZHFTUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZHFTUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:20:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:49719 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbZHFTUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:20:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,335,1246863600"; 
   d="scan'208";a="714561674"
Subject: Re: [PATCH] pci/intr_remapping: allocate irq_iommu on node
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <4A7A2FB1.9050407@kernel.org>
References: <4A785C17.3030104@kernel.org>
	 <1249406368.27006.10789.camel@localhost.localdomain>
	 <4A794D8A.1060508@kernel.org>
	 <1249518985.27006.10805.camel@localhost.localdomain>
	 <4A7A2FB1.9050407@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 06 Aug 2009 12:16:06 -0700
Message-Id: <1249586166.27006.10816.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-05 at 18:19 -0700, Yinghai Lu wrote:
> Suresh Siddha wrote:
> > 
> > Yinghai, even with this patch, we will still be allocating from node-0.
> > No?
> 
> with this patch will get 
> alloc irq_2_iommu on node 2

Looking closer, I missed the fact that we are now using the
create_irq_nr() which has the node information.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

Thanks.

