Return-Path: <linux-kernel-owner+w=401wt.eu-S1751131AbZHER4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbZHER4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 13:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZHER4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 13:56:09 -0400
Received: from kroah.org ([198.145.64.141]:53840 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbZHER4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 13:56:08 -0400
Date: Wed, 5 Aug 2009 10:55:05 -0700
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090805175505.GA6968@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <4A79C4A6.9000707@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A79C4A6.9000707@csr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 06:43:02PM +0100, David Vrabel wrote:
> Greg KH wrote:
> > 
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -929,6 +929,8 @@ int device_add(struct device *dev)
> >  		error = device_create_sys_dev_entry(dev);
> >  		if (error)
> >  			goto devtattrError;
> > +
> > +		devtmpfs_create_node(dev);
> >  	}
> >  
> >  	error = device_add_class_symlinks(dev);
> [...]
> > --- /dev/null
> > +++ b/drivers/base/devtmpfs.c
> [...]
> > +int devtmpfs_create_node(struct device *dev)
> 
> Returns an int that's never checked.  Is this intentional?
> 
> > +int devtmpfs_delete_node(struct device *dev)
> 
> Similarly.

Probably not, Kay, care to respin this?

thanks,

greg k-h
