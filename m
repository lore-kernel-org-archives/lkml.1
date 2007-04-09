Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbXDIQnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbXDIQnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbXDIQnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:43:06 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:56751 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbXDIQnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:43:03 -0400
Date: Mon, 9 Apr 2007 18:34:35 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
In-Reply-To: <1176127395.6210.34.camel@heimdal.trondhjem.org>
Message-ID: <Pine.LNX.4.61.0704091829240.21426@yvahk01.tjqt.qr>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> 
 <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> 
 <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> 
 <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com> 
 <20070409014426.GA18580@thunk.org> <20070409110927.GA23240@lazybastard.org>
  <1176121897.6210.8.camel@heimdal.trondhjem.org>  <20070409131918.GC18580@thunk.org>
 <1176127395.6210.34.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 9 2007 10:03, Trond Myklebust wrote:

>In practice, though, this sort of behaviour has to be managed carefully
>by the server. Forcing a client to re-read the entire contents of the
>directory doesn't really scale too well...

What does the spec (readdir, and NFS READDIR) say about duplicate entries,
and what's done in practice?
Actually, I'd be more concerned about code that does

while(d = readdir(...))
    append_a_line_to(d);

(which would be not-so-good on duplicate entries), rather than
bad scaling.


Jan
-- 
