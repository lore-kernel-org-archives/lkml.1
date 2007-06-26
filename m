Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbXFZPhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbXFZPhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbXFZPhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:37:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54291 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbXFZPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:37:00 -0400
Date: Tue, 26 Jun 2007 17:36:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net,
       clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Message-ID: <20070626153658.GB5244@one.firstfloor.org>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070625234550.058635cb.akpm@linux-foundation.org> <200706260912.45838.ak@suse.de> <20070626111324.GB4320@rhun.ibm.com> <p73645a675q.fsf@bingen.suse.de> <20070626150940.GC8274@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626150940.GC8274@rhun.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 11:09:40AM -0400, Muli Ben-Yehuda wrote:
> On Tue, Jun 26, 2007 at 05:56:49PM +0200, Andi Kleen wrote:
> 
> > > > - The IOMMU can merge sg lists into a single virtual block. This could
> > > > potentially speed up SG IO when the device is slow walking SG
> > > > lists.  [I long ago benchmarked 5% on some block benchmark with
> > > > an old MPT Fusion; but it probably depends a lot on the HBA]
> > > 
> > > But most devices are SG-capable.
> > 
> > Your point being?
> 
> That the fact that an IOMMU can do SG for non-SG-capble cards is not
> interesting from a "reason for inclusion" POV.

You misunderstood me; my point was that some SG capable devices
can go faster if they get shorter SG lists.

But yes for non SG capable devices it is also interesting. I expect
it will obsolete most users of that ugly external patch to allocate large
memory areas for IOs. That's a point I didn't mention earlier.

> > Also the user interface for X server case needs more work.
> 
> Is anyone working on it?

It's somewhere on the todo list.


-Andi
