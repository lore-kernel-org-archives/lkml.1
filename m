Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbXIRKES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbXIRKES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbXIRKEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:04:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:57129 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbXIRKEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:04:12 -0400
Subject: Re: 2.6.23-rc6-mm1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070918093444.GB973@shadowen.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <46EF96CC.1080807@linux.vnet.ibm.com>  <20070918093444.GB973@shadowen.org>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 20:02:51 +1000
Message-Id: <1190109772.6403.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 10:34 +0100, Andy Whitcroft wrote:
> On Tue, Sep 18, 2007 at 02:43:48PM +0530, Kamalesh Babulal wrote:
> > Andrew Morton wrote:
> > >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> > >
> > >2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
> > >
> > >  
> > <snip>
> > 
> > Hi Andrew,
> > 
> > The 2.6.23-rc6-mm1build fails at
> > 
> >  CC      drivers/pci/hotplug/rpadlpar_core.o
> >  CC      drivers/pci/hotplug/rpadlpar_sysfs.o
> > drivers/pci/hotplug/rpadlpar_sysfs.c:132: error: unknown field `name' 
> > specified in initializer
> > drivers/pci/hotplug/rpadlpar_sysfs.c: In function `dlpar_sysfs_init':
> > drivers/pci/hotplug/rpadlpar_sysfs.c:142: error: structure has no member 
> > named `name'
> > make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> > make[2]: *** [drivers/pci/hotplug] Error 2
> > make[1]: *** [drivers/pci] Error 2
> > make: *** [drivers] Error 2
> 
> This seems to be occuring across a number of the powerpc systems we test
> with.  That driver is a power dynamic lpar IO partitioning driver.
> 
> Relevant Cc: added.

That's because somebody is breaking sysfs/kobject interfaces without
fixing all users :-) (Fair enough... it's just that we need to make sure
whoever takes care of that driver nowadays is aware of the breakage).

Ben.


