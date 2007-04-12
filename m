Return-Path: <linux-kernel-owner+w=401wt.eu-S1030573AbXDLRTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573AbXDLRTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030574AbXDLRS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:18:59 -0400
Received: from mail.fieldses.org ([66.93.2.214]:52244 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030573AbXDLRS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:18:59 -0400
Date: Thu, 12 Apr 2007 13:18:31 -0400
To: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070412171831.GD3028@fieldses.org>
References: <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <17947.65165.569482.976343@notabene.brown> <20070411144252.GB17778@thunk.org> <17949.25061.739035.688232@notabene.brown> <20070411232224.GF17778@thunk.org> <17949.36737.701327.104172@notabene.brown> <20070412023712.GA8175@lazybastard.org> <17949.51797.386833.917451@notabene.brown> <20070412122116.GD28148@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412122116.GD28148@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 08:21:16AM -0400, Theodore Tso wrote:
> Again, compared to a directory fd cache, what you're proposing a huge
> hit to the filesystem, and at the moment, given that telldir/seekdir
> is rarely used by everyone else, it's mainly NFS which is the main bad
> actor here by insisting on the use of a small 31/63-bit cookie as a
> condition of protocol correctness.

If we want to get bigger cookies into the protocol, then the sooner we
start working on that the better....  How big is big enough?  And is a
larger cookie sufficient on its own?

--b.
