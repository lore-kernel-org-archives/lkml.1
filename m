Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbXJDU6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbXJDU6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbXJDU6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:58:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42198 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbXJDU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:58:14 -0400
Date: Thu, 4 Oct 2007 14:58:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Miller <davem@davemloft.net>
Cc: arjan@infradead.org, clameter@sgi.com, willy@linux.intel.com,
       nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dgc@sgi.com, jens.axboe@oracle.com
Subject: Re: SLUB performance regression vs SLAB
Message-ID: <20071004205812.GQ12049@parisc-linux.org>
References: <20071004161621.GO12049@parisc-linux.org> <Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com> <20071004105046.7b019fe8@laptopd505.fenrus.org> <20071004.134834.112622292.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004.134834.112622292.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 01:48:34PM -0700, David Miller wrote:
> There comes a point where it is the reporter's responsibility to help
> the developer come up with a publishable test case the developer can
> use to work on fixing the problem and help ensure it stays fixed.

That's a lot of effort.  Is it more effort than doing some remote
debugging with Christoph?  I don't know.

> Using an unpublishable benchmark, whose results even cannot be
> published, really stretches the limits of "reasonable" don't you
> think?

Yet here we stand.  Christoph is aggressively trying to get slab removed
from the tree.  There is a testcase which shows slub performing worse
than slab.  It's not my fault I can't publish it.  And just because I
can't publish it doesn't mean it doesn't exist.

Slab needs to not get removed until slub is as good a performer on this
benchmark.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
