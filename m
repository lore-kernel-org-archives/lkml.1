Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbXJDTrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbXJDTrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbXJDTqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:46:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:2022 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbXJDTqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:46:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,232,1188802800"; 
   d="scan'208";a="335516391"
Date: Thu, 4 Oct 2007 12:46:04 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
Message-ID: <20071004194604.GA27824@linux-os.sc.intel.com>
References: <200709280742.38262.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com> <200709281514.48293.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com> <20071004161621.GO12049@parisc-linux.org> <Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com> <20071004183224.GA8641@linux.intel.com> <Pine.LNX.4.64.0710041046270.11091@schroedinger.engr.sgi.com> <20071004192824.GA9852@linux.intel.com> <Pine.LNX.4.64.0710041156120.11927@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710041156120.11927@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 12:05:35PM -0700, Christoph Lameter wrote:
> > > Was the page allocator pass through patchset 
> > > separately applied as I requested?
> > 
> > I don't believe so.  Suresh?
> 
> If it was a git pull then the pass through was included and never taken 
> out.

It was a git pull from the performance branch that you pointed out earlier
http://git.kernel.org/?p=linux/kernel/git/christoph/slab.git;a=log;h=performance

and the config is based on EL5 config with just the SLUB turned on.
