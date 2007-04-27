Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbXD0Qzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbXD0Qzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbXD0Qzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:55:40 -0400
Received: from thunk.org ([69.25.196.29]:52421 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbXD0Qz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:55:28 -0400
Date: Fri, 27 Apr 2007 12:55:22 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427165522.GI24852@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Chinner <dgc@sgi.com>, clameter@sgi.com,
	linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426221528.655d79cb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 10:15:28PM -0700, Andrew Morton wrote:
> And hardware gets better.  If Intel & AMD come out with a 16k pagesize
> option in a couple of years we'll look pretty dumb.  If the problems which
> you're presently having with that controller get sorted out in the next
> generation of the hardware, we'll also look pretty dumb.

Unfortunately, this isn't a problem with hardware getting better, but
a willingness to break backwards compatibility.

x86_64 uses a 4k page size to avoid breaking 32-bit applications.  And
unfortunately, iirc, even 64-bit applications are continuing to depend
on 4k page alignments for things like the text and bss segments.  If
the userspace ELF and other compiler/linker specifications were
appropriate written so they could handle 16k pagesizes, maybe 5 years
from now we could move to a 16k pagesize.  But this is going to
require some coordination between the userspace binutils folks and
AMD/Intel in order to plan such a migration.

							- Ted
