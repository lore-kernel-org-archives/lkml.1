Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbXIGPL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbXIGPL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbXIGPLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:11:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:58277 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459AbXIGPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fe2W57qFmO7kuqTEjsU1hOhf6IhNjNvnZGgtnZr6sGaoHetOjxS3V7PNRnPmxVrvxjG/jhpAquGRGd6eQmuiJwZti1Z42iVYiUYBVvSN13j67l1qI6T6YM0g0ofvJalEV/w4AurpKXZvVIMRpEaKN52+KM7K7sO1Y6MYpmcDorI=
Message-ID: <d120d5000709070811g3c129e40q8fe16fd29c213c8a@mail.gmail.com>
Date: Fri, 7 Sep 2007 11:11:45 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Anti Sullin" <anti.sullin@artecdesign.ee>
Subject: Re: [PATCH] Add suspend and resume to gpio_keys driver
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46E01EF7.7010605@artecdesign.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46E01EF7.7010605@artecdesign.ee>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anti,

On 9/6/07, Anti Sullin <anti.sullin@artecdesign.ee> wrote:
> diff -pur linux-2.6.23-rc5-old/drivers/input/keyboard/gpio_keys.c linux-2.6.23-rc5/drivers/input/keyboard/gpio_keys.c
> --- linux-2.6.23-rc5-old/drivers/input/keyboard/gpio_keys.c     2007-09-06 18:24:23.000000000 +0300
> +++ linux-2.6.23-rc5/drivers/input/keyboard/gpio_keys.c 2007-09-06 18:23:37.000000000 +0300
> @@ -59,6 +59,7 @@ static int __devinit gpio_keys_probe(str
>        if (!input)
>                return -ENOMEM;
>
> +       device_init_wakeup(&pdev->dev, 1);
>        platform_set_drvdata(pdev, input);

I would expect platform code to mark devices as wakeup-able, wouldn't you agree?

-- 
Dmitry
