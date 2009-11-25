Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbZKYJmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbZKYJmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZKYJmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:42:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54599 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZKYJmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:42:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=NYb6MhdilrzAIA8LbwILzBbjYEMnHXTE4tu75ogiMJGBJNn2n9neOsGytNkESX68Z5
         GIgwovUl0D+wsBWxFz9RDYWl6VM2JtC2HJE2jKyvL34F8svL8Z6UE+0DuCWGCJS3mEOc
         SVAEO0Pi8bymE6rqF4L1htV4vMuRcY2psOSIQ=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: Yoichi Yuasa <yuasa@linux-mips.org>
Subject: Re: [PATCH] leds-cobalt: use resource_size()
Date: Wed, 25 Nov 2009 10:41:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-server; KDE/4.3.2; x86_64; ; )
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20091125133359.000d43c0.yuasa@linux-mips.org>
In-Reply-To: <20091125133359.000d43c0.yuasa@linux-mips.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251041.44776.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoichi,

On Wednesday 25 November 2009 05:33:59 Yoichi Yuasa wrote:
> Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
> Cc: Florian Fainelli <florian@openwrt.org>

Acked-by: Florian Fainelli <florian@openwrt.org>

> ---
>  drivers/leds/leds-cobalt-qube.c |    2 +-
>  drivers/leds/leds-cobalt-raq.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/leds/leds-cobalt-qube.c
>  b/drivers/leds/leds-cobalt-qube.c index 8816806..de19753 100644
> --- a/drivers/leds/leds-cobalt-qube.c
> +++ b/drivers/leds/leds-cobalt-qube.c
> @@ -43,7 +43,7 @@ static int __devinit cobalt_qube_led_probe(struct
>  platform_device *pdev) if (!res)
>  		return -EBUSY;
> 
> -	led_port = ioremap(res->start, res->end - res->start + 1);
> +	led_port = ioremap(res->start, resource_size(res));
>  	if (!led_port)
>  		return -ENOMEM;
> 
> diff --git a/drivers/leds/leds-cobalt-raq.c
>  b/drivers/leds/leds-cobalt-raq.c index defc212..438d483 100644
> --- a/drivers/leds/leds-cobalt-raq.c
> +++ b/drivers/leds/leds-cobalt-raq.c
> @@ -84,7 +84,7 @@ static int __devinit cobalt_raq_led_probe(struct
>  platform_device *pdev) if (!res)
>  		return -EBUSY;
> 
> -	led_port = ioremap(res->start, res->end - res->start + 1);
> +	led_port = ioremap(res->start, resource_size(res));
>  	if (!led_port)
>  		return -ENOMEM;
> 

-- 
--
WBR, Florian
