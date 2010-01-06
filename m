Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367Ab0AFCxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab0AFCxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 21:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256Ab0AFCxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 21:53:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:4270 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab0AFCxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 21:53:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,226,1262592000"; 
   d="scan'208";a="481610545"
Subject: Re: [07/39] iwmc3200wifi: fix array out-of-boundary access
From: Zhu Yi <yi.zhu@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20100105200259.864447568@mini.kroah.org>
References: <20100105200259.864447568@mini.kroah.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 10:52:56 +0800
Message-ID: <1262746376.15653.93.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 04:02 +0800, Greg KH wrote:
> 2.6.31-stable review patch.  If anyone has any objections, please let us know.

Greg, please ignore this. It is false alarm and not required for stable.
Sorry for the noise.

Thanks,
-yi

> From: Zhu Yi <yi.zhu@intel.com>
> 
> commit 6c853da3f30c93eae847ecbcd9fdf10ba0da04c2 upstream.
> 
> Allocate priv->rx_packets[IWM_RX_ID_HASH + 1] because the max array
> index is IWM_RX_ID_HASH according to IWM_RX_ID_GET_HASH().
> 
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/net/wireless/iwmc3200wifi/iwm.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/net/wireless/iwmc3200wifi/iwm.h
> +++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
> @@ -268,7 +268,7 @@ struct iwm_priv {
>  
>  	struct sk_buff_head rx_list;
>  	struct list_head rx_tickets;
> -	struct list_head rx_packets[IWM_RX_ID_HASH];
> +	struct list_head rx_packets[IWM_RX_ID_HASH + 1];
>  	struct workqueue_struct *rx_wq;
>  	struct work_struct rx_worker;
>  
> 
> 


