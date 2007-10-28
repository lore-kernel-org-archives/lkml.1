Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbXJ1HIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbXJ1HIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 03:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbXJ1HIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 03:08:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40442 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbXJ1HIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 03:08:17 -0400
Date: Sun, 28 Oct 2007 00:10:49 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Message-ID: <20071028071049.GD8933@kroah.com>
References: <1193412788.2431.22.camel@lov.site> <1193412836.27652.11.camel@twins> <1193414147.2431.35.camel@lov.site> <1193429066.5648.35.camel@lappy> <1193447889.5648.44.camel@lappy> <20071027024033.GB29039@kroah.com> <1193474399.27652.15.camel@twins> <20071027160203.GA5709@kroah.com> <1193519317.5776.14.camel@lov.site> <1193520945.27652.36.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193520945.27652.36.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 11:35:45PM +0200, Peter Zijlstra wrote:
> On Sat, 2007-10-27 at 23:08 +0200, Kay Sievers wrote:
> > All this open-coded attribute stuff should go away and be replaced by:
> >   bdi_class->dev_attrs = bdi_dev_attrs;
> > Otherwise at event time the attributes are not created and stuff hooking
> > into the events will not be able to set values. Also, the core will do
> > proper add/remove and error handling then.
> 
> ok, that's good to know. someone ought to write a book on how to use all
> this... really, even the functions are bare of documentation or
> comments.

Yes, I know, sorry :(

I'm working on cleaning up the apis a lot right now, so hopefully, in a
few months things will have settled down.  I'm trying to document things
as I go, but right now I'm stuck at a much lower level (ksets and
friends...)

thanks,

greg k-h
