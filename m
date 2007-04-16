Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbXDPDGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbXDPDGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 23:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbXDPDGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 23:06:23 -0400
Received: from THUNK.ORG ([69.25.196.29]:46314 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363AbXDPDGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 23:06:22 -0400
Date: Sun, 15 Apr 2007 23:05:11 -0400
From: Theodore Tso <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070416030511.GC27533@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Neil Brown <neilb@suse.de>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <17947.65165.569482.976343@notabene.brown> <20070411144252.GB17778@thunk.org> <17949.25061.739035.688232@notabene.brown> <20070411232224.GF17778@thunk.org> <17949.36737.701327.104172@notabene.brown> <20070412023712.GA8175@lazybastard.org> <17949.51797.386833.917451@notabene.brown> <20070412122116.GD28148@thunk.org> <20070412171831.GD3028@fieldses.org> <461E6DF5.6040808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461E6DF5.6040808@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 10:35:49AM -0700, H. Peter Anvin wrote:
> J. Bruce Fields wrote:
> >On Thu, Apr 12, 2007 at 08:21:16AM -0400, Theodore Tso wrote:
> >>Again, compared to a directory fd cache, what you're proposing a huge
> >>hit to the filesystem, and at the moment, given that telldir/seekdir
> >>is rarely used by everyone else, it's mainly NFS which is the main bad
> >>actor here by insisting on the use of a small 31/63-bit cookie as a
> >>condition of protocol correctness.
> >
> >If we want to get bigger cookies into the protocol, then the sooner we
> >start working on that the better....  How big is big enough?  And is a
> >larger cookie sufficient on its own?
> >
> 
> Any fixed size is too small.  It should be a dynamic size.

Idally it should be dynamic, but my guess is that if the cookie were a
fixed 256 bits, it would be sufficient for pretty much all filesystems.  

						- Ted

