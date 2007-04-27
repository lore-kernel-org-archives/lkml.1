Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbXD0FUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbXD0FUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbXD0FUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:20:15 -0400
Received: from brick.kernel.dk ([80.160.20.94]:1156 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbXD0FUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:20:13 -0400
Date: Fri, 27 Apr 2007 07:16:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mel Gorman <mel@skynet.ie>
Cc: Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427051625.GM2017@kernel.dk>
References: <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com> <20070426180358.GG2017@kernel.dk> <20070426180932.GA10642@infradead.org> <20070426181249.GH2017@kernel.dk> <Pine.LNX.4.64.0704261127550.3560@schroedinger.engr.sgi.com> <20070426182945.GJ2017@kernel.dk> <Pine.LNX.4.64.0704261134080.3656@schroedinger.engr.sgi.com> <20070426183935.GK2017@kernel.dk> <20070426202202.GI16909@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426202202.GI16909@skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26 2007, Mel Gorman wrote:
> On (26/04/07 20:39), Jens Axboe didst pronounce:
> > On Thu, Apr 26 2007, Christoph Lameter wrote:
> > > On Thu, 26 Apr 2007, Jens Axboe wrote:
> > > 
> > > > On Thu, Apr 26 2007, Christoph Lameter wrote:
> > > > > On Thu, 26 Apr 2007, Jens Axboe wrote:
> > > > > 
> > > > > > The above can be implemented fairly cleanly, and on a need-to-have
> > > > > > basis. It's not something that'll break drivers.
> > > > > 
> > > > > But its also not going to fix the hacks that we have in the kernel 
> > > > > to deal with > PAGE_SIZE i/o.
> > > > 
> > > > No, but that's a _seperate_ issue! Don't keep mixing up the two.
> > > 
> > > Yes I understand that you want it to be a separate issue so we get get 
> > > more rationales for the hacks that we do to avoid the large 
> > > order allocations.
> > 
> > Christoph, don't take your frustrations out on me. I've several times in
> > this thread said that I'd LIKE to have > PAGE_SIZE support in the page
> > cache. I WROTE the initial pktcdvd driver that is a primary example of
> > these hacks, I'm very well aware of the pain and bugs involved with
> > that.
> > 
> > But don't push large pages as the only solution to larger ios, because
> > that is trivially not true.
> > 
> 
> Would it be fair to say that your approach and using large pages are not
> mutually exclusive solutions? It seems a lot of the debate here is
> assuming there is One And Only One Solution for larger ios.

Definitely, there's zero reason they cannot coexist.

-- 
Jens Axboe

