Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0BILzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 06:55:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:42151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab0BILzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 06:55:53 -0500
Subject: Re: [PATCH] iwmc3200wifi: Test of wrong pointer after kzalloc in
 iwm_mlme_update_bss_table()
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Zhu Yi <yi.zhu@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B7141FD.7050605@gmail.com>
References: <4B7141FD.7050605@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 12:55:45 +0100
Message-ID: <1265716545.2236.4.camel@caravaggio>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-09 at 12:07 +0100, Roel Kluin wrote:
> The wrong pointer was tested.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>


> ---
>  drivers/net/wireless/iwmc3200wifi/rx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
> index 6d6ed74..f727b4a 100644
> --- a/drivers/net/wireless/iwmc3200wifi/rx.c
> +++ b/drivers/net/wireless/iwmc3200wifi/rx.c
> @@ -794,7 +794,7 @@ static int iwm_mlme_update_bss_table(struct iwm_priv *iwm, u8 *buf,
>  	}
>  
>  	bss->bss = kzalloc(bss_len, GFP_KERNEL);
> -	if (!bss) {
> +	if (!bss->bss) {
>  		kfree(bss);
>  		IWM_ERR(iwm, "Couldn't allocate bss\n");
>  		return -ENOMEM;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


