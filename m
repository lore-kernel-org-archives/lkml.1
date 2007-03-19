Return-Path: <linux-kernel-owner+w=401wt.eu-S965461AbXCSXV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461AbXCSXV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965573AbXCSXV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:21:58 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:36217 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965461AbXCSXV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:21:58 -0400
X-Greylist: delayed 1229 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2007 19:21:57 EDT
Subject: Re: 2.6.21-rc3-mm2
From: Kay Sievers <kay.sievers@vrfy.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       gregkh <greg@kroah.com>
In-Reply-To: <20070319125558.235b3992.akpm@linux-foundation.org>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
	 <20070319121724.2360a610.randy.dunlap@oracle.com>
	 <20070319125558.235b3992.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 00:01:33 +0100
Message-Id: <1174345293.3581.12.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 12:55 -0700, Andrew Morton wrote:
> On Mon, 19 Mar 2007 12:17:24 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Wed, 7 Mar 2007 20:19:15 -0800 Andrew Morton wrote:
> > 
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm2/
> > > 
> > > - This is the same as 2.6.21-rc3-mm1, except Con's CPU scheduler changes
> > >   were dropped.
> > > 
> > >   This is for A/B comparison purposes, and because those changes crashed on
> > >   one test setup.
> > 
> > x86_64, with CONFIG_HOTPLUG disabled:
> > 
> > drivers/base/bus.c: In function 'store_drivers_probe':
> > drivers/base/bus.c:747: error: 'driver_helper' undeclared (first use in this function)
> > drivers/base/bus.c:747: error: (Each undeclared identifier is reported only once
> > drivers/base/bus.c:747: error: for each function it appears in.)
> > make[2]: *** [drivers/base/bus.o] Error 1
> > make[1]: *** [drivers/base] Error 2
> > make: *** [drivers] Error 2
> > 
> 
> Due to Kay's
> gregkh-driver-driver-core-udev-triggered-device-driver-binding.patch

I sent an updated patch, that compiles without CONFIG_HOTPLUG to Greg.

Thanks,
Kay

