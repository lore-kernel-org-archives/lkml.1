Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYJAUTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYJAUTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 16:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYJAUTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 16:19:30 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:34471 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753601AbYJAUT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 16:19:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yCe44IqBYmovIH0Icbtbsxk6byeavslZHWIRqyQx/O7JI961FdvUGIe8yT6hFoB7amFeISUEmhkexWrSmCGhKoSdUuJA3GDoKOrh508lHQoT/Fdt4eF2Ji2zcBf1q3Xghcseemcrw90JmVq24rpk2Nak6qHK6JTnzDuONzDXqeg=  ;
X-YMail-OSG: sK6FcncVM1nZXpWF01.HUVoCVXBMZMcDqu2UU7VcXQaaFvjfaKWpogV_lUtotrD7TQTuCQRn8wljnbpQ3xnwLhKx1MloPuxkZie97m2VaoE8.v4s9zKcHe3TOgzmgLcXKlYukGYvTLoz3ERiyKklIhiU
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2.6.27-rc8 1/2] drivers/mfd/twl4030-core.c
Date: Wed, 1 Oct 2008 13:19:25 -0700
User-Agent: KMail/1.9.9
Cc: Samuel Ortiz <sameo@openedhand.com>, lkml <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Felipe Balbi <felipe.balbi@nokia.com>,
       linux-omap@vger.kernel.org, Mikko Ylinen <mikko.k.ylinen@nokia.com>
References: <200810011144.20510.david-b@pacbell.net> <20081001124407.aa090ccd.randy.dunlap@oracle.com>
In-Reply-To: <20081001124407.aa090ccd.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810011319.26780.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2008, Randy Dunlap wrote:

> > +	  These multi-function chps are found on many OMAP2 and OMAP3
> 
> 	                       chips

Indeed ... although if e e cummings could write poetry without
uppercase, surely in this modern age some literature will be
forthcoming that uses no vwls?  (Oh wait.  That's Hebrew.  ;)


> > --- /dev/null
> > +++ b/include/linux/i2c/twl4030-madc.h
> > @@ -0,0 +1,134 @@
> > +/*
> > + * include/linux/i2c/twl4030-madc.h
> > + *
> > + * TWL4030 MADC module driver header
> > + *
> > + * Copyright (C) 2008 Nokia Corporation
> > + * Mikko Ylinen <mikko.k.ylinen@nokia.com>
> 
> 
> > +#define TWL4030_MADC_IOC_MAGIC '`'
> 
> Add that to Documentation/ioctl-number.txt (?)

Actually one of my own review comments is that this header
should become unneccessary ... and everything associated
with it be dealt with when this Multi-channel ADC driver
gets pushed upstream.  IRQ initialization needs to be done
in the core, but none of the other MADC stuff matters here.

Thanks.


- Dave
