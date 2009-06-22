Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZFVIQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZFVIQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZFVIP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:15:58 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49495 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZFVIP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:15:58 -0400
Subject: Re: [PATCH] SST25L (non JEDEC) SPI Flash driver
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       spi-devel-general@lists.sourceforge.net, mike@steroidmicros.com,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4A3F017B.2010409@bluewatersys.com>
References: <4A3F017B.2010409@bluewatersys.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Jun 2009 11:15:10 +0300
Message-Id: <1245658510.9487.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Jun 2009 08:15:12.0298 (UTC) FILETIME=[909D20A0:01C9F311]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 15:58 +1200, Ryan Mallon wrote:
> Add support for the non JEDEC SST25L SPI Flash devices.
> 
> Signed-off-by: Andre Renaud <andre@bluewatersys.com>
> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
> ---
> 
> diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> index 325fab9..c222514 100644
> --- a/drivers/mtd/devices/Kconfig
> +++ b/drivers/mtd/devices/Kconfig
> @@ -104,6 +104,16 @@ config M25PXX_USE_FAST_READ
>  	help
>  	  This option enables FAST_READ access supported by ST M25Pxx.

Would it please be possible to get rid of this warning:

  CC [M]  drivers/mtd/devices/sst25l.o
drivers/mtd/devices/sst25l.c: In function ‘sst25l_write’:
drivers/mtd/devices/sst25l.c:306: warning: comparison of distinct pointer types lacks a cast

I see it on my x86_64.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

