Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbXIMIvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbXIMIvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbXIMIvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:51:46 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:45211 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbXIMIvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U+UOn5LJ6WDkOkn/CjiJDPbqJWse4yYk9rcpQcc6ZWfw7x+JNZ955PNomxZEPmVZKOHZaxp8gUCkGuv42kCdEBkxvWXCvUy1g/D4WkF9ZREk97cVGTOGfudC00X9x4fM44N50T6fl5HJ4lKeIhpRZin49XHs83FSmDg7ZrlNigQ=
Message-ID: <8bd0f97a0709130151p36846690w4600463837285a2b@mail.gmail.com>
Date: Thu, 13 Sep 2007 04:51:44 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1189673107.30686.18.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1188804323.29566.6.camel@roc-laptop>
	 <20070913013702.d446739a.akpm@linux-foundation.org>
	 <8bd0f97a0709130145u474ab017ocf58b004c5d69dc0@mail.gmail.com>
	 <1189673107.30686.18.camel@roc-desktop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Bryan Wu <bryan.wu@analog.com> wrote:
> On Thu, 2007-09-13 at 04:45 -0400, Mike Frysinger wrote:
> > On 9/13/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Mon, 03 Sep 2007 15:25:23 +0800 Bryan Wu <bryan.wu@analog.com> wrote:
> > > > This is the driver for latest Blackfin BF54x nand flash controller
> > > >
> > > >  - use nand_chip and mtd_info common nand driver interface
> > > >  - provide both PIO and dma operation
> > > >  - compiled with ezkit bf548 configuration
> > > >  - use hardware 1-bit ECC
> > > >  - tested with YAFFS2 and can mount YAFFS2 filesystem as rootfs
> > > >
> > > > ...
> > > >
> > > > +int hardware_ecc = 0;
> > >
> > > scripts/checkpatch.pl, please.
> >
> > that isnt static so checkpatch.pl wouldnt have caught it ... it should
> > be static though of course and then checkpatch.pl would have thrown a
> > static init 0 warning :)
>
> Actually, it would caught by checkpatch.pl even without static.

it doesnt for me, but maybe i'm just using an older version
-mike
