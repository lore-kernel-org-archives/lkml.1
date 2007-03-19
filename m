Return-Path: <linux-kernel-owner+w=401wt.eu-S1751205AbXCST4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbXCST4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXCST4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:56:18 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52570 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXCST4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:56:17 -0400
Date: Mon, 19 Mar 2007 12:55:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, gregkh <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.21-rc3-mm2
Message-Id: <20070319125558.235b3992.akpm@linux-foundation.org>
In-Reply-To: <20070319121724.2360a610.randy.dunlap@oracle.com>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
	<20070319121724.2360a610.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 12:17:24 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Wed, 7 Mar 2007 20:19:15 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm2/
> > 
> > - This is the same as 2.6.21-rc3-mm1, except Con's CPU scheduler changes
> >   were dropped.
> > 
> >   This is for A/B comparison purposes, and because those changes crashed on
> >   one test setup.
> 
> x86_64, with CONFIG_HOTPLUG disabled:
> 
> drivers/base/bus.c: In function 'store_drivers_probe':
> drivers/base/bus.c:747: error: 'driver_helper' undeclared (first use in this function)
> drivers/base/bus.c:747: error: (Each undeclared identifier is reported only once
> drivers/base/bus.c:747: error: for each function it appears in.)
> make[2]: *** [drivers/base/bus.o] Error 1
> make[1]: *** [drivers/base] Error 2
> make: *** [drivers] Error 2
> 

Due to Kay's
gregkh-driver-driver-core-udev-triggered-device-driver-binding.patch
