Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbZLGAhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbZLGAhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934543AbZLGAhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:37:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758384AbZLGAh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:37:28 -0500
Date: Sun, 6 Dec 2009 16:37:19 -0800
From: Greg KH <gregkh@suse.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [000/119] 2.6.31.7-stable review
Message-ID: <20091207003719.GA25687@suse.de>
References: <20091207000938.GA24743@kroah.com>
 <20091207001058.GA24769@kroah.com>
 <a4423d670912061633gbf9340cyade3a057d631ed8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4423d670912061633gbf9340cyade3a057d631ed8e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:33:37AM +0300, Alexander Beregalov wrote:
> 2009/12/7 Greg KH <greg@kroah.com>:
> > On Sun, Dec 06, 2009 at 04:09:38PM -0800, Greg KH wrote:
> >> This is the start of the stable review cycle for the 2.6.31.7 release.
> >> There are @num@ patches in this series, all will be posted as a response
> >
> > There are 119 patches, doh...
> >
> >> to this one.  If anyone has any issues with these being applied, please
> >> let us know.  If anyone is a maintainer of the proper subsystem, and
> >> wants to add a Signed-off-by: line to the patch, please respond with it.
> >
> > Oh, also, just for those keeping score, this _only_ includes patches
> > that went into Linus's tree for the 2.6.32 release.  There have already
> > been a number of -stable patches that went in after 2.6.32 was released,
> > as part of the 2.6.33 release cycle.  They will be handled in future
> > releases of .31, but not this one, it's big enough.
> 
> Greg, could you please add this fix of NULL pointer dereference.
> The driver is broken in 2.6.30 and 2.6.31, but since you do not
> support 2.6.30 anymore,
> let it be in 2.6.31 only.
> 
> commit 63edaf647607795a065e6956a79c47f500dc8447
> Author: Alexander Beregalov <a.beregalov@gmail.com>
> Date:   Sun Nov 22 20:40:52 2009 -0800
> 
>     Au1x00: fix crash when trying register_netdev()
> 
>     Andreas Lohre reported that the driver crashes when trying
>     to register_netdev(), he sugessted to move dev->netdev_ops initialization
>     before calling register_netdev(), it worked for him.
> 
>     Reported-by: Andreas Lohre <alohre@gmail.com>
>     Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

I will be glad to queue it up for the next round, 119 patches is already
pretty big for one release :)

thanks,

greg k-h
