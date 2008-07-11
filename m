Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbYGKP1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbYGKP1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYGKP1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:27:15 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:25993 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbYGKP1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZFKzC7KTMBlb+gQoCMCuKmGnqzeg+kX4nlLFX0NJ4a+QQEUzn12jPe+aYiNjhRMQca
         13YGUAoX11QVikT3EclNpKFFvxD/lmmUYgMu9RGS7BGx+6cJaZowMbcJwd+nT9fFlXrw
         uMresDnWVAcMAgeZXFtxa2q61++YHJEp5lw/8=
Subject: Re: [PATCH 1/2] regulator: TI bq24022 Li-Ion Charger driver
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1215772087.6634.7.camel@odin>
References: <1215716683.17490.29.camel@localhost.localdomain>
	 <1215772087.6634.7.camel@odin>
Content-Type: text/plain; charset=utf-8
Date: Fri, 11 Jul 2008 17:27:07 +0200
Message-Id: <1215790027.16329.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 11.07.2008, 11:28 +0100 schrieb Liam Girdwood:
> On Thu, 2008-07-10 at 21:04 +0200, Philipp Zabel wrote:
> > This adds a regulator driver for the TI bq24022 Single-Chip
> > Li-Ion Charger with its nCE and ISET2 pins connected to GPIOs.
> 
> snip
> 
> > +static struct platform_driver bq24022_driver = {
> > +	.driver = {
> > +		.name = "bq24022",
> > +	},
> > +	.remove = __devexit_p(bq24022_remove),
> > +};
> > +
> > +static int __init bq24022_init()
> 
> missing void
> 
> > +{
> > +	platform_driver_probe(&bq24022_driver, bq24022_probe);
> > +}
> > +
> 
> missing return value.
> 
> > +static void __exit bq24022_exit()
> 
> ﻿missing void
> 
> > +{
> > +	platform_driver_unregister(&bq24022_driver);
> > +}
> 
> Could you fix these and resubmit.

Thanks, fixed version will follow in a second.

regards
Philipp

