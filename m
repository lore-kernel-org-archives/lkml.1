Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbXFLAjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbXFLAjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbXFLAjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:39:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56751 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753774AbXFLAi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:38:59 -0400
Date: Mon, 11 Jun 2007 17:38:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
In-Reply-To: <20070611235208.GC25022@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0706111737230.24389@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <200706090056.49279.ak@suse.de> <Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com>
 <200706091147.24705.ak@suse.de> <20070611204442.GA4074@linux-os.sc.intel.com>
 <20070611141449.bfbc4769.akpm@linux-foundation.org>
 <20070611235208.GC25022@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007, Keshavamurthy, Anil S wrote:

> slab allocators don;t reserve the memory, in other words this memory 
> can be consumed by VM under memory pressure which we don;t want in
> IOMMU case.

So mempools....

> Nope,they both are exactly opposite. 
> mempool with GFP_ATOMIC, first tries to get memory from OS and
> if that fails, it looks for the object in the pool and returns.

How does the difference matter? In both cases you get the memory you want.

> Where as resource pool is exactly opposite of mempool, where each 
> time it looks for an object in the pool and if it exist then we 
> return that object else we try to get the memory for OS while 
> scheduling the work to grow the pool objects. In fact, the  work
> is schedule to grow the pool when the low threshold point is hit.

Grow the mempool when the low level point is hit? Or equip mempools with 
the functionality that you want?
