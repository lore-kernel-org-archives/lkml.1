Return-Path: <linux-kernel-owner+w=401wt.eu-S1032456AbXFHWiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032456AbXFHWiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969549AbXFHWiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:38:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58204 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965945AbXFHWiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:38:03 -0400
Date: Fri, 8 Jun 2007 15:38:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Andreas Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
In-Reply-To: <20070608221803.GT17143@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0706081536560.3966@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <20070606190042.510643000@askeshav-devel.jf.intel.com>
 <20070607162726.2236a296.akpm@linux-foundation.org>
 <20070608182156.GA24865@linux-os.sc.intel.com> <20070608120107.245eba96.akpm@linux-foundation.org>
 <6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
 <20070608212054.GB641@linux-os.sc.intel.com> <20070608144207.07341ee7.akpm@linux-foundation.org>
 <20070608221803.GT17143@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Siddha, Suresh B wrote:

> > If for some reason you really can't do that (and a requirement for
> > allocation-in-interrupt is the only valid reason, really) and if you indeed
> > can demonstrate memory allocation failures with certain workloads then
> > let's take a look at that.  As I said, attaching a reserve pool to your
> > slab cache might be a suitable approach.  But none of these things are
> 
> I agree. We are better off with enhancing slab infrastructure for this, if
> needed.

The slab allocators already use the page allocators atomic reserves if 
called with GFP_ATOMIC. 
