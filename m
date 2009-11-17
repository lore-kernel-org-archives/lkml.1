Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZKQDSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZKQDSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 22:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZKQDSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 22:18:06 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50955 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbZKQDSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 22:18:04 -0500
Message-ID: <4B0215F0.8050105@pobox.com>
Date: Mon, 16 Nov 2009 22:18:08 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
References: <4AFCC0D4.9020708@gmail.com>
In-Reply-To: <4AFCC0D4.9020708@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2009 09:13 PM, Robert Hancock wrote:
> Remove the experimental tag on Parallel ATA drivers. Though some of the
> individual PATA drivers are still marked as experimental, as a group they can
> hardly be considered to be, given they've been used in various distros for some
> time.
>
> Signed-off-by: Robert Hancock<hancockrwd@gmail.com>
>
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index f2df6e2..33133c6 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -3,7 +3,7 @@
>   #
>
>   menuconfig ATA
> -	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
> +	tristate "Serial ATA and Parallel ATA drivers"
>   	depends on HAS_IOMEM
>   	depends on BLOCK

applied


