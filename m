Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZLCOzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZLCOzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbZLCOzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:55:16 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:53199 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbZLCOzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:55:14 -0500
Date: Thu, 3 Dec 2009 14:54:53 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>, cpufreq@vger.kernel.org
Subject: Re: [PATCH v0] Loongson2: CPUFreq: add support to load module
 automatically
Message-ID: <20091203145452.GA28957@linux-mips.org>
References: <8421507f5dfc1a70d1dba92ad7604a8bfaa5a447.1259805106.git.wuzhangjin@gmail.com>
 <1259815795.4474.34.camel@falcon.domain.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259815795.4474.34.camel@falcon.domain.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 12:49:55PM +0800, Wu Zhangjin wrote:

> > +++ b/arch/mips/loongson/common/platform.c
> > @@ -0,0 +1,32 @@
> > +/*
> > + * Copyright (C) 2009 Lemote Inc.
> > + * Author: Wu Zhangjin, wuzj@lemote.com
> > + *
> > + * This program is free software; you can redistribute  it and/or modify it
> > + * under  the terms of  the GNU General  Public License as published by the
> > + * Free Software Foundation;  either version 2 of the  License, or (at your
> > + * option) any later version.
> > + */
> > +
> > +#include <linux/err.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include <asm/bootinfo.h>
> 
> The above header file is not needed.

I folded your patch into "MIPS: Loongson 2F: Add CPU frequency scaling
support" and removed that line.  Thanks!

  Ralf
