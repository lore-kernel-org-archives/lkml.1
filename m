Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbXJJJri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbXJJJri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 05:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXJJJr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 05:47:29 -0400
Received: from donetsk.donpac.ru ([80.254.111.38]:39903 "EHLO
	donetsk.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbXJJJr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 05:47:29 -0400
Date: Wed, 10 Oct 2007 13:47:14 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Maik Broemme <mbroemme@plusserver.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added support for Wacom WACF007 and WACF008 to serial
	pnp driver.
Message-ID: <20071010094714.GB30345@pazke.donpac.ru>
Mail-Followup-To: Maik Broemme <mbroemme@plusserver.de>,
	linux-kernel@vger.kernel.org
References: <20071010075558.GC10600@bart.intergenia.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010075558.GC10600@bart.intergenia.de>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 283, 10 10, 2007 at 09:55:58AM +0200, Maik Broemme wrote:
> Hi,
> 
> notebook manufacturer seems to built a newer Wacom pen enabled tablet to
> recent tablet pcs which are not recognized by the serial pnp driver.
> 
> Attached is a patch which makes the newer Wacom WACF007 and WACF008
> tablets useable with the serial driver. The device is fully compatible
> with it.
> 
> This is a resent of my mail two weeks ago to 'linux-serial' :)

Please resend with proper Signed-off-by: line.

> diff -Nur linux-2.6.23-rc8/drivers/serial/8250_pnp.c linux-2.6.23-rc8-newer-wacom/drivers/serial/8250_pnp.c
> --- linux-2.6.23-rc8/drivers/serial/8250_pnp.c	2007-09-28 17:14:07.000000000 +0200
> +++ linux-2.6.23-rc8-newer-wacom/drivers/serial/8250_pnp.c	2007-09-28 17:09:45.000000000 +0200
> @@ -327,6 +327,8 @@
>  	{	"WACF004",		0	},
>  	{	"WACF005",		0	},
>  	{       "WACF006",              0       },
> +	{       "WACF007",              0       },
> +	{       "WACF008",              0       },
>  	/* Compaq touchscreen */
>  	{       "FPI2002",              0 },
>  	/* Fujitsu Stylistic touchscreens */


-- 
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net
