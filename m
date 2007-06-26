Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbXFZPwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbXFZPwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbXFZPwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:52:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:37175 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbXFZPwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:52:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,464,1175497200"; 
   d="scan'208";a="100296018"
Date: Tue, 26 Jun 2007 08:48:04 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Message-ID: <20070626154803.GA3374@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070625234550.058635cb.akpm@linux-foundation.org> <200706260912.45838.ak@suse.de> <20070626111324.GB4320@rhun.ibm.com> <46812ADF.3060609@linux.intel.com> <20070626151125.GD8274@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626151125.GD8274@rhun.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 11:11:25AM -0400, Muli Ben-Yehuda wrote:
> On Tue, Jun 26, 2007 at 08:03:59AM -0700, Arjan van de Ven wrote:
> > Muli Ben-Yehuda wrote:
> > >How much? we have numbers (to be presented at OLS later this week)
> > >that show that on bare-metal an IOMMU can cost as much as 15%-30% more
> > >CPU utilization for an IO intensive workload (netperf). It will be
> > >interesting to see comparable numbers for VT-d.
> > 
> > for VT-d it is a LOT less. I'll let anil give you his data :)
> 
> Looking forward to it. Note that this is on a large SMP machine with
> Gigabit ethernet, with netperf TCP stream. Comparing numbers for other
> benchmarks on other machines is ... less than useful, but the numbers
> themeselves are interesting.
Our initial benchmark results showed we had around 3% extra CPU 
utilization overhead when compared to native(i.e without IOMMU).
Again, our benchmark was on small SMP machine and we used
iperf and a 1G ethernet cards.

Going forward we will do more benchmark tests and will share the
results.

-Anil
