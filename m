Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbZHILU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbZHILU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZHILU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:20:58 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:58390 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbZHILU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:20:57 -0400
Subject: Re: [PATCH 1/8] Regulator: Add TPS65023 regulator driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Anuj Aggarwal <anuj.aggarwal@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20090807155358.GI639@sirena.org.uk>
References: <1249658726-10769-1-git-send-email-anuj.aggarwal@ti.com>
	 <20090807155358.GI639@sirena.org.uk>
Content-Type: text/plain
Date: Sun, 09 Aug 2009 12:20:55 +0100
Message-Id: <1249816855.11250.33.camel@vega>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 16:53 +0100, Mark Brown wrote:
> On Fri, Aug 07, 2009 at 08:55:26PM +0530, Anuj Aggarwal wrote:
> 

> > +static const struct tps_info tps65023_regs[] = {
> > +	{
> > +	.name = "VDCDC1",
> > +	.min_uV =  800000,
> > +	.max_uV = 1600000,
> > +	.fixed = 0,

No need to add fixed = 0 in this array as compiler will do this for you.

> > +	.table_len = ARRAY_SIZE(VDCDC1_VSEL_table),
> > +	.table = VDCDC1_VSEL_table,
> > +	},
> 
> Indentation here is a bit non-standard - I'd expect either the {} around
> the elements to be in column 0 or another level of indentation for the
> fields.
> 
> > +	{
> > +	.name = "VDCDC2",
> > +	.min_uV =  3300000,
> > +	.max_uV = 3300000,
> > +	.fixed = 1,
> > +	.table_len = 0,
> > +	},
> 
> You could drop the fixed flag and just have fixed be inferred from
> min_uV == max_uV?
> 

To be honest I prefer having the fixed = 1 here. It stands out more and
imho keeps things simple. Also table_len could be omitted.

Thanks

Liam

