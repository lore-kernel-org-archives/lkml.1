Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbXDZHFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbXDZHFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXDZHFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:05:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36895 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933271AbXDZHFQ (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:05:16 -0400
Date: Thu, 26 Apr 2007 17:04:54 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426070454.GF32602149@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46304C74.9040304@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 04:53:40PM +1000, Nick Piggin wrote:
> Christoph Lameter wrote:
> >On Thu, 26 Apr 2007, Nick Piggin wrote:
> >>I am working now and again on some code to do this, it is a big job but
> >>I think it is the right way to do it. But it would take a long time to
> >>get stable and supported by filesystems...
> >
> >Ummm... We already have a radix tree for this???? What more is needed? You 
> >just need to go through all filesystems and make them use extends.
> 
> I'm talking about block size > page size in the buffer layer.

Nick, what's the buffer layer? Are you talking about operations
based on bufferheads?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
