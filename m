Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbXICR7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbXICR7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 13:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbXICR6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 13:58:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:65364 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbXICR6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 13:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BbpeweIWQ2uI/M3ypTI//s8dWzxnmLw4+0kBi2USjd1jVPDQfy8TuWRsBMO7xL0cwHrwAjyr2N5H5Jpm9H3xP5Q/prhIhTb4GtsZ3dzPdEEEnPFwijf4fLrwGpi3U7MJQ6eNzUZuf2cncLEMEs6PJ2xk9sPthQjsoLDy7lmBiO4=
Message-ID: <8bd0f97a0709031058g3d0b5e8dodbb5fa5f35366b4f@mail.gmail.com>
Date: Mon, 3 Sep 2007 13:58:53 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Clemens Koller" <clemens.koller@anagramm.de>
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
Cc: bryan.wu@analog.com, "David Woodhouse" <dwmw2@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <46DBDE75.90203@anagramm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1188804323.29566.6.camel@roc-laptop> <46DBDE75.90203@anagramm.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/07, Clemens Koller <clemens.koller@anagramm.de> wrote:
> Bryan Wu schrieb:
> > This is the driver for latest Blackfin BF54x nand flash controller
> >
> >  - use nand_chip and mtd_info common nand driver interface
> >  - provide both PIO and dma operation
> >  - compiled with ezkit bf548 configuration
> >  - use hardware 1-bit ECC
> >  - tested with YAFFS2 and can mount YAFFS2 filesystem as rootfs
>
> Looks great!
>
> Will this driver also work for the new BF52x series of the Blackfin Series?
> (Or is it planned to make it work for... anytime soon.)

the order for porting of new chips is:
u-boot -> core kernel -> peripherals

we generally dont bother looking at peripherals until the earlier stuff is done
-mike
