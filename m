Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbZGHVty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbZGHVty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbZGHVto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:49:44 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:65176 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbZGHVtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:49:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AAKKrK9R026sBfmnJb4QDQY1FcJIhz7N6wRPIokzQ94YmF2UGBzwzZTST1UXzbL367
         OhSOTaFL/aK7uizPQjg0epVdtzkA79tAvTAKsnOrHZl9ojzXUkicxoalRfkBPLirutpo
         +qFl+0iTMRBIqtSV16oHHoUIyGVYDvYZOH+Mc=
MIME-Version: 1.0
In-Reply-To: <4A54FB81.30302@gmail.com>
References: <4A54FB81.30302@gmail.com>
Date: Wed, 8 Jul 2009 22:49:41 +0100
Message-ID: <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com>
Subject: Re: [PATCH] wireless: fix supported cards for rtl8187
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linux wireless <linux-wireless@vger.kernel.org>,
       Przemyslaw Kulczycki <azrael@autocom.pl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 9:03 PM, Marcin Slusarz<marcin.slusarz@gmail.com> wrote:
> Different revisions of WUSB54GC-EU use different chipsets -
> v2 uses rtl8187, but v3 uses Ralink RT3070.
>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Przemyslaw Kulczycki <azrael@autocom.pl>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Linux wireless <linux-wireless@vger.kernel.org>
> ---
>  drivers/net/wireless/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index 5bc00db..7d5902d 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -431,7 +431,7 @@ config RTL8187
>          ASUS P5B Deluxe
>          Toshiba Satellite Pro series of laptops
>          Asus Wireless Link
> -         Linksys WUSB54GC-EU
> +         Linksys WUSB54GC-EU v2

Is there a v1, and what does it use?

>
>          Thanks to Realtek for their support!
>
> --
> 1.6.3.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
