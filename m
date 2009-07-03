Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbZGCQyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbZGCQyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbZGCQyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:54:40 -0400
Received: from smtp106.sbc.mail.gq1.yahoo.com ([67.195.14.109]:28557 "HELO
	smtp106.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755281AbZGCQyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:54:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eJtCfQ+Nym7LgzsexTz8ipUSadnlt6Qnj1CBZrbzUqffD8EXVx8BmXcP7bO5SG7tPJUzqYZJwc9+BIms/7GKfnzdaH7/+Cl0YMNxA/jcTSVaR69zBMk3+6u09452P0r6w7JULP0QZZF/G2fS9YKNMGA5MjMf5E1jbZSxNSuwiGo=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: nYKFe3kVM1lpVUaox4fCoy7PmMnjXLSk.k.XsHbbfoTs.87tyRW5_jgntn2ZiZ3s4xRlpHG9Ihr1aS3uXo.NpsHkRKMNh4nQ6BLz47CxzIF1wdgqQweQy3U1n9hByEy51ZhiBkBu6f93w6qEDaM5upjs3JHp9eKfvBnDrhAS3mbhM6HH0TrPHCyHHPifrnm6L26eh5QQgzVgVUvITXMf9f.XnVVN4yKwcRiLXgi5B8vwL8CNusAQgE9Li3inJeQqareCQ8Tt5YSlJGuaeIKc3I4Me4XRgIvi.OtfICzW6DpzKpA7NiDXSNbw6_FCMxKujTRlD6HyFMdeVDIkoJD45LszPq97YBCc_D1C
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alek Du <alek.du@intel.com>
Subject: Re: [PATCH] gpio: pca953x: Add support for MAX7315
Date: Fri, 3 Jul 2009 09:54:42 -0700
User-Agent: KMail/1.9.10
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090703210803.24927aa2@dxy.sh.intel.com>
In-Reply-To: <20090703210803.24927aa2@dxy.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907030954.42458.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009, Alek Du wrote:
> From eb473218a66568ee99d6be3904a0b95d67d0016e Mon Sep 17 00:00:00 2001
> From: Alek Du <alek.du@intel.com>
> Date: Wed, 1 Jul 2009 12:36:49 +0800
> Subject: [PATCH] gpio: pca953x: Add support for MAX7315
> 
> MAX7315 is pin and software compatible with PCA9534, so add it to
> the I2C device ID table of pca953x driver.
> http://www.datasheetcatalog.org/datasheet/maxim/MAX7315.pdf
> 
> Signed-off-by: Alek Du <alek.du@intel.com>
> Cc: David Brownell <david-b@pacbell.net>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
>  drivers/gpio/pca953x.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> index cdb6574..8ab1308 100644
> --- a/drivers/gpio/pca953x.c
> +++ b/drivers/gpio/pca953x.c
> @@ -40,6 +40,7 @@ static const struct i2c_device_id pca953x_id[] = {
>  	{ "pca9557", 8, },
>  
>  	{ "max7310", 8, },
> +	{ "max7315", 8, },
>  	{ "pca6107", 8, },
>  	{ "tca6408", 8, },
>  	{ "tca6416", 16, },
> -- 
> 1.6.0.4
> 
> 


