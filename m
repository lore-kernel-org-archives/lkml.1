Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYADWST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYADWST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYADWSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:18:10 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:53395 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbYADWSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:18:09 -0500
Date: Fri, 4 Jan 2008 14:15:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Miguel =?ISO-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       yi.zhu@intel.com, linville@tuxdriver.com
Subject: Re: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
Message-Id: <20080104141510.c7e80964.randy.dunlap@oracle.com>
In-Reply-To: <200801042305.55188.mboton@gmail.com>
References: <200801042305.55188.mboton@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008 23:05:54 +0100 Miguel Botón wrote:

> This patch fixes a compilation warning in 'iwl-4965.c'.

It would be helpful to have the warning message right here.<---

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
>  		return;
>  	}

sizeof() (or size_t) normally needs %zd.

---
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
