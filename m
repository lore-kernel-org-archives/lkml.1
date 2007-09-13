Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbXIMIve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbXIMIve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbXIMIv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:51:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327AbXIMIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:51:26 -0400
Date: Thu, 13 Sep 2007 01:49:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: bryan.wu@analog.com, "David Woodhouse" <dwmw2@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
Message-Id: <20070913014955.91f4602e.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0709130145u474ab017ocf58b004c5d69dc0@mail.gmail.com>
References: <1188804323.29566.6.camel@roc-laptop>
	<20070913013702.d446739a.akpm@linux-foundation.org>
	<8bd0f97a0709130145u474ab017ocf58b004c5d69dc0@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 04:45:13 -0400 "Mike Frysinger" <vapier.adi@gmail.com> wrote:

> On 9/13/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 03 Sep 2007 15:25:23 +0800 Bryan Wu <bryan.wu@analog.com> wrote:
> > > This is the driver for latest Blackfin BF54x nand flash controller
> > >
> > >  - use nand_chip and mtd_info common nand driver interface
> > >  - provide both PIO and dma operation
> > >  - compiled with ezkit bf548 configuration
> > >  - use hardware 1-bit ECC
> > >  - tested with YAFFS2 and can mount YAFFS2 filesystem as rootfs
> > >
> > > ...
> > >
> > > +int hardware_ecc = 0;
> >
> > scripts/checkpatch.pl, please.
> 
> that isnt static so checkpatch.pl wouldnt have caught it ...

box:/usr/src/25> perl scripts/checkpatch.pl ~/x
ERROR: do not initialise externals to 0 or NULL
#186: FILE: drivers/mtd/nand/bf54x_nand.c:73:
+int hardware_ecc = 0;

> it should be static though of course

good point.

> and then checkpatch.pl would have thrown a
> static init 0 warning :)
> -mike
