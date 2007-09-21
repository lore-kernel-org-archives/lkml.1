Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbXIUQah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbXIUQah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXIUQaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:30:30 -0400
Received: from canuck.infradead.org ([209.217.80.40]:50374 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXIUQaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:30:30 -0400
Date: Fri, 21 Sep 2007 09:18:50 -0700
From: Greg KH <greg@kroah.com>
To: Werner Cornelius <Werner.Cornelius@cornelius-consult.de>
Cc: linux-kernel@vger.kernel.org, mtosatti@redhat.com
Subject: Re: [PATCH] Re: Serial USB-driver for Winchiphead CH340/41 chip
Message-ID: <20070921161850.GA11771@kroah.com>
References: <200709141438.55147.Werner.Cornelius@cornelius-consult.de> <20070920000336.GA17357@kroah.com> <200709211015.11470.Werner.Cornelius@cornelius-consult.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709211015.11470.Werner.Cornelius@cornelius-consult.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:15:11AM +0200, Werner Cornelius wrote:
> Hello,
> 
> attached you will find the patch against the 2.6.23-rc6-mm1
> 
> Changed fetaures:
> 
> 1. All baudrates possible (dynamic baudfactor calculation)
> 2. Added support of modem control and status lines.

You forgot:
	3. broke all formatting

:(

Please redo the patch such that the formating of the file is not changed
(you converted tabs to spaces).

> --- linux-2.6.23-rc6-mm1/drivers/usb/serial/ch341.c	2007-09-21 
> 09:56:56.000000000 +0200
> +++ develop/drivers/usb/serial/ch341.c	2007-09-21 10:00:26.000000000 +0200
> @@ -1,5 +1,9 @@
>  /*
> - * Copyright 2007, Frank A Kingswood <frank@kingswood-consulting.co.uk>
> + * Copyright 2007, Frank A Kingswood <frank <at> kingswood-consulting.co.uk>

Why did you change this email address?

> + *
> + * Copyright 2007, Werner Cornelius <werner <at> cornelius-consult.de>
> + * for changes/extenions regarding universal baud rate capability and modem
> + * line control/status routines. 

Don't put changelog information in a copyright notice, that's not
needed.  Just put your name there please, with a "real" email address.

And we need a "Signed-off-by:" line.

thanks,

greg k-h
