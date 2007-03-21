Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbXCUShw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbXCUShw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933414AbXCUShv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:37:51 -0400
Received: from mx1.suse.de ([195.135.220.2]:55965 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933365AbXCUShv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:37:51 -0400
Date: Wed, 21 Mar 2007 11:36:08 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070321183608.GA30256@kroah.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320184704.8fd1bc64.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320184704.8fd1bc64.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 06:47:04PM -0700, Randy Dunlap wrote:
> On Mon, 19 Mar 2007 20:56:23 -0800 Andrew Morton wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> 
> 
> UIO_CIF should depend on PCI ??
> 
> With CONFIG_PCI=n, I get:
> 
> ERROR: "pci_module_init" [drivers/uio/uio_cif.ko] undefined!
> ERROR: "pci_release_regions" [drivers/uio/uio_cif.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Thanks, I've made that change now.

greg k-h
