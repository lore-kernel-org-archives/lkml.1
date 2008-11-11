Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYKKICz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYKKICz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYKKICo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:02:44 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:32928 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbYKKICn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:02:43 -0500
Message-ID: <49193C1F.80703@garzik.org>
Date: Tue, 11 Nov 2008 03:02:39 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
CC: rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] /drivers/ata/pata_cs553*.c: cleanup kerneldoc
References: <20081108163202.031b2a94@ubuntu>
In-Reply-To: <20081108163202.031b2a94@ubuntu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qinghuang Feng wrote:
> no arguments named @deadline in cs5535_cable_detect() and cs5536_cable_detect(), 
> remove them.
> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
> ---
> diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
> index 1b2d4a0..8b236af 100644
> --- a/drivers/ata/pata_cs5535.c
> +++ b/drivers/ata/pata_cs5535.c
> @@ -72,7 +72,6 @@
>  /**
>   *	cs5535_cable_detect	-	detect cable type
>   *	@ap: Port to detect on
> - *	@deadline: deadline jiffies for the operation
>   *
>   *	Perform cable detection for ATA66 capable cable. Return a libata
>   *	cable type.
> diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
> index 73f8332..afed929 100644
> --- a/drivers/ata/pata_cs5536.c
> +++ b/drivers/ata/pata_cs5536.c
> @@ -110,7 +110,6 @@ static inline int cs5536_write(struct pci_dev *pdev, int reg, int val)
>  /**
>   *	cs5536_cable_detect	-	detect cable type
>   *	@ap: Port to detect on
> - *	@deadline: deadline jiffies for the operation
>   *

applied


