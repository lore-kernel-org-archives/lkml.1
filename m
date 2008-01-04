Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYADWQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYADWQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYADWQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:16:41 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:60356 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbYADWQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:16:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Subject: Re: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
Date: Fri, 4 Jan 2008 23:15:26 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       yi.zhu@intel.com, linville@tuxdriver.com
References: <200801042305.55188.mboton@gmail.com>
In-Reply-To: <200801042305.55188.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801042315.26817.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2008 23:05:54 Miguel Botón wrote:
> This patch fixes a compilation warning in 'iwl-4965.c'.
> 
> Signed-off-by: Miguel Botón <mboton@gmail.com>
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index 74999af..92237cd 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -3616,7 +3616,7 @@ static void iwl4965_add_radiotap(struct iwl4965_priv *priv,
>  	if (skb_headroom(skb) < sizeof(*iwl4965_rt)) {
>  		if (net_ratelimit())
>  			printk(KERN_ERR "not enough headroom [%d] for "
> -			       "radiotap head [%d]\n",
> +			       "radiotap head [%ld]\n",
>  			       skb_headroom(skb), sizeof(*iwl4965_rt));

I think %zu is the correct and portable integer conversion for a size_t type.
The kernel implementation seems to support it.

-- 
Greetings Michael.
