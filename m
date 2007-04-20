Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbXDTHsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbXDTHsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 03:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbXDTHsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 03:48:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60974 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754118AbXDTHsj (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 03:48:39 -0400
Date: Fri, 20 Apr 2007 17:48:18 +1000
From: David Chinner <dgc@sgi.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
Message-ID: <20070420074818.GN32602149@melbourne.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419224225.GJ32602149@melbourne.sgi.com> <20070420063257.GB6525@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420063257.GB6525@kernel.dk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 08:32:57AM +0200, Jens Axboe wrote:
> On Fri, Apr 20 2007, David Chinner wrote:
> > > The ramfs driver can be used to test higher order page cache functionality
> > > (and may help troubleshoot the VM support until we get some real filesystem
> > > and real devices supporting higher order pages).
> > 
> > I don't think it will take much to get XFS to work with a high order
> > page cache and we can probably insulate the block layer initially with some
> > kind of bio_add_compound_page() wrapper and some similar
> > wrapper on the io completion side.
> 
> Eh no way, at least not if you want it merged. Lets not repeat the XFS
> kiobuf IO disaster :-). If this is to be done and merged, it needs to be
> integrated nicely with the current framework, not attached to the side.

Agreed - I was talking about a quick way to hack a real filesystem
in to the VM to start exercising the new VM code without needing to
implement compound page support down the whole I/O stack. 

Any sort of hack we do like this will be throwaway code, but we're
going to need something to start with. I'll leave it up to ppl know
know much more about the block layer than I do to decide how to
do this properly.... ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
