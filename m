Return-Path: <linux-kernel-owner+w=401wt.eu-S1032501AbXFHWx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032501AbXFHWx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbXFHWxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:53:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:37535 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbXFHWxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:53:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,401,1175497200"; 
   d="scan'208";a="252462542"
Date: Fri, 8 Jun 2007 15:49:31 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ak@suse.de, gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070608224931.GA10312@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <20070606190042.510643000@askeshav-devel.jf.intel.com> <20070607162726.2236a296.akpm@linux-foundation.org> <20070608182156.GA24865@linux-os.sc.intel.com> <20070608120107.245eba96.akpm@linux-foundation.org> <20070608201200.GA641@linux-os.sc.intel.com> <Pine.LNX.4.64.0706081532410.3966@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706081532410.3966@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 03:33:39PM -0700, Christoph Lameter wrote:
> On Fri, 8 Jun 2007, Keshavamurthy, Anil S wrote:
> 
> > > You _seem_ to be saying that the resource pools are there purely for
> > > alloc/free performance reasons.  If so, I'd be skeptical: slab is pretty
> > > darned fast.
> > We need several objects of size say( 4 * sizeof(u64)) and reuse
> > them in dma map/unmap api calls for managing io virtual allocation address that
> > this driver has dished out. Hence having pool of objects where we put 
> > the element in the linked list and and get it from the linked list is pretty
> > fast compared to slab.
> 
> SLUB also manages objects using a linked list. Is there a real performance 
> difference?

Sorry, I have not tried using SLUB, I will surely check this out.

-Anil
