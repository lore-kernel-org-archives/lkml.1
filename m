Return-Path: <linux-kernel-owner+w=401wt.eu-S1762564AbXIUUeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762564AbXIUUeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbXIUUeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:34:11 -0400
Received: from mail.titro.de ([212.23.132.190]:1872 "EHLO mail.titro.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178AbXIUUeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:34:10 -0400
From: Werner Cornelius <Werner.Cornelius@cornelius-consult.de>
Organization: Cornelius Consult
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Re: Serial USB-driver for Winchiphead CH340/41 chip
Date: Fri, 21 Sep 2007 22:34:11 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, mtosatti@redhat.com
References: <200709141438.55147.Werner.Cornelius@cornelius-consult.de> <200709211015.11470.Werner.Cornelius@cornelius-consult.de> <20070921161850.GA11771@kroah.com>
In-Reply-To: <20070921161850.GA11771@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212234.11646.Werner.Cornelius@cornelius-consult.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 21. September 2007 18:18 schrieb Greg KH:

Hello,

> On Fri, Sep 21, 2007 at 10:15:11AM +0200, Werner Cornelius wrote:
> > Hello,
> >
> > attached you will find the patch against the 2.6.23-rc6-mm1
> >
> > Changed fetaures:
> >
> > 1. All baudrates possible (dynamic baudfactor calculation)
> > 2. Added support of modem control and status lines.
>
> You forgot:
> 	3. broke all formatting

sorry about, but that wasn't an intend.
This action has been done by one or more of the apps I am using (editor, 
mailer...). I assume it is a feature of Kmail, inserting plane text seems to 
be converted to space separated text, discarding tabs.  

>
> :(
>
> Please redo the patch such that the formating of the file is not changed
> (you converted tabs to spaces).
>
> > --- linux-2.6.23-rc6-mm1/drivers/usb/serial/ch341.c	2007-09-21
> > 09:56:56.000000000 +0200
> > +++ develop/drivers/usb/serial/ch341.c	2007-09-21 10:00:26.000000000
> > +0200 @@ -1,5 +1,9 @@
> >  /*
> > - * Copyright 2007, Frank A Kingswood <frank@kingswood-consulting.co.uk>
> > + * Copyright 2007, Frank A Kingswood <frank <at>
> > kingswood-consulting.co.uk>
>
> Why did you change this email address?

This address was in the original file I got from the net. Perhaps this file 
have had spaces instead of tabs, too.

>
> > + *
> > + * Copyright 2007, Werner Cornelius <werner <at> cornelius-consult.de>
> > + * for changes/extenions regarding universal baud rate capability and
> > modem + * line control/status routines.
>
> Don't put changelog information in a copyright notice, that's not
> needed.  Just put your name there please, with a "real" email address.

Ok. that should be ok. I am not used to the rules on the kernel traffic list.

>
> And we need a "Signed-off-by:" line.

I did add one on last request.
Was this wrong ?
Perhaps I need an Howto about mailing to kernel list. I read the main 
documentation, but didn't found this amount of request rules in a way that 
would be sufficient to publish a patch which I just wanted to make useable by 
the whole community.
I will try to verify how I could generate the patch in a way that it might be 
acceptable.

>
> thanks,
>
> greg k-h

Werner
