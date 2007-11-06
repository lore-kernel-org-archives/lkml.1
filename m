Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbXKFVGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbXKFVGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbXKFVGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:06:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbXKFVGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:06:08 -0500
Date: Tue, 6 Nov 2007 13:05:18 -0800
From: Greg KH <gregkh@suse.de>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded -
	build failure - rpadlpar_sysfs
Message-ID: <20071106210518.GA5936@suse.de>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org> <4730896A.9060701@linux.vnet.ibm.com> <1194373168.25901.3.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194373168.25901.3.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 10:19:28AM -0800, Badari Pulavarty wrote:
> On Tue, 2007-11-06 at 21:04 +0530, Kamalesh Babulal wrote:
> > Hi Andrew,
> > 
> > The build fails with following error
> >  
> >   CC      drivers/pci/hotplug/rpadlpar_sysfs.o
> > drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: initializer element is not constant
> > drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: (near initialization for `dlpar_io_kset.kobj.parent')
> > drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: initializer element is not constant
> > drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: (near initialization for `dlpar_io_kset.kobj')
> > drivers/pci/hotplug/rpadlpar_sysfs.c:134: error: unknown field `ktype' specified in initializer
> > drivers/pci/hotplug/rpadlpar_sysfs.c:134: warning: initialization from incompatible pointer type
> > make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> > make[2]: *** [drivers/pci/hotplug] Error 2
> > make[1]: *** [drivers/pci] Error 2
> > make: *** [drivers] Error 2
> > 
> > The patch, gregkh-driver-kset-convert-pci-hotplug-to-use-kset_create_and_register.patch
> > is causing the build failure.
> 
> Here is the fix (against 24-rc1 mm-brokenout). Can you try it ?

Yes, it will fix the basic build issue, but not the "my $DIETY, what are
you doing there!!!" type problem.  I'll go work on that...

thanks,

greg k-h
