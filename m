Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbXDJVnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbXDJVnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbXDJVnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:43:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbXDJVnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:43:19 -0400
From: Neil Brown <neilb@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 11 Apr 2007 07:43:14 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17948.1266.13007.69593@notabene.brown>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: message from H. Peter Anvin on Tuesday April 10
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
	<17947.64947.649081.411561@notabene.brown>
	<461BFEBA.3050608@zytor.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday April 10, hpa@zytor.com wrote:
> 
> Seems like it would simply make more sense for the server to be allowed 
> to determine what the size of the cookie should be.

That is one possibility.  but if the cookie gets too big, you
substantially reduce the number of entries you can fit in a single
reply.  And if you choose to use the filename as the cookie, you end
up sending the filename twice for each entry, which seems somewhat
pointless. 

> 
> Of course, that doesn't help NFSv2/3/4.0.

No.  And while we can probably deprecate support for NFSv2 (at least
in newer filesystems) I think it will be quite some years before we
can think about doing the same for v3 (in fact we can probably
deprecate 4.0 and 4.1 before v3 :-)
So while it doesn't hurt to plan for the longer-term future, I think
we need to accept that over the next 5 years, filesystems needs to
cope with 64bit dir-entry cookies to be generally useful.

NeilBrown
