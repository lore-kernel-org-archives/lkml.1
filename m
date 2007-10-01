Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbXJAVBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbXJAVBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbXJAVBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:01:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33172 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751447AbXJAVBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:01:04 -0400
Date: Mon, 1 Oct 2007 14:01:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
In-Reply-To: <1191055513.18147.97.camel@lappy>
Message-ID: <Pine.LNX.4.64.0710011358350.19779@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com>  <20070919033643.763818012@sgi.com>
  <200709280742.38262.nickpiggin@yahoo.com.au> 
 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com> 
 <1191002119.18147.80.camel@lappy>  <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
 <1191055513.18147.97.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007, Peter Zijlstra wrote:

> 
> On Fri, 2007-09-28 at 11:20 -0700, Christoph Lameter wrote:
> 
> > Really? That means we can no longer even allocate stacks for forking.
> 
> I think I'm running with 4k stacks...

4k stacks will never fly on an SGI x86_64 NUMA configuration given the 
additional data that may be kept on the stack. We are currently 
considering to go from 8k to 16k (or even 32k) to make things work. So 
having the ability to put the stacks in vmalloc space may be something to 
look at.

