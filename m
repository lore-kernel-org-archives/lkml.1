Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335Ab0AZLBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0AZLBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 06:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283Ab0AZLBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 06:01:47 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58288 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0AZLBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 06:01:47 -0500
Subject: Re: [PATCH 01/01] regulator: support max8649
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <771cded01001252226k342723b3p3ea235fe79c46843@mail.gmail.com>
References: <771cded01001120041ue24edabk8e4638ef7151c947@mail.gmail.com>
	 <771cded01001120051l44fd76bx80d2fd4b6f60bd0b@mail.gmail.com>
	 <20100112115156.GA546@rakim.wolfsonmicro.main>
	 <771cded01001250301q465a9f8ma484f597ae9a292f@mail.gmail.com>
	 <20100125135628.GB26613@rakim.wolfsonmicro.main>
	 <771cded01001252226k342723b3p3ea235fe79c46843@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 11:01:41 +0000
Message-ID: <1264503701.3067.69.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 01:26 -0500, Haojian Zhuang wrote:
> From 2b5a73c336d2b5dc48c8cf1f2a804b6968659f78 Mon Sep 17 00:00:00 2001
> From: Haojian Zhuang <haojian.zhuang@marvell.com>
> Date: Mon, 25 Jan 2010 10:24:09 -0500
> Subject: [PATCH] regulator: enable max8649 regulator driver
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>

Can you confirm all the changes compared to the last version. 

> +static int max8649_get_voltage(struct regulator_dev *rdev)
> +{
> +       struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
> +       unsigned char data;
> +       int ret;
> +
> +       ret = max8649_reg_read(info->i2c, info->vol_reg);
> +       if (ret < 0)
> +               return ret;
> +       data = (unsigned char)ret & MAX8649_VOL_MASK;
> +       return (max8649_list_voltage(rdev, data));

Any reason why we have extra () here ?

Thanks

Liam

