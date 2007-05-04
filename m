Return-Path: <linux-kernel-owner+w=401wt.eu-S1767632AbXEDDjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767632AbXEDDjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 23:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767652AbXEDDjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 23:39:21 -0400
Received: from ozlabs.org ([203.10.76.45]:50236 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767632AbXEDDjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 23:39:20 -0400
Subject: Re: [RELEASE] Lguest for 2.6.21
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <20070504032043.GT11115@waste.org>
References: <1178117028.19815.14.camel@localhost.localdomain>
	 <20070503160201.GR11166@waste.org>
	 <1178237603.23670.26.camel@localhost.localdomain>
	 <1178239389.23670.33.camel@localhost.localdomain>
	 <20070504032043.GT11115@waste.org>
Content-Type: text/plain
Date: Fri, 04 May 2007 13:39:06 +1000
Message-Id: <1178249946.23670.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 22:20 -0500, Matt Mackall wrote:
> I take it both sides of the virtual device drivers are turned on by
> the lguest option?

Yeah, to quote the code in drivers/lguest/lguest_bus.c:

/* At the moment we build all the drivers into the kernel because they're so
 * simple: 8144 bytes for all three of them as I type this.  And as the console
 * really needs to be built in, it's actually only 3527 bytes for the network
 * and block drivers.

> For the purposes of kernel hacking, I'd want to boot into one build
> and repeatedly launch another build as a guest, thereby getting
> faster hack/build/test cycles than either qemu or full reboot.
> How tightly coupled are things here?

I do that all the time, too.  The main issue is that we provide no ABI
for lguest (at least, not yet), so if you actually change guest/host
kernel version, you're on your own...

Thanks!
Rusty.


