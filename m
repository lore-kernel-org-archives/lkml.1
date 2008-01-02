Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbYABBGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbYABBGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 20:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbYABBGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 20:06:33 -0500
Received: from hs-out-0708.google.com ([64.233.178.243]:5816 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755412AbYABBGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 20:06:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hVjiCIt+ifxC3emi7NGHTTbwbJ25Q9d1+uKifJfep7AxnM2YVCU34t9Mhdq24FuYMPAPuBbwGE/jlE9Kz0ZAoxvq00D4jOiS+kscr74/gJs6qG4KyO20gkaK6mFNURydXOOSe2KZwQCr70VtMi2fvVqu/uN0NI2mRfOR53zUaxA=
Message-ID: <a8e1da0801011706m44b001eh25136032b901cc2d@mail.gmail.com>
Date: Wed, 2 Jan 2008 09:06:31 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 04/12] i2c : Use mutex instead of semaphore in driver core
Cc: khali@linux-fr.org, linux-kernel@vger.kernel.org, i2c@lm-sensors.org
In-Reply-To: <47763450.5010604@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229010751.GE2883@darkstar.te-china.tietoenator.com>
	 <47763450.5010604@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 29, 2007 7:49 PM, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Dave Young wrote:
> > --- linux/drivers/i2c/i2c-core.c      2007-12-28 10:06:58.000000000 +0800
> > +++ linux.new/drivers/i2c/i2c-core.c  2007-12-28 10:08:58.000000000 +0800
> > @@ -33,8 +33,8 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/mutex.h>
> >  #include <linux/completion.h>
> > +#include <linux/mutex.h>
> >  #include <asm/uaccess.h>
> > -#include <asm/semaphore.h>
>
> 2x #include <linux/mutex.h>

Thanks, my fault ;)
This patch series need more lockdep works to be done. After that I
will repost it.

> --
> Stefan Richter
> -=====-=-=== ==-- ===-=
> http://arcgraph.de/sr/
>
