Return-Path: <linux-kernel-owner+w=401wt.eu-S1765639AbYBTPpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765639AbYBTPpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYBTPoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:44:32 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34237 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070AbYBTPob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:44:31 -0500
Date: Wed, 20 Feb 2008 10:42:35 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080220154235.GD30305@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <1202791555.20739.6.camel@heimdal.trondhjem.org> <20080212051136.GA12802@mit.edu> <20080211221535.bc0dc9cf.akpm@linux-foundation.org> <20080212225716.cf695fe4.sfr@canb.auug.org.au> <20080214081405.GA20791@flint.arm.linux.org.uk> <20080214232229.f7bdc6ac.sfr@canb.auug.org.au> <alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org> <20080221015511.1b54d4d3.sfr@canb.auug.org.au> <47BC498C.6000400@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BC498C.6000400@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 04:38:52PM +0100, Stefan Richter wrote:
> Two things may largely eliminate the need for parallel branches.
> 
> 1. Do infrastructure changes and whole tree wide refactoring etc. in a
> compatible manner with a brief but nonzero transition period.
> 
> 2. Insert a second merge window right after the usual merge window for
> changes which cannot be well done with a transition period.

A third option would be if people add new functions (with no users) in
-rc2 or -rc3 timeframes as long as it is part of a fully reviewed
patch with users that will use those new features in various kernel
development trees.

Since there wouldn't be any users in Linus's tree, there's no risk in
making those functions available in mainline ahead of time.

						- Ted
