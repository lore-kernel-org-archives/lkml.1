Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZAIUbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZAIUbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZAIUap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:30:45 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38591 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbZAIUan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:30:43 -0500
Date: Fri, 9 Jan 2009 15:18:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/1 #2] IWL: fix WARN typo
Message-ID: <20090109201759.GE3371@tuxdriver.com>
References: <1231171404-22822-1-git-send-email-jirislaby@gmail.com> <1231171566-22984-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231171566-22984-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is the way it is now problematic for non-native English speakers?
Or native ones for that matter?

Dropping an article in a "computer-ese" statement has never bothered
me, so this seems like just a handful of unnecessary string bytes?

John

On Mon, Jan 05, 2009 at 05:06:06PM +0100, Jiri Slaby wrote:
> new kew -> a new key
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-sta.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
> index 412f66b..ce2ba40 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-sta.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
> @@ -638,7 +638,7 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
>  	 * in uCode. */
>  
>  	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
> -		"no space for new kew");
> +		"no space for a new key");
>  
>  	priv->stations[sta_id].sta.key.key_flags = key_flags;
>  	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
> @@ -686,7 +686,7 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
>  	 * in uCode. */
>  
>  	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
> -		"no space for new kew");
> +		"no space for a new key");
>  
>  	priv->stations[sta_id].sta.key.key_flags = key_flags;
>  	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
> @@ -722,7 +722,7 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
>  	 * in uCode. */
>  
>  	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
> -		"no space for new kew");
> +		"no space for a new key");
>  
>  	/* This copy is acutally not needed: we get the key with each TX */
>  	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
> -- 
> 1.6.0.6
> 
> 

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
