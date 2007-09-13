Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbXIMIpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbXIMIpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbXIMIpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:45:15 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:36490 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbXIMIpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PU9wwf+njdZufOGQeO9ZXoQX1qAKuJgs6NzF1FGVrKYaeZSWCO5Pc/fMWTVtFelG/pBAvW76DmN5roADIYJI6GbBl0gmw/slwYCQRfqNHPijT6hECkqwuig/zuNDKgT8Amn4jKZTN9qh7ZC1pdVVIXej1Fx/f6wDQ4DMCdXIa34=
Message-ID: <8bd0f97a0709130145u474ab017ocf58b004c5d69dc0@mail.gmail.com>
Date: Thu, 13 Sep 2007 04:45:13 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
Cc: bryan.wu@analog.com, "David Woodhouse" <dwmw2@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070913013702.d446739a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1188804323.29566.6.camel@roc-laptop>
	 <20070913013702.d446739a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 03 Sep 2007 15:25:23 +0800 Bryan Wu <bryan.wu@analog.com> wrote:
> > This is the driver for latest Blackfin BF54x nand flash controller
> >
> >  - use nand_chip and mtd_info common nand driver interface
> >  - provide both PIO and dma operation
> >  - compiled with ezkit bf548 configuration
> >  - use hardware 1-bit ECC
> >  - tested with YAFFS2 and can mount YAFFS2 filesystem as rootfs
> >
> > ...
> >
> > +int hardware_ecc = 0;
>
> scripts/checkpatch.pl, please.

that isnt static so checkpatch.pl wouldnt have caught it ... it should
be static though of course and then checkpatch.pl would have thrown a
static init 0 warning :)
-mike
