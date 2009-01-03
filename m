Return-Path: <linux-kernel-owner+w=401wt.eu-S932917AbZACXcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbZACXcY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759941AbZACXcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:32:15 -0500
Received: from styx.suse.cz ([82.119.242.94]:46397 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759805AbZACXcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:32:15 -0500
Date: Sun, 4 Jan 2009 00:32:12 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][TRIVIAL] Add a space (and a comma) to a printk
In-Reply-To: <1230642403.13647.31.camel@test.thuisdomein>
Message-ID: <alpine.LNX.1.10.0901040031540.5377@jikos.suse.cz>
References: <1230642403.13647.31.camel@test.thuisdomein>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008, Paul Bolle wrote:

> Commit d87a6d9 ("drivers/serial/: remove CVS keywords") removed one
> space too many in the printk in serial8250_init(). Put it back in (and
> add a comma for clarity).
>     
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 303272a..31b3c08 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -3018,7 +3018,7 @@ static int __init serial8250_init(void)
>  	if (nr_uarts > UART_NR)
>  		nr_uarts = UART_NR;
>  
> -	printk(KERN_INFO "Serial: 8250/16550 driver"
> +	printk(KERN_INFO "Serial: 8250/16550 driver, "
>  		"%d ports, IRQ sharing %sabled\n", nr_uarts,
>  		share_irqs ? "en" : "dis");

Queued in trivial tree, thanks Paul.

-- 
Jiri Kosina
SUSE Labs
