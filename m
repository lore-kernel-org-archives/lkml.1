Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbXD0Hny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbXD0Hny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbXD0Hny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:43:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbXD0Hnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:43:53 -0400
Date: Fri, 27 Apr 2007 00:43:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070427004340.1d723852.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704270031590.5501@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com>
	<20070426190438.3a856220.akpm@linux-foundation.org>
	<20070427022731.GF65285596@melbourne.sgi.com>
	<20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	<20070426235542.bad7035a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704270020280.5501@schroedinger.engr.sgi.com>
	<20070427002947.ebe7e7ac.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704270031590.5501@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 00:35:19 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 27 Apr 2007, Andrew Morton wrote:
> 
> > On Fri, 27 Apr 2007 00:22:26 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> > 
> > > I will submit pieces to mm depending on the 
> > > outcome of our discussions.
> 
> > There's a ludicrous amount of MM work pending in -mm.  It would probably be
> > less work at your end to see what ends up landing in 2.6.22-rc1.
> 
> I am aware of that and thats why I kept this against upstream. The need 
> right now is for justification and explanation. I had to go 
> through a head spinning series of VM layers to get an idea how to do 
> this in a clean way and then had to make additional passes to do minimal 
> modifications to get this working so that it is testable.

OK.

Don't get me wrong - I do think this is neat code and is a good way of
addressing the problem.  (I'm surprised that the mmap protopatch didn't
touch rmap.c).

But I don't think it's a slam dunk and I would like you to appreciate the
constraints which I believe we operate under.  And I don't think we've
adequately considered alternative solutions to the immediate performance problems.

> Performance tests please...

On various HBAs, please ;)
