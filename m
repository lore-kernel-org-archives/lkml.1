Return-Path: <linux-kernel-owner+w=401wt.eu-S1032427AbXFHWgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032427AbXFHWgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968972AbXFHWgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:36:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42615 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757513AbXFHWgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:36:02 -0400
Date: Fri, 8 Jun 2007 15:36:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andreas Kleen <ak@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
In-Reply-To: <6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
Message-ID: <Pine.LNX.4.64.0706081534520.3966@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <20070606190042.510643000@askeshav-devel.jf.intel.com>
 <20070607162726.2236a296.akpm@linux-foundation.org>
 <20070608182156.GA24865@linux-os.sc.intel.com> <20070608120107.245eba96.akpm@linux-foundation.org>
 <6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Andreas Kleen wrote:

> > That's what kmem_cache_alloc() is for?!?!
> 
> Tradtionally that was not allowed in block layer path. Not sure
> it is fully obsolete with the recent dirty tracking work, probably not.

Why was it not allowed? Because interrupts are disabled?
 
> Besides it would need to be GFP_ATOMIC and the default
> atomic pools are not that big.

Those could be increased. I think Mel has them already increased in mm.
