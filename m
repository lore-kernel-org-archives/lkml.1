Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbZDIJmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbZDIJmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758324AbZDIJlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:41:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38781 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757050AbZDIJlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:41:51 -0400
X-Sasl-enc: sGtySd7mpgAB97BregZaFh7/zIO7clJ4aVoRIkuigh5o 1239270110
Message-ID: <49DDC2DB.4090504@fastmail.fm>
Date: Thu, 09 Apr 2009 10:41:47 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, rth@twiddle.net
Subject: Re: [PATCH 02/56] alpha: Remove void casts
References: <> <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  arch/alpha/boot/bootpz.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
> index 1036b51..6e7af60 100644
> --- a/arch/alpha/boot/bootpz.c
> +++ b/arch/alpha/boot/bootpz.c
> @@ -129,7 +129,7 @@ pal_init(void)
>  	pcb_va->flags = 1;
>  	pcb_va->res1 = 0;
>  	pcb_va->res2 = 0;
> -	pcb_pa = (struct pcb_struct *)find_pa((unsigned long)pcb_va);
> +	pcb_pa = find_pa((unsigned long)pcb_va);
>  
>  	/*
>  	 * a0 = 2 (OSF)
>   

