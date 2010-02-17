Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab0BQXSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 18:18:17 -0500
Received: from kroah.org ([198.145.64.141]:43022 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753Ab0BQXSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 18:18:14 -0500
Date: Wed, 17 Feb 2010 14:59:35 -0800
From: Greg KH <greg@kroah.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       p.hardwick@option.com
Subject: Re: [PATCH 3/3] nozomi: Tidy up the PCI table
Message-ID: <20100217225935.GE31557@kroah.com>
References: <20100208100642.2794.73225.stgit@localhost.localdomain>
 <20100208100710.2794.73323.stgit@localhost.localdomain>
 <1265626189.31341.260.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265626189.31341.260.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 11:49:49AM +0100, Marcel Holtmann wrote:
> Hi Alan,
> 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > ---
> > 
> >  drivers/char/nozomi.c |    6 +-----
> >  1 files changed, 1 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
> > index fac9157..86c9e64 100644
> > --- a/drivers/char/nozomi.c
> > +++ b/drivers/char/nozomi.c
> > @@ -136,10 +136,6 @@ static int debug;
> >  #define RECEIVE_BUF_MAX		4
> >  
> > 
> > -/* Define all types of vendors and devices to support */
> > -#define VENDOR1		0x1931	/* Vendor Option */
> > -#define DEVICE1		0x000c	/* HSDPA card */
> > -
> >  #define R_IIR		0x0000	/* Interrupt Identity Register */
> >  #define R_FCR		0x0000	/* Flow Control Register */
> >  #define R_IER		0x0004	/* Interrupt Enable Register */
> > @@ -407,7 +403,7 @@ struct buffer {
> >  
> >  /*    Global variables */
> >  static const struct pci_device_id nozomi_pci_tbl[] __devinitconst = {
> > -	{PCI_DEVICE(VENDOR1, DEVICE1)},
> > +	{PCI_DEVICE(0x1931, 0x000c)},	/* Nozomi HSPDA */
> >  	{},
> 
> that would be HSDPA actually.

I edited the patch, thanks.

greg k-h
