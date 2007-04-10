Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbXDJVRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbXDJVRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbXDJVRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:17:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60309 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbXDJVRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:17:33 -0400
Message-ID: <461BFEBA.3050608@zytor.com>
Date: Tue, 10 Apr 2007 14:16:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>, Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
References: <20070407233037.GA16508@infradead.org>	<46193048.6000606@zytor.com>	<20070408184129.GA20871@lazybastard.org>	<20070408191955.GD29180@thunk.org>	<46194260.3050900@zytor.com>	<20070409014426.GA18580@thunk.org>	<20070409110927.GA23240@lazybastard.org>	<1176121897.6210.8.camel@heimdal.trondhjem.org>	<20070409131918.GC18580@thunk.org>	<1176127395.6210.34.camel@heimdal.trondhjem.org>	<20070410135641.GG13650@thunk.org>	<1176215836.14442.37.camel@heimdal.trondhjem.org> <17947.64947.649081.411561@notabene.brown>
In-Reply-To: <17947.64947.649081.411561@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Tuesday April 10, trond.myklebust@fys.uio.no wrote:
>> The problem is that it is extremely hard to come up with an alternative
>> that doesn't impose new conditions on what filesystems you can support.
> 
> I seem to remember Hans Reiser making a credible suggestion years ago
> when NFSv4 was still in draft.  It didn't fly, but I don't really
> remember why.
> 
> The NFS server gets to either return a cookie like it currently does,
> or sets a flag (or maybe returns a special cookie) which says 'just
> use the name'.
> A READDIR request contains either a cookie or a filename.  Either mean
> "This identifies the last name I got from you, give me the next one".
> 
> Is there something that makes that interface problematic?

Seems like it would simply make more sense for the server to be allowed 
to determine what the size of the cookie should be.

Of course, that doesn't help NFSv2/3/4.0.

	-hpa
