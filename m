Return-Path: <linux-kernel-owner+w=401wt.eu-S1763563AbXJET2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763563AbXJET2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760593AbXJET2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:28:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55192 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759673AbXJET2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:28:00 -0400
Date: Fri, 5 Oct 2007 12:27:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>,
       David Miller <davem@davemloft.net>, cebbert@redhat.com,
       willy@linux.intel.com, nickpiggin@yahoo.com.au, hch@lst.de,
       mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
In-Reply-To: <20071005115634.GV12049@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0710051226020.17481@schroedinger.engr.sgi.com>
References: <470554D9.2050505@redhat.com> <20071004.141113.08322956.davem@davemloft.net>
 <47055F84.109@redhat.com> <20071004.150718.95506800.davem@davemloft.net>
 <20071004222356.GH23367404@sgi.com> <20071005064853.GI5711@kernel.dk>
 <20071005115634.GV12049@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Matthew Wilcox wrote:

> I vaguely remembered something called orasim, so I went looking for it.
> I found http://oss.oracle.com/~wcoekaer/orasim/ which is dated from
> 2004, and I found http://oss.oracle.com/projects/orasimjobfiles/ which
> seems to be a stillborn project.  Is there anything else I should know
> about orasim?  ;-)

Too bad. If this would work then I would have a load to work against. I 
have a patch here that may address the issue for SMP (no NUMA for now) by 
batching all frees on the per cpu freelist and then dumping them in 
groups. But it is likely not too wise to have you run your weeklong 
tests on this one. Needs some more care first.



