Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYGKK2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYGKK2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYGKK2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:28:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59889 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755927AbYGKK2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:28:09 -0400
Subject: Re: [PATCH 1/2] regulator: TI bq24022 Li-Ion Charger driver
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1215716683.17490.29.camel@localhost.localdomain>
References: <1215716683.17490.29.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Fri, 11 Jul 2008 11:28:07 +0100
Message-Id: <1215772087.6634.7.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 21:04 +0200, Philipp Zabel wrote:
> This adds a regulator driver for the TI bq24022 Single-Chip
> Li-Ion Charger with its nCE and ISET2 pins connected to GPIOs.

snip

> +static struct platform_driver bq24022_driver = {
> +	.driver = {
> +		.name = "bq24022",
> +	},
> +	.remove = __devexit_p(bq24022_remove),
> +};
> +
> +static int __init bq24022_init()

missing void

> +{
> +	platform_driver_probe(&bq24022_driver, bq24022_probe);
> +}
> +

missing return value.

> +static void __exit bq24022_exit()

﻿missing void

> +{
> +	platform_driver_unregister(&bq24022_driver);
> +}

Could you fix these and resubmit.

Thanks

Liam

