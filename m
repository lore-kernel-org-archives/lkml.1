Return-Path: <linux-kernel-owner+w=401wt.eu-S1762848AbZDIKXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762848AbZDIKXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbZDIKXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:23:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46131 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754895AbZDIKXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:23:38 -0400
X-Sasl-enc: 5mLqixNUlgZmY7ZHLicRUn9kJyPmRVhGPc5nyLXoLjTW 1239272617
Message-ID: <49DDCCA6.5080605@fastmail.fm>
Date: Thu, 09 Apr 2009 11:23:34 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: [PATCH 42/56] drivers/s390: Remove void casts
References: <> <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CCs]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  drivers/s390/net/qeth_core_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
> index c827d69..454e181 100644
> --- a/drivers/s390/net/qeth_core_main.c
> +++ b/drivers/s390/net/qeth_core_main.c
> @@ -1037,7 +1037,7 @@ static int qeth_is_1920_device(struct qeth_card *card)
>  	QETH_DBF_TEXT(SETUP, 2, "chk_1920");
>  
>  	ccwdev = card->data.ccwdev;
> -	chp_dsc = (struct channelPath_dsc *)ccw_device_get_chp_desc(ccwdev, 0);
> +	chp_dsc = ccw_device_get_chp_desc(ccwdev, 0);
>  	if (chp_dsc != NULL) {
>  		/* CHPP field bit 6 == 1 -> single queue */
>  		single_queue = ((chp_dsc->chpp & 0x02) == 0x02);
>   

