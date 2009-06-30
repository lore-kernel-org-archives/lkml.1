Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZF3Maa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZF3Maa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZF3MaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 08:30:22 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4092 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZF3MaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 08:30:22 -0400
Subject: Re: [PATCH 0/3] msm_sdcc: A few more cleanups
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, pierre@ossman.eu, swetland@google.com,
       Andrew Morton <akpm@linux-foundation.org>, San Mehat <san@google.com>
In-Reply-To: <20090630065747.GA19260@elf.ucw.cz>
References: <20090629214101.GA12043@elf.ucw.cz>
	 <cover.1246319479.git.joe@perches.com>  <20090630065747.GA19260@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 05:30:21 -0700
Message-Id: <1246365021.10129.146.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 08:57 +0200, Pavel Machek wrote:
> diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
> -	do_div(clks, NSECS_PER_SEC);
> +	do_div(clks, NSEC_PER_SEC);

Compiling is good.  Submitting uncompiled patches not so good...

> @@ -588,6 +588,8 @@ static void
>  msmsdcc_handle_irq_data(struct msmsdcc_host *host, struct mmc_data *data,
>  			u32 status)
>  {
> +	void __iomem	*base = host->base;
> +

I don't know how performance sensitive this is.

Maybe it should be inline and have base passed
as an argument.


