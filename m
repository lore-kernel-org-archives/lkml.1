Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbYEYQvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbYEYQvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 12:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbYEYQvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 12:51:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:44654 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbYEYQvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 12:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TaFbG0FMKDOx1kQ44WsA1z7kCIQmmTjL0q4kaMdZnxn/GIYLpv7QExwZDxAUA8zkpjoener3uE9SdV5mkMNEHJgGMLCZc9/8Yg0/5GqIfqQ8eM7V+hoz0ImjjUFZMtRE0NizItNU0Wz4P1Xwv22flDDcXIOFtUozArRpSb19uCg=
Message-ID: <483998EC.5080805@gmail.com>
Date: Sun, 25 May 2008 18:50:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] SERIAL:  Simplify code using ARRAY_SIZE() macro.
References: <alpine.LFD.1.10.0805250735560.23325@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0805250735560.23325@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2008 01:37 PM, Robert P. J. Day wrote:
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
>  drivers/serial/68328serial.c |    6 +++---
>  drivers/serial/mcfserial.c   |    5 ++---
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
> index bbf5bc5..71c56c1 100644
> --- a/drivers/serial/68328serial.c
> +++ b/drivers/serial/68328serial.c
[...]
> @@ -1413,10 +1413,10 @@ static void m68328_set_baud(void)
>  	USTCNT = ustcnt & ~USTCNT_TXEN;
> 
>  again:
> -	for (i = 0; i < sizeof(baud_table) / sizeof(baud_table[0]); i++)
> +	for (i = 0; i < BAUD_TABLE_SIZE); i++)

typo? does this compile?
