Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbXFUGl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbXFUGl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXFUGlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:41:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:59199 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbXFUGls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:41:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,446,1175497200"; 
   d="scan'208";a="259404653"
Date: Wed, 20 Jun 2007 23:37:31 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures	in	dma	map api calls
Message-ID: <20070621063730.GC6771@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <1182326799.21117.19.camel@twins> <46792586.20706@linux.intel.com> <20070620173038.GA25516@linux-os.sc.intel.com> <1182362703.21117.79.camel@twins> <46797CB1.8070008@linux.intel.com> <1182370132.21117.84.camel@twins> <20070620230337.GA6771@linux-os.sc.intel.com> <1182406212.21117.94.camel@twins> <467A1679.8090202@linux.intel.com> <1182407374.21117.106.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182407374.21117.106.camel@twins>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 08:29:34AM +0200, Peter Zijlstra wrote:
> On Wed, 2007-06-20 at 23:11 -0700, Arjan van de Ven wrote:
> > Peter Zijlstra wrote:
> Also, the other iommu code you pointed me to, was happy to fail, it did
> not attempt to use the emergency reserves.

Is the same behavior acceptable here?

-Anil
