Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZLAOUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZLAOUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbZLAOUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:20:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:36051 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZLAOUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:20:09 -0500
Date: Tue, 1 Dec 2009 15:20:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ping Cheng <pingc@wacom.com>
Cc: linux-kernel@vger.kernel.org, pinglinux@gmail.com,
       Alan Cox <alan@etchedpixels.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial/8250_pnp.c: add new Wacom devices
In-Reply-To: <6753EB6004AFF34FAA275742C104F952016A12D0@wacom-nt10.wacom.com>
Message-ID: <alpine.LRH.2.00.0912011519260.9567@twin.jikos.cz>
References: <6753EB6004AFF34FAA275742C104F952BDD5E0@wacom-nt10.wacom.com> <6753EB6004AFF34FAA275742C104F952016A12D0@wacom-nt10.wacom.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added CCs ]

On Mon, 30 Nov 2009, Ping Cheng wrote:

> This is a resend. I forgot to update the subject line last time. I am
> not in the mailing list. Please cc me with your reply.  Thank you.
> 
> 
> Add 10 serial Wacom Tablet PC devices. In fact, 
> The last 3 bytes of WACF### are all reserved 
> for Wacom serial OEMs.
> 
> Signed-off-by: Ping Cheng <pingc@wacom.com>
> ---
>  drivers/serial/8250_pnp.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
> index d71dfe3..898c0f0 100644
> --- a/drivers/serial/8250_pnp.c
> +++ b/drivers/serial/8250_pnp.c
> @@ -337,6 +337,15 @@ static const struct pnp_device_id pnp_dev_table[] =
> {
>  	{       "WACF00A",              0       },
>  	{       "WACF00B",              0       },
>  	{       "WACF00C",              0       },
> +	{       "WACF00D",              0       },
> +	{       "WACF00E",              0       },
> +	{       "WACF00F",              0       },
> +	{       "WACF010",              0       },
> +	{       "WACF011",              0       },
> +	{       "WACF012",              0       },
> +	{       "WACF013",              0       },
> +	{       "WACF014",              0       },
> +	{       "WACF015",              0       },
>  	/* Compaq touchscreen */
>  	{       "FPI2002",              0 },
>  	/* Fujitsu Stylistic touchscreens */
> @@ -354,6 +363,8 @@ static const struct pnp_device_id pnp_dev_table[] =
> {
>  	{	"FUJ02E5",		0	},
>  	/* Fujitsu P-series tablet PC device */
>  	{	"FUJ02E6",		0	},
> +	/* Fujitsu Wacom Tablet PC device */
> +	{	"FUJ02E7",		0	},
>  	/*
>  	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a
> FUJ02E6 in
>  	 * disguise)
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

