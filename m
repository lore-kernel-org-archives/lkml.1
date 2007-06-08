Return-Path: <linux-kernel-owner+w=401wt.eu-S971559AbXFHWek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971559AbXFHWek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971479AbXFHWdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:33:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57873 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S971473AbXFHWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:33:40 -0400
Date: Fri, 8 Jun 2007 15:33:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ak@suse.de, gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
In-Reply-To: <20070608201200.GA641@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0706081532410.3966@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <20070606190042.510643000@askeshav-devel.jf.intel.com>
 <20070607162726.2236a296.akpm@linux-foundation.org>
 <20070608182156.GA24865@linux-os.sc.intel.com> <20070608120107.245eba96.akpm@linux-foundation.org>
 <20070608201200.GA641@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Keshavamurthy, Anil S wrote:

> > You _seem_ to be saying that the resource pools are there purely for
> > alloc/free performance reasons.  If so, I'd be skeptical: slab is pretty
> > darned fast.
> We need several objects of size say( 4 * sizeof(u64)) and reuse
> them in dma map/unmap api calls for managing io virtual allocation address that
> this driver has dished out. Hence having pool of objects where we put 
> the element in the linked list and and get it from the linked list is pretty
> fast compared to slab.

SLUB also manages objects using a linked list. Is there a real performance 
difference?
