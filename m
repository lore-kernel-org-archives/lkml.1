Return-Path: <linux-kernel-owner+w=401wt.eu-S1762887AbYD1F4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762887AbYD1F4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYD1F4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:56:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44897 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYD1F4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:56:39 -0400
Date: Mon, 28 Apr 2008 01:56:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nathan Scott <nscott@aconex.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Message-ID: <20080428055629.GB3192@infradead.org>
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com> <87iqy4wfjq.fsf@basil.nowhere.org> <20080426200701.GA10883@infradead.org> <20080426202630.GG17905@one.firstfloor.org> <20080426202323.GA14245@infradead.org> <1209341212.23166.122.camel@edge.scott.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209341212.23166.122.camel@edge.scott.net.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:06:51AM +1000, Nathan Scott wrote:
> Having to compile chunks of XFS code in both kernel and
> userspace is also wierd (relative to other drivers), and
> its a side-effect of needing to do that (all the code
> dealing with specifics of ondisk format is shared).

There would be neater ways to deal with that, but then again there
are more urgent things to tackle.  And for the time beeing using
STATIC to imply non-inline is actually a very useful hack for XFS.

