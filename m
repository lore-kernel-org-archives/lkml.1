Return-Path: <linux-kernel-owner+w=401wt.eu-S938760AbXFHWzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938760AbXFHWzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXFHWzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:55:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59406 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751145AbXFHWzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:55:06 -0400
Date: Fri, 8 Jun 2007 15:55:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ak@suse.de, gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
In-Reply-To: <20070608224539.GA9851@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0706081553030.4332@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <20070606190042.510643000@askeshav-devel.jf.intel.com>
 <20070607162726.2236a296.akpm@linux-foundation.org>
 <20070608182156.GA24865@linux-os.sc.intel.com>
 <Pine.LNX.4.64.0706081531161.3966@schroedinger.engr.sgi.com>
 <20070608224539.GA9851@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Keshavamurthy, Anil S wrote:

> > What functionality are you missing in the page allocator? It seems that is 
> > does what you want?
> Humm..I basically want to allocate memory during interrupt context and 
> expect not to fail. I know this is a hard requirement :)

The page allocator can do that for you. The reserves are configurable. Not 
failing is a thing unseen in the computer world.

> I want to be able to reserve certain amount of memory specifically for 
> IOMMU purpose.

That is of course a problem unless you allocate memory beforehand. 
Mempool?



