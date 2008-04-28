Return-Path: <linux-kernel-owner+w=401wt.eu-S1763297AbYD1FAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763297AbYD1FAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYD1FAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:00:37 -0400
Received: from relay2.sgi.com ([192.48.171.30]:58028 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851AbYD1FAg (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:00:36 -0400
Date: Mon, 28 Apr 2008 14:59:54 +1000
From: David Chinner <dgc@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Daniel Walker <dwalker@mvista.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080428045954.GG103491721@sgi.com>
References: <20080425170021.GH14990@parisc-linux.org> <1209155917.12461.46.camel@localhost.localdomain> <20080425211250.GA13858@infradead.org> <1209158552.12461.53.camel@localhost.localdomain> <20080426093048.GA11443@infradead.org> <1209217153.1956.14.camel@lappy> <20080426134430.GA28205@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426134430.GA28205@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 09:44:30AM -0400, Christoph Hellwig wrote:
> On Sat, Apr 26, 2008 at 03:39:13PM +0200, Peter Zijlstra wrote:
> > I'm guessing RCU would be a bit more work?
> 
> Actually the whole XFS inode hash is gone now and replaced by a radix tree.
> As soon as nick and your work on the lockless radix trees goes in I'm
> pretty sure Dave will make use of that.

I have patches for that, but came across reference counting issues
with the refcount being held in the linux inode not the XFS inode
and hence not being able to properly refcount the xfs inode once
the linux inode is gone away....

Solvable, but I've got to find some time to work on stuff that isn't
just bug fixing....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
