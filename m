Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbXHCG4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbXHCG4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 02:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbXHCG4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 02:56:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:31934 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134AbXHCG4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 02:56:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,215,1183359600"; 
   d="scan'208";a="258370068"
Subject: Re: [PATCH 4/5] x86_64 EFI support -v3: EFI framebuffer driver
From: "Huang, Ying" <ying.huang@intel.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1185947712.4688.22.camel@daplas>
References: <1185851582.23149.29.camel@caritas-dev.intel.com>
	 <1185947712.4688.22.camel@daplas>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 03 Aug 2007 14:56:08 +0800
Message-Id: <1186124168.5075.6.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 03 Aug 2007 06:56:10.0667 (UTC) FILETIME=[5FC3E7B0:01C7D59B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 13:55 +0800, Antonino A. Daplas wrote:
> On Tue, 2007-07-31 at 11:13 +0800, Huang, Ying wrote:
> 
> > +
> > +#include <linux/delay.h>
> > +#include <linux/errno.h>
> > +#include <linux/fb.h>
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/ioport.h>
> > +#include <linux/mm.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/screen_info.h>
> > +#include <linux/slab.h>
> > +#include <linux/string.h>
> > +#include <linux/dmi.h>
> > +#include <linux/efi.h>
> > +#include <linux/io.h>
> > +
> > +#include <video/vga.h>
> > +
> 
> I don't see any problems with this driver, just a few minor nits.
> 
> Do you really need all the #include's?

There are some #include's that are not needed. I will remove them in the
next version.

> I presume this driver only supports bpp 16 and above?

Yes. Only the true color visual is supported. I think only bpp 16 and
above can support true color visual.

Best Regards,
Huang Ying
