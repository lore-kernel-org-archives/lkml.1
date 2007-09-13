Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbXIMIxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbXIMIxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbXIMIxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:53:35 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:40515 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbXIMIxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:53:34 -0400
X-IronPort-AV: i="4.20,248,1186372800"; 
   d="scan'208"; a="39530766:sNHT70244846"
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: bryan.wu@analog.com, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0709130151p36846690w4600463837285a2b@mail.gmail.com>
References: <1188804323.29566.6.camel@roc-laptop>
	 <20070913013702.d446739a.akpm@linux-foundation.org>
	 <8bd0f97a0709130145u474ab017ocf58b004c5d69dc0@mail.gmail.com>
	 <1189673107.30686.18.camel@roc-desktop>
	 <8bd0f97a0709130151p36846690w4600463837285a2b@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 13 Sep 2007 16:49:45 +0800
Message-Id: <1189673385.30686.20.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 13 Sep 2007 08:53:30.0104 (UTC) FILETIME=[8E887F80:01C7F5E3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 04:51 -0400, Mike Frysinger wrote:
> On 9/13/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > On Thu, 2007-09-13 at 04:45 -0400, Mike Frysinger wrote:
> > > On 9/13/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > On Mon, 03 Sep 2007 15:25:23 +0800 Bryan Wu <bryan.wu@analog.com> wrote:
> > > > > This is the driver for latest Blackfin BF54x nand flash controller
> > > > >
> > > > >  - use nand_chip and mtd_info common nand driver interface
> > > > >  - provide both PIO and dma operation
> > > > >  - compiled with ezkit bf548 configuration
> > > > >  - use hardware 1-bit ECC
> > > > >  - tested with YAFFS2 and can mount YAFFS2 filesystem as rootfs
> > > > >
> > > > > ...
> > > > >
> > > > > +int hardware_ecc = 0;
> > > >
> > > > scripts/checkpatch.pl, please.
> > >
> > > that isnt static so checkpatch.pl wouldnt have caught it ... it should
> > > be static though of course and then checkpatch.pl would have thrown a
> > > static init 0 warning :)
> >
> > Actually, it would caught by checkpatch.pl even without static.
> 
> it doesnt for me, but maybe i'm just using an older version
> -mike

Yes, should use the latest git-tree checkpatch.pl
Thanks
-Bryan
