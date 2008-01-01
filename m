Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYAASne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYAASne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 13:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYAASnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 13:43:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:9606 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbYAASnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 13:43:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rf6USnviSPlmSovbrEQDNGvaqqcrVOhkt9Blb/8wyHZt8h0GF2NFIB5H4pS+abHJBDZVIapY3s777vQBTgmqPe2kAQXqc1uIP+7uBfm9/yIrt2Zob5KdVeTXrv9GgJb6ylnaFnEaWeFYjsFDUrViiClaltFmdV1oa90TGDiIMks=
Message-ID: <6101e8c40801011043k209e1db6t1f5877b1c034c865@mail.gmail.com>
Date: Tue, 1 Jan 2008 19:43:23 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>, stable@kernel.org
Subject: Re: [2.6 patch] OSS msnd: fix array overflows
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080101134921.GQ2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080101134921.GQ2360@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

then it is auch to 2.6.22-stable?

On 1/1/08, Adrian Bunk <bunk@kernel.org> wrote:
> This patch fixes array overflows in the OSS msnd driver spotted by the
> Coverity checker.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
> This patch has been sent on:
> - 27 Oct 2007
>
> 97463a59dfb9ccb915d3b615225c98cb3e310c0a
> diff --git a/sound/oss/msnd.h b/sound/oss/msnd.h
> index 05cf786..d0ca582 100644
> --- a/sound/oss/msnd.h
> +++ b/sound/oss/msnd.h
> @@ -233,8 +233,8 @@ typedef struct multisound_dev {
>  	spinlock_t lock;
>  	int nresets;
>  	unsigned long recsrc;
> -	int left_levels[16];
> -	int right_levels[16];
> +	int left_levels[32];
> +	int right_levels[32];
>  	int mixer_mod_count;
>  	int calibrate_signal;
>  	int play_sample_size, play_sample_rate, play_channels;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
