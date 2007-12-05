Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbXLEQXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbXLEQXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXLEQXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:23:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbXLEQXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:23:20 -0500
Date: Wed, 5 Dec 2007 08:24:41 -0800
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] driver core: Introduce default attribute groups.
Message-ID: <20071205162441.GB9631@suse.de>
References: <20071205114119.905238262@de.ibm.com> <20071205125023.50f4c478@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205125023.50f4c478@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 12:50:23PM +0100, Cornelia Huck wrote:
> This is lot like default attributes for devices (and indeed,
> a lot of the code is lifted from there).
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> ---
>  drivers/base/driver.c  |   44 +++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/device.h |    2 ++
>  2 files changed, 45 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/base/driver.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/driver.c	2007-12-05 09:53:15.000000000 +0100
> +++ linux-2.6/drivers/base/driver.c	2007-12-05 12:41:02.000000000 +0100
> @@ -151,6 +151,39 @@ void put_driver(struct device_driver * d
>  	kobject_put(&drv->p->kobj);
>  }
>  
> +static int driver_add_groups(struct device_driver *drv,
> +			     struct attribute_group **groups)

Heh, I just added a driver_add_group() function, to fix up some other
ppc driver :)

I'll delete that and use this series instead, it's nicer.

thanks,

greg k-h
