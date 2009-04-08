Return-Path: <linux-kernel-owner+w=401wt.eu-S933338AbZDHL64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbZDHL64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932638AbZDHLhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:37:33 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37899 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbZDHLhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EhGQw7AHxIAWSID23UsMtfT6Bz1HxACjd1Bw2oayc3tVWx9C0HLodT2cs4zW5Sw/lE
         J6/RL5MHt3PlvTIzoXpvrCUFHsAF5rAPFGmUq6UyPHylr6hQFauf9VkvCNsauyiGaEq3
         JadY11RjEyuLZPk2Rrp0vjdZJRVPM3LIDeZfQ=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 13:37:28 +0200
Message-ID: <36ca99e90904080437g55286754kd13b16ccc5139cb@mail.gmail.com>
Subject: Re: [PATCH 18/56] isdn: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 13:21, Jack Stone <jwjstone@fastmail.fm> wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  drivers/isdn/hardware/eicon/capifunc.c  |    2 +-
>  drivers/isdn/hardware/eicon/diddfunc.c  |    2 +-
>  drivers/isdn/hardware/eicon/divasfunc.c |    2 +-
>  drivers/isdn/hardware/eicon/divasi.c    |   27 ++++++++-------------------
>  drivers/isdn/hardware/eicon/idifunc.c   |    2 +-
>  drivers/isdn/hardware/eicon/mntfunc.c   |    2 +-
>  drivers/isdn/hardware/eicon/s_4bri.c    |    2 +-
>  drivers/isdn/hardware/eicon/um_idi.c    |    7 ++-----
>  8 files changed, 16 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/isdn/hardware/eicon/divasi.c b/drivers/isdn/hardware/eicon/divasi.c
> index 69e71eb..9021581 100644
> --- a/drivers/isdn/hardware/eicon/divasi.c
> +++ b/drivers/isdn/hardware/eicon/divasi.c
> @@ -238,8 +238,7 @@ um_idi_read(struct file *file, char __user *buf, size_t count, loff_t * offset)
>        }
>
>        if (!
> -           (p_os =
> -            (diva_um_idi_os_context_t *) diva_um_id_get_os_context(file->
> +           (p_os = diva_um_id_get_os_context(file->
>                                                                    private_data)))
Move this line up.

>        {
And this brace too (or remove the brace all together, because its one
line statement body).

>                return (-ENODEV);
> @@ -329,8 +328,7 @@ um_idi_write(struct file *file, const char __user *buf, size_t count,
>                        return (-ENODEV);
>        }
>
> -       if (!(p_os =
> -            (diva_um_idi_os_context_t *) diva_um_id_get_os_context(file->
> +       if (!(p_os = diva_um_id_get_os_context(file->
>                                                                    private_data)))
Dito.

>        {
Dito.

>                return (-ENODEV);

Bert
