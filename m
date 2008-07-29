Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbYG2ImR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbYG2ImR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYG2ImE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:42:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:41241 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbYG2ImD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AYWFTrOmGs9c5sAQZxueDbUgTccMCuWImrbZaaIsUJ1TmlUXmhRnFyGHDNzn1gNBYD
         EZQXW0E1dohaXLiiZf3QrZmLHmticVK+75v/8asNVfCRbppxty7suHKqISow9LV8VkqF
         Yam2l8JoHipkiosWrK5epQ7DL9wPm3M694EfM=
Message-ID: <1ba2fa240807290142r3484ef6bq492b8ed108ba8c32@mail.gmail.com>
Date: Tue, 29 Jul 2008 11:42:03 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "=?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?=" 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH] iwlwifi: fix iwl-led compile issue when CONFIG_IWLWIFI_DEBUG is not set
Cc: yi.zhu@intel.com, reinette.chatre@intel.com,
       ipw3945-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "Denis V. Lunev" <den@openvz.org>
In-Reply-To: <1217311122.3087.55.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1217311122.3087.55.camel@sebastian.kern.oss.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 8:58 AM, Fernando Luis Vázquez Cao
<fernando@oss.ntt.co.jp> wrote:
> Fix compile error when CONFIG_IWLWIFI_DEBUG not defined.
>
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
>
> --- linux-2.6.27-rc1/drivers/net/wireless/iwlwifi/iwl-led.c     2008-07-29 13:51:26.000000000 +0900
> +++ linux-2.6.27-rc1-iocontext/drivers/net/wireless/iwlwifi/iwl-led.c   2008-07-29 14:47:13.000000000 +0900
> @@ -194,9 +194,10 @@ static void iwl_led_brightness_set(struc
>        if (test_bit(STATUS_EXIT_PENDING, &priv->status))
>                return;
>
> -
> +#ifdef CONFIG_IWLWIFI_DEBUG
>        IWL_DEBUG_LED("Led type = %s brightness = %d\n",
>                        led_type_str[led->type], brightness);
> +#endif /* CONFIG_IWLWIFI_DEBUG */
>        switch (brightness) {
>        case LED_FULL:
>                if (led->type == IWL_LED_TRG_ASSOC)

NACK
Fixes were already sent out find them on the milling list
Tomas
