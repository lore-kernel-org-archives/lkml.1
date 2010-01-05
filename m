Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253Ab0AEKcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0AEKcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 05:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221Ab0AEKcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 05:32:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab0AEKcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 05:32:22 -0500
Date: Tue, 5 Jan 2010 11:32:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Karsten Keil <isdn@linux-pingi.de>,
       Andreas Eversberg <andreas@eversberg.eu>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 03/10] isdn/mISDN: add __init/__exit macros to
 drivers/isdn/mISDN/dsp_core.c
In-Reply-To: <200912220941.42370.PeterHuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.1001051132070.2277@pobox.suse.cz>
References: <200912220941.42370.PeterHuewe@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, Peter Huewe wrote:

> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/isdn/mISDN/dsp_core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
> index 43ff4d3..6eac588 100644
> --- a/drivers/isdn/mISDN/dsp_core.c
> +++ b/drivers/isdn/mISDN/dsp_core.c
> @@ -1114,7 +1114,7 @@ static struct Bprotocol DSP = {
>  	.create = dspcreate
>  };
>  
> -static int dsp_init(void)
> +static int __init dsp_init(void)
>  {
>  	int err;
>  	int tics;
> @@ -1212,7 +1212,7 @@ static int dsp_init(void)
>  }
>  
>  
> -static void dsp_cleanup(void)
> +static void __exit dsp_cleanup(void)
>  {
>  	mISDN_unregister_Bprotocol(&DSP);

Applied, thanks Peter.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
