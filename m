Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbZD0Qhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbZD0Qhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbZD0QhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:37:21 -0400
Received: from smtp6.welho.com ([213.243.153.40]:36749 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbZD0QhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:37:21 -0400
Date: Mon, 27 Apr 2009 19:37:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] usb/storage/usual-tables.c: add MODULE_LICENSE
Message-ID: <20090427163752.GA24310@localhost.pp.htv.fi>
References: <20090427093301.GC9259@localhost.pp.htv.fi> <20090427152819.GD23851@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090427152819.GD23851@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 08:28:19AM -0700, Greg KH wrote:
> On Mon, Apr 27, 2009 at 12:33:01PM +0300, Adrian Bunk wrote:
> > This patch adds the missing MODULE_LICENSE("GPL").
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > ---
> > 
> > diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
> > index 468bde7..d62ea8f 100644
> > --- a/drivers/usb/storage/usual-tables.c
> > +++ b/drivers/usb/storage/usual-tables.c
> > @@ -114,3 +114,5 @@ int usb_usual_ignore_device(struct usb_interface *intf)
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(usb_usual_ignore_device);
> > +
> > +MODULE_LICENSE("GPL");
> 
> Why is this needed?  This .c file gets built into either the libusual
> module, or the usb-storage module, both of which have module licenses,
> right?

My fault, I ran into it some time ago, and missed that the actual 
problem was fixed by commit dfc15e8955338fedf5c5d15622c4042c1e4ee332

> confused,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

