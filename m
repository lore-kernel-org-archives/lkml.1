Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbXDZSd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbXDZSd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbXDZSd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:33:29 -0400
Received: from brick.kernel.dk ([80.160.20.94]:29086 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbXDZSd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:33:28 -0400
Date: Thu, 26 Apr 2007 20:29:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426182945.GJ2017@kernel.dk>
References: <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <46304B9E.5070604@yahoo.com.au> <20070426161152.GC16337@infradead.org> <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com> <20070426180358.GG2017@kernel.dk> <20070426180932.GA10642@infradead.org> <20070426181249.GH2017@kernel.dk> <Pine.LNX.4.64.0704261127550.3560@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704261127550.3560@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26 2007, Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Jens Axboe wrote:
> 
> > The above can be implemented fairly cleanly, and on a need-to-have
> > basis. It's not something that'll break drivers.
> 
> But its also not going to fix the hacks that we have in the kernel 
> to deal with > PAGE_SIZE i/o.

No, but that's a _seperate_ issue! Don't keep mixing up the two.

-- 
Jens Axboe

