Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYGBTrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYGBTrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 15:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYGBTrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 15:47:06 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2208 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbYGBTrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:47:02 -0400
Date: Wed, 2 Jul 2008 15:24:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Darren Jenkins <darrenrjenkins@gmail.com>
Cc: kernel Janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, ipw2100-admin@linux.intel.com,
       yi.zhu@intel.com, reinette.chatre@intel.com
Subject: Re: [PATCH]  drivers/net/wireless/iwlwifi/iwl-3945.c
Message-ID: <20080702192457.GB31288@tuxdriver.com>
References: <1214962647.18261.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1214962647.18261.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What about the format line in the IWL_DEBUG_RX that uses rate?

Also, please use an email subject that is more descriptive than just
the filename.  You should probably drop the "G'day..." line as well.

Thanks!

John

On Wed, Jul 02, 2008 at 11:37:27AM +1000, Darren Jenkins" wrote:
> G'day people
> 
> Coverity CID: 2265 NEGATIVE_RETURNS
> 
> "rate" is of an unsigned type, and the code requires a signed type.
> The following patch makes it so.
> 
> Only compile tested.
> 
> ﻿Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index 62a3d8f..31d38cd 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -449,7 +449,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
>  
>  	if (print_summary) {
>  		char *title;
> -		u32 rate;
> +		int rate;
>  
>  		if (hundred)
>  			title = "100Frames";
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
John W. Linville
linville@tuxdriver.com
