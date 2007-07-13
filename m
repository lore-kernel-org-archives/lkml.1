Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbXGMLMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbXGMLMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbXGMLLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:11:53 -0400
Received: from brick.kernel.dk ([80.160.20.94]:22711 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbXGMLLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:11:52 -0400
Date: Fri, 13 Jul 2007 13:11:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: On current git head webservers stopped working
Message-ID: <20070713111136.GG5328@kernel.dk>
References: <469745A8.6010005@googlemail.com> <20070713093459.GB5328@kernel.dk> <46974ABF.9030408@googlemail.com> <20070713100057.GD5328@kernel.dk> <46974F76.9070909@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46974F76.9070909@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13 2007, Gabriel C wrote:
> Jens Axboe wrote:
> > On Fri, Jul 13 2007, Gabriel C wrote:
> >   
> >> Jens Axboe wrote:
> >>     
> >>> On Fri, Jul 13 2007, Gabriel C wrote:
> >>>   
> >>>       
> >>>> Hello ,
> >>>>
> >>>> While doing some tests with 2.6.22-git2 ( at the time head
> >>>> 4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4 ) all my webservers stopped
> >>>> working.
> >>>> I can't get any file using wget or whatever else , everything hangs
> >>>> after 1% forever.
> >>>>
> >>>> I bisected this and here the result:
> >>>>
> >>>> 534f2aaa6ab07cd71164180bc958a7dcde41db11 is first bad commit
> >>>> commit 534f2aaa6ab07cd71164180bc958a7dcde41db11
> >>>> Author: Jens Axboe <jens.axboe@oracle.com>
> >>>> Date:   Fri Jun 1 14:52:37 2007 +0200
> >>>>
> >>>>     sys_sendfile: switch to using ->splice_read, if available
> >>>>
> >>>>     This patch makes sendfile prefer to use ->splice_read(), if it's
> >>>>     available in the file_operations structure.
> >>>>
> >>>>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> >>>>
> >>>> :040000 040000 b19013793692eee0f632b3703dca0bd40cea753f
> >>>> ed50576c0d3f0d3ce9f1a2ac9336d1164b45f63f M      fs
> >>>>     
> >>>>         
> >>> Does this work?
> >>>   
> >>>       
> >> Yes , it does. Thx :)
> >>     
> >
> > Great, I'll polish it a bit and get it upstream asap. Thanks for the
> > report and quick test feedback!
> >
> >   
> 
> You are welcome :)
> 
> If you want me to test the final version of this patch before you push
> it upstream just ping me.

Thanks, I wrote a small test case though, so hopefully I'll be ok from
now though.

-- 
Jens Axboe

