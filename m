Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbXD1J6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbXD1J6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbXD1J6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:58:18 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077AbXD1J6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:58:16 -0400
Date: Sat, 28 Apr 2007 02:58:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070428025801.eca77146.akpm@linux-foundation.org>
In-Reply-To: <20070428104328.0b609fb6@the-village.bc.nu>
References: <20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	<20070426235542.bad7035a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
	<20070427002640.22a71d06.akpm@linux-foundation.org>
	<20070427163620.GI32602149@melbourne.sgi.com>
	<20070427173432.GJ32602149@melbourne.sgi.com>
	<20070427121108.9ee05710.akpm@linux-foundation.org>
	<20070428031739.GK32602149@melbourne.sgi.com>
	<20070427215634.325606a9.akpm@linux-foundation.org>
	<20070428104328.0b609fb6@the-village.bc.nu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 10:43:28 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Fri, 27 Apr 2007 21:56:34 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sat, 28 Apr 2007 13:17:40 +1000 David Chinner <dgc@sgi.com> wrote:
> > 
> > > > Fix up your lameo HBA for reads.
> > > 
> > > Where did that come from? You spend 20 lines described the inefficiencies
> > > of the readahead in the page cache and it should be fixed but then you
> > > turn around and say fix the HBA? 
> > 
> > My (repeated) point is that if we populate pagecache with physically-contiguous 4k
> > pages in this manner then bio+block will be able to create much larger SG lists.
> 
> Also remember that even if you do larger pages by using virtual pairs or
> quads of real pages because it helps on some systems you end up needing
> the same sized sglist as before so you don't make anything worse for
> half-assed controllers as you get the same I/O size providing they have
> the minimal 2 or 4 sg list entries (and those that don't are genuinely
> beyond saving and nowdays very rare)
> 

Could you expand on that a bit please?  I don't get it.
