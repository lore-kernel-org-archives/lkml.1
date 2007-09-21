Return-Path: <linux-kernel-owner+w=401wt.eu-S932475AbXIUVEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbXIUVEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765714AbXIUU74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:59:56 -0400
Received: from canuck.infradead.org ([209.217.80.40]:33186 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762567AbXIUU7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:59:55 -0400
Date: Fri, 21 Sep 2007 14:00:02 -0700
From: Greg KH <greg@kroah.com>
To: Werner Cornelius <Werner.Cornelius@cornelius-consult.de>
Cc: linux-kernel@vger.kernel.org, mtosatti@redhat.com
Subject: Re: [PATCH] Re: Serial USB-driver for Winchiphead CH340/41 chip
Message-ID: <20070921210002.GA15243@kroah.com>
References: <200709141438.55147.Werner.Cornelius@cornelius-consult.de> <200709211015.11470.Werner.Cornelius@cornelius-consult.de> <20070921161850.GA11771@kroah.com> <200709212234.11646.Werner.Cornelius@cornelius-consult.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709212234.11646.Werner.Cornelius@cornelius-consult.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:34:11PM +0200, Werner Cornelius wrote:
> Am Freitag, 21. September 2007 18:18 schrieb Greg KH:
> > > --- linux-2.6.23-rc6-mm1/drivers/usb/serial/ch341.c	2007-09-21
> > > 09:56:56.000000000 +0200
> > > +++ develop/drivers/usb/serial/ch341.c	2007-09-21 10:00:26.000000000
> > > +0200 @@ -1,5 +1,9 @@
> > >  /*
> > > - * Copyright 2007, Frank A Kingswood <frank@kingswood-consulting.co.uk>
> > > + * Copyright 2007, Frank A Kingswood <frank <at>
> > > kingswood-consulting.co.uk>
> >
> > Why did you change this email address?
> 
> This address was in the original file I got from the net. Perhaps this file 
> have had spaces instead of tabs, too.

No, I was referring to the fact that you change the email address to
have a "<at> instead of a "@".

> > > + *
> > > + * Copyright 2007, Werner Cornelius <werner <at> cornelius-consult.de>
> > > + * for changes/extenions regarding universal baud rate capability and
> > > modem + * line control/status routines.
> >
> > Don't put changelog information in a copyright notice, that's not
> > needed.  Just put your name there please, with a "real" email address.
> 
> Ok. that should be ok. I am not used to the rules on the kernel traffic list.
> 
> >
> > And we need a "Signed-off-by:" line.
> 
> I did add one on last request.
> Was this wrong ?
> Perhaps I need an Howto about mailing to kernel list. I read the main 
> documentation, but didn't found this amount of request rules in a way that 
> would be sufficient to publish a patch which I just wanted to make useable by 
> the whole community.

Take a look at the files, Documentation/HOWTO and
Documentation/SubmittingPatches for how to do this correctly.  Those
files should help you out.

thanks,

greg k-h
