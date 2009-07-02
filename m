Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbZGBUR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbZGBUR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZGBUQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:16:26 -0400
Received: from kroah.org ([198.145.64.141]:38497 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbZGBUQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:16:25 -0400
Date: Thu, 2 Jul 2009 13:06:35 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 16/19] drivers/staging: Use PCI_VDEVICE
Message-ID: <20090702200635.GI10957@kroah.com>
References: <cover.1245906151.git.joe@perches.com>
 <127986351d52895b618ad6bc31a704bc34ef2d97.1245906153.git.joe@perches.com>
 <4A438898.8030007@gmail.com>
 <1245941596.395.33.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245941596.395.33.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 07:53:16AM -0700, Joe Perches wrote:
> On Thu, 2009-06-25 at 16:24 +0200, Jiri Slaby wrote:
> > > --- a/drivers/staging/vt6655/device_main.c
> > > +++ b/drivers/staging/vt6655/device_main.c
> > > @@ -344,7 +344,7 @@ static CHIP_INFO chip_info_table[]= {
> > >  };
> > >  
> > >  static struct pci_device_id device_id_table[] __devinitdata = {
> > > -{ 0x1106, 0x3253, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (int)&chip_info_table[0]},
> > > +{ PCI_VDEVICE(VIA, 0x3253), (int)&chip_info_table[0]},
> > 
> > Hmm, pointer chopped to 4 bytes on 64-bit. Could you fix that up too?
> 
> In addition to original patch

Can you send a new patch with this merged together?

thanks,

greg k-h
