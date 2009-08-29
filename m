Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbZH2NXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbZH2NXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZH2NXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:23:15 -0400
Received: from bamako.nerim.net ([62.4.17.28]:59662 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbZH2NXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:23:14 -0400
Date: Sat, 29 Aug 2009 15:23:14 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] I2C: i2c-core, make attr groups const
Message-ID: <20090829152314.4731af0f@hyperion.delvare>
In-Reply-To: <1250966092-28291-1-git-send-email-jirislaby@gmail.com>
References: <1250966092-28291-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Aug 2009 20:34:52 +0200, Jiri Slaby wrote:
> Make attribute_group structure const, to avoid a compiler warning.
> 
> The groups were introduces by commit:
> i2c: Convert i2c adapters to bus devices
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/i2c/i2c-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index eeb9ae5..8d80fce 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -214,7 +214,7 @@ static struct attribute_group i2c_dev_attr_group = {
>  	.attrs		= i2c_dev_attrs,
>  };
>  
> -static struct attribute_group *i2c_dev_attr_groups[] = {
> +static const struct attribute_group *i2c_dev_attr_groups[] = {
>  	&i2c_dev_attr_group,
>  	NULL
>  };
> @@ -528,7 +528,7 @@ static struct attribute_group i2c_adapter_attr_group = {
>  	.attrs		= i2c_adapter_attrs,
>  };
>  
> -static struct attribute_group *i2c_adapter_attr_groups[] = {
> +static const struct attribute_group *i2c_adapter_attr_groups[] = {
>  	&i2c_adapter_attr_group,
>  	NULL
>  };

Merged into the faulty patches, thanks for reporting.

-- 
Jean Delvare
