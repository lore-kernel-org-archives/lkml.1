Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbXIRJfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbXIRJfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbXIRJfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:35:13 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2935 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbXIRJfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:35:12 -0400
Date: Tue, 18 Sep 2007 10:34:44 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070918093444.GB973@shadowen.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46EF96CC.1080807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EF96CC.1080807@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 02:43:48PM +0530, Kamalesh Babulal wrote:
> Andrew Morton wrote:
> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> >
> >2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
> >
> >  
> <snip>
> 
> Hi Andrew,
> 
> The 2.6.23-rc6-mm1build fails at
> 
>  CC      drivers/pci/hotplug/rpadlpar_core.o
>  CC      drivers/pci/hotplug/rpadlpar_sysfs.o
> drivers/pci/hotplug/rpadlpar_sysfs.c:132: error: unknown field `name' 
> specified in initializer
> drivers/pci/hotplug/rpadlpar_sysfs.c: In function `dlpar_sysfs_init':
> drivers/pci/hotplug/rpadlpar_sysfs.c:142: error: structure has no member 
> named `name'
> make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> make[2]: *** [drivers/pci/hotplug] Error 2
> make[1]: *** [drivers/pci] Error 2
> make: *** [drivers] Error 2

This seems to be occuring across a number of the powerpc systems we test
with.  That driver is a power dynamic lpar IO partitioning driver.

Relevant Cc: added.

-apw
