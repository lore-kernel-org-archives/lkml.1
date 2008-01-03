Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbYACXKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbYACXKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYACXKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:10:32 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:34748 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbYACXKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:10:32 -0500
Date: Fri, 4 Jan 2008 00:10:30 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Tomas Carnecky <tom@dbservice.com>
Cc: Andy Whitcroft <apw@uk.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] teach checkpatch.pl about list_for_each
Message-ID: <20080104001030.05b90834@weinigel.se>
In-Reply-To: <477CD665.9050102@dbservice.com>
References: <20071202130335.690a8daf@cw05lap>
	<477CD665.9050102@dbservice.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jan 2008 13:34:45 +0100
Tomas Carnecky <tom@dbservice.com> wrote:

> Christer Weinigel wrote:
> > By the way, what is the consensus on lines over 80 characters?
> > checkpatch complains about the following:
> > 
> > WARNING: line over 80 characters
> > #762: FILE: drivers/spi/spi_s3c24xx_dma.c:720:
> > +       printk(KERN_INFO "S3C24xx SPI DMA driver (c) 2007 Nordnav
> > Technologies AB\n");
> > 
> > I can of course break this into:
> > 
> >         printk(KERN_INFO "S3C24xx SPI DMA driver (c) 2007 Nordnav "
> > 	       "Technologies AB\n");
> > 
> > but in my opinion that becomes more even unreadable.  Would it be
> > possible to add a special case so that checkpatch ignores long
> > strings that go beyond 80 characters?  Do you think it is a good
> > idea?
> 
> At the top of the file add a #define and use that in the code? Some 
> drivers define their version/author etc that way and then just
> printk(DRIVER_VERSION DRIVER_AUTHOR);

That only solves this specific problem.  For debugging printks, which
often become quite wide, it would make the code even more unreadable to
add lots of defines just to keep things within 80 cols.

  /Christer
