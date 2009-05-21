Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbZEUODx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbZEUODx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757041AbZEUODD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:03:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191AbZEUODB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:03:01 -0400
Date: Thu, 21 May 2009 06:55:31 -0700
From: Greg KH <gregkh@suse.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: comedidev should include delay.h
Message-ID: <20090521135531.GA29375@suse.de>
References: <1242911193-30469-1-git-send-email-a.beregalov@gmail.com> <alpine.LFD.2.00.0905210907440.3475@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0905210907440.3475@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 09:09:53AM -0400, Robert P. J. Day wrote:
> On Thu, 21 May 2009, Alexander Beregalov wrote:
> 
> > Fix many build errors like this:
> > comedi/drivers/adq12b.c:328: error: implicit declaration of function 'udelay'
> >
> > The same for aio_aio12_8.c, dmm32at.c and others.
> >
> > Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> > ---
> >  drivers/staging/comedi/comedidev.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> > index 7a1ccde..3d0e80c 100644
> > --- a/drivers/staging/comedi/comedidev.h
> > +++ b/drivers/staging/comedi/comedidev.h
> > @@ -38,6 +38,7 @@
> >  #include <linux/dma-mapping.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/io.h>
> > +#include <linux/delay.h>
> >
> >  #include "comedi.h"
> 
>   not sure it's worth noting but the header comedidev.h currently
> resides in the comedi directory itself, while the source file rt.c
> contains:
> 
> #include <linux/comedidev.h>
> 
> which doesn't seem right.

That's correct, and is one reason why rt.c is now gone in the linux-next
tree :)

thanks,

greg k-h
