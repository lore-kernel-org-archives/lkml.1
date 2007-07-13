Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbXGMLAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbXGMLAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbXGMLAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:00:22 -0400
Received: from brick.kernel.dk ([80.160.20.94]:3451 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbXGMLAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:00:21 -0400
Date: Fri, 13 Jul 2007 13:00:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: On current git head webservers stopped working
Message-ID: <20070713110005.GE5328@kernel.dk>
References: <469745A8.6010005@googlemail.com> <20070713093459.GB5328@kernel.dk> <46974ABF.9030408@googlemail.com> <20070713100057.GD5328@kernel.dk> <20070713100518.GF16304@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713100518.GF16304@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13 2007, Christoph Hellwig wrote:
> On Fri, Jul 13, 2007 at 12:00:58PM +0200, Jens Axboe wrote:
> > On Fri, Jul 13 2007, Gabriel C wrote:
> > > Jens Axboe wrote:
> > > > On Fri, Jul 13 2007, Gabriel C wrote:
> > > >   
> > > >> Hello ,
> > > >>
> > > >> While doing some tests with 2.6.22-git2 ( at the time head
> > > >> 4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4 ) all my webservers stopped
> > > >> working.
> > > >> I can't get any file using wget or whatever else , everything hangs
> > > >> after 1% forever.
> > > >>
> > > >> I bisected this and here the result:
> > > >>
> > > >> 534f2aaa6ab07cd71164180bc958a7dcde41db11 is first bad commit
> > > >> commit 534f2aaa6ab07cd71164180bc958a7dcde41db11
> > > >> Author: Jens Axboe <jens.axboe@oracle.com>
> > > >> Date:   Fri Jun 1 14:52:37 2007 +0200
> > > >>
> > > >>     sys_sendfile: switch to using ->splice_read, if available
> > > >>
> > > >>     This patch makes sendfile prefer to use ->splice_read(), if it's
> > > >>     available in the file_operations structure.
> > > >>
> > > >>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > >>
> > > >> :040000 040000 b19013793692eee0f632b3703dca0bd40cea753f
> > > >> ed50576c0d3f0d3ce9f1a2ac9336d1164b45f63f M      fs
> > > >>     
> > > >
> > > > Does this work?
> > > >   
> > > 
> > > Yes , it does. Thx :)
> > 
> > Great, I'll polish it a bit and get it upstream asap. Thanks for the
> > report and quick test feedback!
> 
> Any chance someone could hack up a ltp testcase for this?

Certainly, I already created a private test case for it anyway.

-- 
Jens Axboe

