Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbZDIJnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbZDIJnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758806AbZDIJnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:43:03 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37215 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758324AbZDIJnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:43:01 -0400
X-Sasl-enc: ow791Uhr3GQCQC57w+b7xO3kSw3KYrijJpGtPQTiajbh 1239270180
Message-ID: <49DDC321.60509@fastmail.fm>
Date: Thu, 09 Apr 2009 10:42:57 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, chas@cmf.nrl.navy.mil
Subject: Re: [PATCH 03/56] atm: Remove void casts
References: <> <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
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
>  drivers/atm/lanai.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
> index cf97c34..2c9d0da 100644
> --- a/drivers/atm/lanai.c
> +++ b/drivers/atm/lanai.c
> @@ -1459,7 +1459,7 @@ static int __devinit vcc_table_allocate(struct lanai_dev *lanai)
>  	return (lanai->vccs == NULL) ? -ENOMEM : 0;
>  #else
>  	int bytes = (lanai->num_vci) * sizeof(struct lanai_vcc *);
> -	lanai->vccs = (struct lanai_vcc **) vmalloc(bytes);
> +	lanai->vccs = vmalloc(bytes);
>  	if (unlikely(lanai->vccs == NULL))
>  		return -ENOMEM;
>  	memset(lanai->vccs, 0, bytes);
>   

