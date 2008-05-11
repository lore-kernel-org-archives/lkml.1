Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYEKJFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYEKJFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 05:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYEKJFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 05:05:34 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:20579 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbYEKJFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 05:05:33 -0400
Date: Sun, 11 May 2008 11:05:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: SiByte: Correct a comment about frequency
Message-ID: <20080511110510.4d0d1c8e@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805110302400.18978@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805110302400.18978@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008 03:10:29 +0100 (BST), Maciej W. Rozycki wrote:
>  The frequency may have been once hardcoded to 100kHz, but currently it is
> passed as an argument to i2c_sibyte_add_bus(), so update the comment to
> match code.  While at it, reformat a nearby comment for consistency.  No
> functional changes.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  It should be obvious.  Please apply.
> 
>   Maciej
> 
> patch-2.6.26-rc1-20080505-sibyte-i2c-add-bus-16
> diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c
> --- linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c	2008-05-05 02:55:25.000000000 +0000
> +++ linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c	2008-05-11 01:14:30.000000000 +0000
> @@ -136,10 +136,10 @@ int __init i2c_sibyte_add_bus(struct i2c
>  {
>  	struct i2c_algo_sibyte_data *adap = i2c_adap->algo_data;
>  
> -	/* register new adapter to i2c module... */
> +	/* Register new adapter to i2c module... */
>  	i2c_adap->algo = &i2c_sibyte_algo;
>  
> -	/* Set the frequency to 100 kHz */
> +	/* Set the requested frequency. */
>  	csr_out32(speed, SMB_CSR(adap,R_SMB_FREQ));
>  	csr_out32(0, SMB_CSR(adap,R_SMB_CONTROL));
>  

Applied, thanks.

-- 
Jean Delvare
