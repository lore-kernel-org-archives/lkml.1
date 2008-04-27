Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYD0Hmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYD0Hmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 03:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbYD0HmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 03:42:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:38978 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbYD0HmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 03:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Sn4ZTSFPcwbzw1+WfcPS2yd/lbVGBiyO3Qbpo5vQTVv7fJmZYLPnkdmhvq4AEJS3+DEqS6r8oG92jtQKLXS6bQ1g3AkfCISM6L5Mj+T4gerJIgBNWOWPxChe0CikPiI84GIC0Me11e4jPIxFzys4/Ep5M96TIxdWBp2UJx2TorY=
Message-ID: <48142E5B.3000109@gmail.com>
Date: Sun, 27 Apr 2008 09:42:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Chris Peterson <cpeterso@cpeterso.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix warning: remove unused static function in drivers/char/ip2/i2ellis.c
References: <a24804730804270009x3398a190wf68e52280015fc7f@mail.gmail.com>
In-Reply-To: <a24804730804270009x3398a190wf68e52280015fc7f@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2008 09:09 AM, Chris Peterson wrote:
> This patch against linux-2.6.25-git7.
> 
> chris
> 
> 
> Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
> ---
> diff -Naur linux-2.6.25-git7/drivers/char/ip2/i2ellis.c
> linux-2.6.25-git7+patch/drivers/char/ip2/i2ellis.c
> --- linux-2.6.25-git7/drivers/char/ip2/i2ellis.c	2008-04-25
> 22:47:01.000000000 -0700
> +++ linux-2.6.25-git7+patch/drivers/char/ip2/i2ellis.c	2008-04-25
> 23:19:57.000000000 -0700
> @@ -86,22 +86,6 @@
>  }
> 
>  //******************************************************************************
> -// Function:   iiEllisCleanup()
> -// Parameters: None
> -//
> -// Returns:    Nothing
> -//
> -// Description:
> -//
> -// This routine performs any required cleanup of the iiEllis subsystem.
> -//
> -//******************************************************************************
> -static void
> -iiEllisCleanup(void)
> -{
> -}

Well, have you tried to even build it? The .c file is *included* into i2main.c 
where this function is used.

NAK
