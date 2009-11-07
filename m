Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZKGPnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZKGPnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 10:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZKGPny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 10:43:54 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46907 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZKGPnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 10:43:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=InaY+2YYhgQ0ffdKUuIsctBcBdSh5YgrtiVaBPXopDsoT7tm2/q0KFTHQ7w6Nv9Ef4
         EYYwL9ehxODqxvcSFx5nUSOkzz0/cjqx3AOuNQk6jOFX7P2HZb0Gofj8fUoSN4oSj9qc
         apRw9jfHAOgEwuGAE38mMtYljgVdqkoBn5Sxs=
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       tony@atomide.com
Subject: Re: [PATCH v2 2/2] omap: RX-51: enable tsc2005
References: <1257340982-22814-1-git-send-email-aaro.koskinen@nokia.com>
	<1257340982-22814-2-git-send-email-aaro.koskinen@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 07 Nov 2009 17:43:55 +0200
In-Reply-To: <1257340982-22814-2-git-send-email-aaro.koskinen@nokia.com> (Aaro Koskinen's message of "Wed\,  4 Nov 2009 15\:23\:02 +0200")
Message-ID: <87d43ufih0.fsf@purkki.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaro Koskinen <aaro.koskinen@nokia.com> writes:

> Enable tsc2005 touchscreen driver on the RX-51 board.
>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> ---
>
> The patch is for 2.6.32-rc6.

[...]

> +static struct spi_board_info rx51_peripherals_spi_board_info[] = {
> +	[0] = {
> +		.modalias		= "tsc2005",
> +		.bus_num		= 1,
> +		.chip_select		= 0,
> +		.irq			= OMAP_GPIO_IRQ(RX51_TSC2005_IRQ_GPIO),
> +		.max_speed_hz		= 6000000,
> +		.controller_data	= &tsc2005_mcspi_config,
> +		.platform_data		= &tsc2005_config,
> +	},
> +};

I sent a wl1251 patch which adds spi_board_info and conflicts with
this patch:

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg17604.html

How do we handle this?

-- 
Kalle Valo
