Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbXEFUOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbXEFUOD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbXEFUOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:14:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:54029 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbXEFUOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TmOcTNMagtASmmODBomWVIY3Zd1pd2iBtZ5EVgvT5MF9GQE2LgYkwuLmJZH2LhsuTt+qCd/fxmyQB3OL+v2Y7HJlWrQaj3dHZlCAOSCZvY8NkZIS2VCz6ga7NhLv9WJdR3HqrWU3XuLKSKNyFNYha+S0Qkl5KcCGe4R0frbsZ44=
Message-ID: <e9c3a7c20705061313g2b110c4ai478bd3d345de3114@mail.gmail.com>
Date: Sun, 6 May 2007 13:13:58 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Wim Van Sebroeck" <wim@iguana.be>
Subject: Re: [2.6.22 patch] iop: combined watchdog timer driver for iop3xx and iop13xx
Cc: "Curt E. Bruns" <curt.e.bruns@intel.com>,
       "Peter Milne" <peter.milne@d-tacq.com>,
       "Russell King" <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       "Lennert Buytenhek" <buytenh@wantstofly.org>
In-Reply-To: <20070506095256.GA2521@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177952240.12134.10.camel@dwillia2-linux.ch.intel.com>
	 <20070506095256.GA2521@infomag.infomag.iguana.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/07, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi Dan,
>
> > Here is a new watchdog driver for your review.  It supports two flavors
> > of the iop watchdog timer.  The iop13xx watchdog can be stopped while
> > the iop3xx version cannot.
>
> I started reviewing this patch yesterday. First thing I noticed was that
> you seem to be moving some code from include/asm-arm/arch-iop13xx/system.h
> to include/asm-arm/arch-iop13xx/iop13xx.h .
> This should not be part of this patch since it is touching architecture
> dependant code for which I do not have enough knowledge about this specific
> architecture to tell if this is indeed the correct way to do this.
> The maintainers of this architecture should imho comment on this.
> Could you split this patch into 2 patches: one that deals with the moving of
> the architecture dependant code (and explaining why) and one with the new
> watchdog drivers? I will continue my review today.
>

I am one of the maintainers of this architecture, (Lennert Buytenhek
is the other).  I will go ahead and split this up so you can sign-off
on the watchdog specific bits.  The intent is to move all hardware
definitions under #include <asm/hardware.h>.  You are right this
should have been a separate patch.

> Thanks,
> Wim.
>

Thanks for your help,
Dan
