Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbXDIM3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbXDIM3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 08:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbXDIM3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 08:29:50 -0400
Received: from pat.uio.no ([129.240.10.15]:51137 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbXDIM3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 08:29:49 -0400
Subject: Re: If not readdir() then what?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
In-Reply-To: <20070409110927.GA23240@lazybastard.org>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	 <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org>
	 <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org>
	 <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>
	 <20070409014426.GA18580@thunk.org> <20070409110927.GA23240@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 09 Apr 2007 08:29:29 -0400
Message-Id: <1176121769.6210.5.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 8BIT
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.050)
X-UiO-Scanned: 07517EA8B3239AEBB57779201F8DAC211D04F597
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 353 total 936234 max/h 7466 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 13:09 +0200, Jörn Engel wrote:
> That surely doesn't make life any easier for filesystem developers, I
> agree.  From that point of view, all telldir cookies should end their
> life at closedir time.  For "rm -r" it would be sufficient if the nfs
> client simply didn't seekdir at all.  For "ls -lR", this would return
> duplicate dentries.

Please go read the NFS spec. The only thing an NFS client has in order
to read a directory is a READDIR operation that in essence takes a
filehandle and a cookie as its arguments. Unless the server is able to
return the entire directory in one RPC reply, the client That is a
protocol limitation, not a client limitation.

Trond

