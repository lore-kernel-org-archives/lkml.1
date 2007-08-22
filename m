Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbXHVPha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbXHVPha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760265AbXHVPhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:37:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:18280 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760233AbXHVPhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nXQKsFReuzl4ugY0Wuvq09oTiHsAinWzPf5RwasKl57T2KXM1QSVa1yRW3W8KAs84VOYovgOQExmXNQAZp1FX4W4rq1hso+VZAnqAmDbVACNzeyaGgPQ2WliayRIhCYR+OaorGOcfDS+Rv0YCGwwh48381z2BKc5dhxjS33jnIM=
Message-ID: <ab40e9c0708220837y4485df4epfaebd7022d7ba25e@mail.gmail.com>
Date: Wed, 22 Aug 2007 17:37:19 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: how is the boot process of the multicore system
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070822163354.4b57f501@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0708220753l1861cde2wccb58ba931f04b2c@mail.gmail.com>
	 <20070822163354.4b57f501@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks,

then what about the arm-realview-mpcore?

I found that in mpcore there are 4 cores, the cpu0 boots first, and
the others wait in the WFI(wait for interrupt) state. as far as i know
it is the boot monitor set these cores into WFI state. I just wonder
what happens after these cores get the interrupt. they jump to the
kernel? or sth eles? if they jump to the kernel, to what address? and
these jump instructions are in the boot monitor?
sorry for so many questions....

thanks a lot.

2007/8/22, Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Wed, 22 Aug 2007 16:53:41 +0200
> "Xu Yang" <risingsunxy@googlemail.com> wrote:
>
> > Hi everyone,
> >
> > I am just wondering how is the boot process of the multicore system exactly.
> > let's say there are 4 cores , what is the booting sequence? and how
> > does linux realise the booting process?
>
> For PC type systems read the Intel MP 1.4 specification, available on the
> intel developer web site
>
