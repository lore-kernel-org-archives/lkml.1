Return-Path: <linux-kernel-owner+w=401wt.eu-S971385AbXFHWch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971385AbXFHWch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031588AbXFHWcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:32:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57722 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1032423AbXFHWcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:32:09 -0400
Date: Fri, 8 Jun 2007 15:32:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ak@suse.de, gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
In-Reply-To: <20070608182156.GA24865@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0706081531161.3966@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <20070606190042.510643000@askeshav-devel.jf.intel.com>
 <20070607162726.2236a296.akpm@linux-foundation.org>
 <20070608182156.GA24865@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Keshavamurthy, Anil S wrote:

> In the IOMMU case, we need exactly opposite of what mempool provides,
> i.e we always want to look for the element in the pool and if the pool
> has no element then go to OS as a worst case. This resource pool
> library routines do the same. Again, this resource pools 
> grows and shrinks automatically to maintain the minimum pool 
> elements in the background. I am not sure whether this totally
> opposite functionality of mempools and resource pools can be 
> merged.

What functionality are you missing in the page allocator? It seems that is 
does what you want?
