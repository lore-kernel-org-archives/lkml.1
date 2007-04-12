Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXDLRiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXDLRiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXDLRiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:38:19 -0400
Received: from terminus.zytor.com ([192.83.249.54]:58380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXDLRiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:38:18 -0400
Message-ID: <461E6DF5.6040808@zytor.com>
Date: Thu, 12 Apr 2007 10:35:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
References: <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <17947.65165.569482.976343@notabene.brown> <20070411144252.GB17778@thunk.org> <17949.25061.739035.688232@notabene.brown> <20070411232224.GF17778@thunk.org> <17949.36737.701327.104172@notabene.brown> <20070412023712.GA8175@lazybastard.org> <17949.51797.386833.917451@notabene.brown> <20070412122116.GD28148@thunk.org> <20070412171831.GD3028@fieldses.org>
In-Reply-To: <20070412171831.GD3028@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Thu, Apr 12, 2007 at 08:21:16AM -0400, Theodore Tso wrote:
>> Again, compared to a directory fd cache, what you're proposing a huge
>> hit to the filesystem, and at the moment, given that telldir/seekdir
>> is rarely used by everyone else, it's mainly NFS which is the main bad
>> actor here by insisting on the use of a small 31/63-bit cookie as a
>> condition of protocol correctness.
> 
> If we want to get bigger cookies into the protocol, then the sooner we
> start working on that the better....  How big is big enough?  And is a
> larger cookie sufficient on its own?
> 

Any fixed size is too small.  It should be a dynamic size.

	-hpa
