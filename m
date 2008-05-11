Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYEKJHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYEKJHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 05:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYEKJHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 05:07:24 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:36446 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYEKJHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 05:07:24 -0400
Date: Sun, 11 May 2008 11:07:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: SiByte: Mark i2c_sibyte_add_bus() as static
Message-ID: <20080511110708.57aedfa6@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805110311170.18978@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805110311170.18978@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008 03:14:05 +0100 (BST), Maciej W. Rozycki wrote:
>  The i2c_sibyte_add_bus() function is not called, nor meant to, from 
> outside, so mark it as static; fixing a sparse warning too.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  It should be obvious.  Please apply.
> 
>   Maciej
> 
> patch-2.6.26-rc1-20080505-sibyte-i2c-sparse-16
> diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c
> --- linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c	2008-05-05 02:55:25.000000000 +0000
> +++ linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c	2008-05-11 01:11:00.000000000 +0000
> @@ -132,7 +132,7 @@ static const struct i2c_algorithm i2c_si
>  /*
>   * registering functions to load algorithms at runtime
>   */
> -int __init i2c_sibyte_add_bus(struct i2c_adapter *i2c_adap, int speed)
> +static int __init i2c_sibyte_add_bus(struct i2c_adapter *i2c_adap, int speed)
>  {
>  	struct i2c_algo_sibyte_data *adap = i2c_adap->algo_data;
>  

Applied, thanks.

-- 
Jean Delvare
