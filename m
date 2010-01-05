Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069Ab0AEK3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab0AEK3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 05:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382Ab0AEK27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 05:28:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab0AEK26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 05:28:58 -0500
Date: Tue, 5 Jan 2010 11:28:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: kernel-janitors@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] w1: add __init/__exit macros to drivers/w1/w1.c
In-Reply-To: <1261471082-24233-1-git-send-email-peterhuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.1001051128080.2277@pobox.suse.cz>
References: <1261471082-24233-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, peterhuewe@gmx.de wrote:

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of
> 
> drivers/w1/w1.c
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/w1/w1.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
> index acc7e3b..ad5897d 100644
> --- a/drivers/w1/w1.c
> +++ b/drivers/w1/w1.c
> @@ -986,7 +986,7 @@ int w1_process(void *data)
>  	return 0;
>  }
>  
> -static int w1_init(void)
> +static int __init w1_init(void)
>  {
>  	int retval;
>  
> @@ -1034,7 +1034,7 @@ err_out_exit_init:
>  	return retval;
>  }
>  
> -static void w1_fini(void)
> +static void __exit w1_fini(void)
>  {
>  	struct w1_master *dev;
>  

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
