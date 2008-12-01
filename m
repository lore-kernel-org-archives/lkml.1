Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYLAEsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYLAEsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 23:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYLAEsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 23:48:04 -0500
Received: from ozlabs.org ([203.10.76.45]:34056 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYLAEsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 23:48:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: next-2008-11-28: bfin vs cpumask fixlet
Date: Mon, 1 Dec 2008 15:17:57 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au> <20081128151755.GA27660@x200.localdomain>
In-Reply-To: <20081128151755.GA27660@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011517.57601.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2008 01:47:55 Alexey Dobriyan wrote:
> --- a/arch/blackfin/kernel/time-ts.c
> +++ b/arch/blackfin/kernel/time-ts.c
> @@ -162,7 +162,6 @@ static struct clock_event_device clockevent_bfin = {
>  	.name		= "bfin_core_timer",
>  	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
>  	.shift		= 32,
> -	.cpumask	= CPU_MASK_CPU0,

Thanks Alexey, applied.

I grepped harder, and this seems to be the last one.

Cheers,
Rusty.
