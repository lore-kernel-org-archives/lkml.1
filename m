Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZDAFqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZDAFqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 01:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZDAFqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 01:46:37 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26551 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbZDAFqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 01:46:37 -0400
Subject: Re: [patch/rfc 2.6.29 2/2] MTD: support driver model updates
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Brownell <david-b@pacbell.net>
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <200903260042.50236.david-b@pacbell.net>
References: <200903260039.34013.david-b@pacbell.net>
	 <200903260042.50236.david-b@pacbell.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Apr 2009 08:46:11 +0300
Message-Id: <1238564771.20906.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2009 05:46:12.0936 (UTC) FILETIME=[2A773C80:01C9B28D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-26 at 00:42 -0700, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Follow-on patch to the previous driver model patch for the MTD
> framework.  This one makes various MTD drivers connect to the
> driver model tree, so /sys/devices/virtual/mtd/* nodes are no
> longer present ... mostly drivers used on boards I have handy.
> 
> Based on a patch from Kay Sievers.

...

> --- a/drivers/mtd/nand/mxc_nand.c
> +++ b/drivers/mtd/nand/mxc_nand.c
> @@ -866,6 +866,7 @@ static int __init mxcnd_probe(struct pla
>  	mtd = &host->mtd;
>  	mtd->priv = this;
>  	mtd->owner = THIS_MODULE;
> +	mtd->dev.parent = &pdev->dev;

Could this be done for all NANDs in nand_base.c instead?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

