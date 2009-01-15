Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbZAOJTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbZAOJTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZAOJSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:18:53 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:44718 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZAOJSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:18:51 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4 v2] hvc_console: remove tty->low_latency
Date: Thu, 15 Jan 2009 10:17:48 +0100
User-Agent: KMail/1.9.9
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Milton Miller <miltonm@bga.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Joe Peterson <joe@skyrush.com>, lkml <linux-kernel@vger.kernel.org>
References: <hvc-console-29-3-1@bga.com> <1231880644.22571.47.camel@pasglop> <20090115091544.GC895@cetus.boeblingen.de.ibm.com>
In-Reply-To: <20090115091544.GC895@cetus.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151017.48995.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
> ---
>  drivers/char/hvc_console.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> --- a/drivers/char/hvc_console.c
> +++ b/drivers/char/hvc_console.c
> @@ -318,8 +318,6 @@ static int hvc_open(struct tty_struct *t
>  	} /* else count == 0 */
> 
>  	tty->driver_data = hp;
> -	if (!hp->irq_requested)
> -		tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
> 
>  	hp->tty = tty;
> 
> 

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
