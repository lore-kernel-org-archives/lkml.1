Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbXIMItA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbXIMItA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXIMIsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:48:53 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:12403 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbXIMIsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:48:52 -0400
X-IronPort-AV: i="4.20,248,1186372800"; 
   d="scan'208"; a="51331256:sNHT33636631"
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com,
       David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0709130145u474ab017ocf58b004c5d69dc0@mail.gmail.com>
References: <1188804323.29566.6.camel@roc-laptop>
	 <20070913013702.d446739a.akpm@linux-foundation.org>
	 <8bd0f97a0709130145u474ab017ocf58b004c5d69dc0@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 13 Sep 2007 16:45:07 +0800
Message-Id: <1189673107.30686.18.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 13 Sep 2007 08:48:50.0533 (UTC) FILETIME=[E7E55950:01C7F5E2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 04:45 -0400, Mike Frysinger wrote:
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
> that isnt static so checkpatch.pl wouldnt have caught it ... it should
> be static though of course and then checkpatch.pl would have thrown a
> static init 0 warning :)

Actually, it would caught by checkpatch.pl even without static. 

Andrew, I think I sent out the try#2 version of this patch which fixed
these checkpatch.pl issues. But I will continue do some cleanup as you
point out.

Thanks
-Bryan Wu
