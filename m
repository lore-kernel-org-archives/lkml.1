Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZLDOBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZLDOBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZLDOB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:01:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64248 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbZLDOB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :organization:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=GQ3ck+raEDnokwvfXSQZ4VYwzXNSn/02G+9n4T3SP4HukFvW6lKqr24Ogbrh9/uXhT
         g91CAl8gnXWMrNksCRouYtt4l270rivvdh/0iMkIPV1r7MXFkolCbmjFvdSbbdO+cWtU
         NUp/PqnMITPBD2Fpo+QC20bNtRdqMO6gzHpfw=
From: Florian Fainelli <florian@openwrt.org>
To: Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: use default-on trigger for Cobalt Qube
Date: Fri, 4 Dec 2009 15:01:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-server; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Martin Michlmayr <tbm@cyrius.com>, Sameer Verma <sverma@sfsu.edu>
References: <200911261941.02431.florian@openwrt.org>
In-Reply-To: <200911261941.02431.florian@openwrt.org>
Organization: OpenWrt
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912041501.37415.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard,

Did you get this patch? Thanks.

On Thursday 26 November 2009 19:41:02 Regards, Florian Fainelli wrote:
> This patch changes the default trigger from "ide-disk"
> to "default-on". Users updating from kernels not having this
> LED driver will prefer having the same LED behavior as they
> used to.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
> diff --git a/drivers/leds/leds-cobalt-qube.c
>  b/drivers/leds/leds-cobalt-qube.c index 8816806..81b2014 100644
> --- a/drivers/leds/leds-cobalt-qube.c
> +++ b/drivers/leds/leds-cobalt-qube.c
> @@ -31,7 +31,7 @@ static struct led_classdev qube_front_led = {
>  	.name			= "qube::front",
>  	.brightness		= LED_FULL,
>  	.brightness_set		= qube_front_led_set,
> -	.default_trigger	= "ide-disk",
> +	.default_trigger	= "default-on",
>  };
> 
>  static int __devinit cobalt_qube_led_probe(struct platform_device *pdev)
> 

-- 
Regards, Florian
