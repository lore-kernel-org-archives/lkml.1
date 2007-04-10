Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbXDJVMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbXDJVMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbXDJVMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:12:49 -0400
Received: from mx1.suse.de ([195.135.220.2]:43294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbXDJVMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:12:47 -0400
From: Neil Brown <neilb@suse.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Date: Wed, 11 Apr 2007 07:12:19 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17947.64947.649081.411561@notabene.brown>
Cc: Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: message from Trond Myklebust on Tuesday April 10
References: <20070407233037.GA16508@infradead.org>
	<46193048.6000606@zytor.com>
	<20070408184129.GA20871@lazybastard.org>
	<20070408191955.GD29180@thunk.org>
	<46194260.3050900@zytor.com>
	<20070409014426.GA18580@thunk.org>
	<20070409110927.GA23240@lazybastard.org>
	<1176121897.6210.8.camel@heimdal.trondhjem.org>
	<20070409131918.GC18580@thunk.org>
	<1176127395.6210.34.camel@heimdal.trondhjem.org>
	<20070410135641.GG13650@thunk.org>
	<1176215836.14442.37.camel@heimdal.trondhjem.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday April 10, trond.myklebust@fys.uio.no wrote:
> The problem is that it is extremely hard to come up with an alternative
> that doesn't impose new conditions on what filesystems you can support.

I seem to remember Hans Reiser making a credible suggestion years ago
when NFSv4 was still in draft.  It didn't fly, but I don't really
remember why.

The NFS server gets to either return a cookie like it currently does,
or sets a flag (or maybe returns a special cookie) which says 'just
use the name'.
A READDIR request contains either a cookie or a filename.  Either mean
"This identifies the last name I got from you, give me the next one".

Is there something that makes that interface problematic?

NeilBrown
