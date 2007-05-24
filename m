Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbXEXUwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbXEXUwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbXEXUwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:52:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:46332 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbXEXUwW (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:52:22 -0400
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
From: Richard Griffiths <richard.griffiths@windriver.com>
Reply-To: richard.griffiths@windriver.com
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Linux-kernel@vger.kernel.org
In-Reply-To: <6934efce0705241322j7ad7c4fex621217e0749ddf3e@mail.gmail.com>
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <6934efce0705241322j7ad7c4fex621217e0749ddf3e@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Products Group
Date: Thu, 24 May 2007 13:52:19 -0700
Message-Id: <1180039939.27593.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 24 May 2007 20:52:20.0048 (UTC) FILETIME=[6BB7AD00:01C79E45]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 13:22 -0700, Jared Hulbert wrote:
> On 5/22/07, Richard Griffiths <res07ml0@verizon.net> wrote:
> > Venerable cramfs fs Linear XIP patch originally from MontaVista, used in
> > the embedded Linux community for years, updated for 2.6.21. Tested on
> > several systems with NOR Flash. PXA270, TI OMAP2430, ARM Versatile and
> > Freescale iMX31ADS.
> >
> 
> When trying to verify this patch on our PXA270 system we get the
> following error when running an XIP rootfs:
> 
> cramfs: checking physical address 0xa00000 for linear cramfs image
> cramfs: linear cramfs image appears to be 3236 KB in size
> VFS: Mounted root (cramfs filesystem) readonly.
> Freeing init memory: 96K
> /sbin/init: error while loading shared libraries: libgcc_s.so.1:
> failed to map segment from shared object: Error 11
> Kernel panic - not syncing: Attempted to kill init!
> 
> However, if our busybox binary is XIP while the libgcc_s.so.1 is not
> XIP, busybox runs fine.

> Richard, May I email you the rootfs tarball so you can recreate what
> we are seeing?  It is a little less than 2MiB.  The filing system
> executables will only run on a PXA27x processor.
Yes you can, but I won't have access to a PXA270 for a few weeks. I
assume you don't see the issue if you static link busybox? BTW I'm using
uclibc rather than glibc - much smaller fs.

Richard
