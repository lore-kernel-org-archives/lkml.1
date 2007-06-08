Return-Path: <linux-kernel-owner+w=401wt.eu-S1031349AbXFHWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031349AbXFHWte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbXFHWt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:49:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:35959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbXFHWt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:49:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,401,1175497200"; 
   d="scan'208";a="94947700"
Date: Fri, 8 Jun 2007 15:45:40 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ak@suse.de, gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070608224539.GA9851@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <20070606190042.510643000@askeshav-devel.jf.intel.com> <20070607162726.2236a296.akpm@linux-foundation.org> <20070608182156.GA24865@linux-os.sc.intel.com> <Pine.LNX.4.64.0706081531161.3966@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706081531161.3966@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 03:32:08PM -0700, Christoph Lameter wrote:
> On Fri, 8 Jun 2007, Keshavamurthy, Anil S wrote:
> 
> > In the IOMMU case, we need exactly opposite of what mempool provides,
> > i.e we always want to look for the element in the pool and if the pool
> > has no element then go to OS as a worst case. This resource pool
> > library routines do the same. Again, this resource pools 
> > grows and shrinks automatically to maintain the minimum pool 
> > elements in the background. I am not sure whether this totally
> > opposite functionality of mempools and resource pools can be 
> > merged.
> 
> What functionality are you missing in the page allocator? It seems that is 
> does what you want?
Humm..I basically want to allocate memory during interrupt context and 
expect not to fail. I know this is a hard requirement :)
I want to be able to reserve certain amount of memory specifically for 
IOMMU purpose.

-Anil
