Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbXFUT42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbXFUT42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759722AbXFUTze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:55:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:19424 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759494AbXFUTza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:55:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,448,1175497200"; 
   d="scan'208";a="241844054"
Date: Thu, 21 Jun 2007 12:51:07 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures	in	dma	map api calls
Message-ID: <20070621195107.GA2926@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070620173038.GA25516@linux-os.sc.intel.com> <1182362703.21117.79.camel@twins> <46797CB1.8070008@linux.intel.com> <1182370132.21117.84.camel@twins> <20070620230337.GA6771@linux-os.sc.intel.com> <1182406212.21117.94.camel@twins> <467A1679.8090202@linux.intel.com> <1182407374.21117.106.camel@twins> <20070621063730.GC6771@linux-os.sc.intel.com> <1182409991.21117.112.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182409991.21117.112.camel@twins>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 09:13:11AM +0200, Peter Zijlstra wrote:
> On Wed, 2007-06-20 at 23:37 -0700, Keshavamurthy, Anil S wrote:
> > On Thu, Jun 21, 2007 at 08:29:34AM +0200, Peter Zijlstra wrote:
> > > On Wed, 2007-06-20 at 23:11 -0700, Arjan van de Ven wrote:
> > > > Peter Zijlstra wrote:
> > > Also, the other iommu code you pointed me to, was happy to fail, it did
> > > not attempt to use the emergency reserves.
> > 
> > Is the same behavior acceptable here?
> 
> I would say it is. Failure is a part of life.
> 
> If you have a (small) mempool with 16 pages or so, that should give you
> plenty megabytes of io-space to get out of a tight spot. That is, you
> can queue many pages with that. If it is depleted you know you have at
> least that many pages outstanding. So failing will just delay the next
> pages.
> 
> Throughput is not a key issue when that low on memory, a guarantee of
> progress is.

Andrew,
	Can you please queue all the other patches except this one for your
next MM release? (Yes, We can safely drop this patch without any issues in applying
rest of the patches).


-thanks,
Anil Keshavamurthy
