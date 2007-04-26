Return-Path: <linux-kernel-owner+w=401wt.eu-S1031394AbXDZSJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031394AbXDZSJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031399AbXDZSJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:09:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57991 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031394AbXDZSJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:09:49 -0400
Date: Thu, 26 Apr 2007 19:09:33 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426180932.GA10642@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Christoph Lameter <clameter@sgi.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
	linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <46304B9E.5070604@yahoo.com.au> <20070426161152.GC16337@infradead.org> <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com> <20070426180358.GG2017@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426180358.GG2017@kernel.dk>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 08:03:58PM +0200, Jens Axboe wrote:
> On Thu, Apr 26 2007, Christoph Lameter wrote:
> > > Iff we really the larger physical page size to support the hardware
> > > then it makes sense to go down a path of larger pages.  But it doesn't.
> > 
> > You are redefining the problem. We need larger physical sizes to support 
> > the hardware. Yes. We can dodge the issue with shim layers and hacks. It 
> > is obvious from the kernel sources that this is needed.
> 
> We definitely don't. Larger sizes are ONE way to solve the problem, they
> are definitely not the only one. If the larger pages become unfeasible
> for some reason (be it fragmentation, or just because the design isn't
> good), then we can solve it differently.

Exactly.  But the only counter-proposal we have so far seems far worse :)
