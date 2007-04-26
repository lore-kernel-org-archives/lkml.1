Return-Path: <linux-kernel-owner+w=401wt.eu-S1031387AbXDZSDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031387AbXDZSDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031388AbXDZSDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:03:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52106 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031387AbXDZSDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:03:05 -0400
Date: Thu, 26 Apr 2007 11:03:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com>
 <46304B9E.5070604@yahoo.com.au> <20070426161152.GC16337@infradead.org>
 <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Eric W. Biederman wrote:

> My most practical suggestion is to have support code so that you can
> do all of the locking (that I/O cares about) on the first page of a
> page group in the page cache.  You don't need larger physical pages to
> do that.

Virtual mappings for larger pages? Or some software simulated form? This 
all sounds like awful hacks.

> Iff we really the larger physical page size to support the hardware
> then it makes sense to go down a path of larger pages.  But it doesn't.

You are redefining the problem. We need larger physical sizes to support 
the hardware. Yes. We can dodge the issue with shim layers and hacks. It 
is obvious from the kernel sources that this is needed.
  
> There is also a more fundamental reasons this patch is silly.  It assumes
> that there is a trivial mapping between filesystems (the primary target
> of the page cache and blocks on disk).  Now I admit this is common but
> there is no reason to supposed it is true, and this patch appears to
> exacerbate things.

The patch does the obvious... Nothing is silly about memory being 
contigous in memory and on disk.
