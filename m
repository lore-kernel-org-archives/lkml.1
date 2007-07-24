Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbXGXQqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbXGXQqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXGXQqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:46:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40669 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbXGXQqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:46:01 -0400
Date: Tue, 24 Jul 2007 09:43:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Message-Id: <20070724094344.c3cabf31.akpm@linux-foundation.org>
In-Reply-To: <46A5F275.7060905@garzik.org>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<46A5E610.7000508@shadowen.org>
	<46A5F275.7060905@garzik.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 08:37:09 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> Andy Whitcroft wrote:
> > Andrew Morton wrote:
> > 
> >>> +	start_sector = req->sector*priv->blocking_factor;
> >>> +	sectors = req->nr_sectors*priv->blocking_factor;
> >> s/*/ * /.  checkpatch missed this.
> > 
> > Ok, this is something we need to decide on.  Currently we only ask for
> > consistent spacing on all the mathematic operators.  This is mostly as
> > we do see a large number of non-spaced uses in defines and the like.
> > 
> > I am happy to expand these tests so they are always spaced on both sides
> > style if that is the preference.
> 
> That is most definitely the preference:  spaces surround operators.
> 

I must say that I find it hard to object to

	start = radix_tree_next_hole(&mapping->page_tree, offset, max+1);

but when the expression is more complex the spaces help.
