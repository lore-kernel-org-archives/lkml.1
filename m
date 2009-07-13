Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZGMUDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZGMUDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZGMUDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:03:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:29217 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbZGMUDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:03:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,392,1243839600"; 
   d="scan'208";a="474440887"
Subject: Re: [PATCH] iwlwifi 3945: Fix IWL_SCAN compile error
From: reinette chatre <reinette.chatre@intel.com>
To: Tim Gardner <timg@tpi.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090713190803.9A70BF8D2C@sepang.rtg.net>
References: <20090713190803.9A70BF8D2C@sepang.rtg.net>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 13:03:21 -0700
Message-Id: <1247515401.17896.1630.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Mon, 2009-07-13 at 12:08 -0700, Tim Gardner wrote:
> From 2c7c806570ad72f5af2e778f2fe71aae7d727e02 Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Mon, 13 Jul 2009 12:53:32 -0600
> Subject: [PATCH] iwlwifi 3945: Fix IWL_DEBUG_SCAN compile
> 
> Added a missing parameter in the macro invocation to correct a
> compile error when CONFIG_IWLWIFI_DEBUG is enabled.
> 
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 2564288..67332fb 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -2962,7 +2962,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
>  	}
>  
>  	if (scan->channel_count == 0) {
> -		IWL_DEBUG_SCAN("channel count %d\n", scan->channel_count);
> +		IWL_DEBUG_SCAN(priv,"channel count %d\n", scan->channel_count);
>  		goto done;
>  	}
>  

On which code did you base this patch?

Reinette


