Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbXBSLjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbXBSLjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXBSLjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:39:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53077 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143AbXBSLi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:38:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20-mm2: compilation fix
Date: Mon, 19 Feb 2007 12:33:20 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702190033.26285.rjw@sisk.pl> <20070218162917.602153af.akpm@linux-foundation.org>
In-Reply-To: <20070218162917.602153af.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702191233.21252.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 February 2007 01:29, Andrew Morton wrote:
> On Mon, 19 Feb 2007 00:33:26 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday, 18 February 2007 06:51, Andrew Morton wrote:
> > > 
> > > Temporarily at
> > > 
> > >   http://userweb.kernel.org/~akpm/2.6.20-mm2/
> > > 
> > > Will appear later at
> > > 
> > >  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/
> > 
> > I think something like this is generally necessary:
> > 
> > ---
> >  drivers/pci/quirks.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: linux-2.6.20-mm2/drivers/pci/quirks.c
> > ===================================================================
> > --- linux-2.6.20-mm2.orig/drivers/pci/quirks.c
> > +++ linux-2.6.20-mm2/drivers/pci/quirks.c
> > @@ -21,6 +21,7 @@
> >  #include <linux/init.h>
> >  #include <linux/delay.h>
> >  #include <linux/acpi.h>
> > +#include <asm/apicdef.h>
> >  #include "pci.h"
> >  
> >  /* The Mellanox Tavor device gives false positive parity errors
> 
> Will break all non-x86.

You're right, I should have put that somewhere under #ifdef

> What are we trying to fix here?

MAX_IO_APICS undefined.
