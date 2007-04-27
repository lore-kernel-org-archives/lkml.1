Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbXD0RcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbXD0RcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbXD0RcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:32:13 -0400
Received: from sccrmhc15.comcast.net ([63.240.77.85]:56688 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbXD0RcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:32:11 -0400
Subject: Re: [00/17] Large Blocksize Support V3
From: Nicholas Miell <nmiell@comcast.net>
To: Theodore Tso <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <20070427165522.GI24852@thunk.org>
References: <20070424222105.883597089@sgi.com>
	 <20070426190438.3a856220.akpm@linux-foundation.org>
	 <20070427022731.GF65285596@melbourne.sgi.com>
	 <20070426195357.597ffd7e.akpm@linux-foundation.org>
	 <20070427042046.GI65285596@melbourne.sgi.com>
	 <20070426221528.655d79cb.akpm@linux-foundation.org>
	 <20070427165522.GI24852@thunk.org>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 10:32:07 -0700
Message-Id: <1177695127.3119.1.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 12:55 -0400, Theodore Tso wrote:
> On Thu, Apr 26, 2007 at 10:15:28PM -0700, Andrew Morton wrote:
> > And hardware gets better.  If Intel & AMD come out with a 16k pagesize
> > option in a couple of years we'll look pretty dumb.  If the problems which
> > you're presently having with that controller get sorted out in the next
> > generation of the hardware, we'll also look pretty dumb.
> 
> Unfortunately, this isn't a problem with hardware getting better, but
> a willingness to break backwards compatibility.
> 
> x86_64 uses a 4k page size to avoid breaking 32-bit applications.  And
> unfortunately, iirc, even 64-bit applications are continuing to depend
> on 4k page alignments for things like the text and bss segments.  If
> the userspace ELF and other compiler/linker specifications were
> appropriate written so they could handle 16k pagesizes, maybe 5 years
> from now we could move to a 16k pagesize.  But this is going to
> require some coordination between the userspace binutils folks and
> AMD/Intel in order to plan such a migration.
> 
> 							- Ted

The AMD64 psABI requires binaries to work with any page size up to 64k.

Whether that's true in practice is another matter entirely, of course.

-- 
Nicholas Miell <nmiell@comcast.net>

