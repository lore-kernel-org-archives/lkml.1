Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbXKZXQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbXKZXQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbXKZXQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:16:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:9241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088AbXKZXQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:16:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,216,1194249600"; 
   d="scan'208";a="403482432"
Message-ID: <474B53BB.3030002@intel.com>
Date: Mon, 26 Nov 2007 15:16:11 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 31/59] drivers/net/ixgb: Add missing "space"
References: 1234567 <1195523331-15303-15-git-send-email-joe@perches.com> <1195523331-15303-16-git-send-email-joe@perches.com> <1195523331-15303-17-git-send-email-joe@perches.com> <1195523331-15303-18-git-send-email-joe@perches.com> <1195523331-15303-19-git-send-email-joe@perches.com> <1195523331-15303-20-git-send-email-joe@perches.com> <1195523331-15303-21-git-send-email-joe@perches.com> <1195523331-15303-22-git-send-email-joe@perches.com> <1195523331-15303-23-git-send-email-joe@perches.com> <1195523331-15303-24-git-send-email-joe@perches.com> <1195523331-15303-25-git-send-email-joe@perches.com> <1195523331-15303-26-git-send-email-joe@perches.com> <1195523331-15303-27-git-send-email-joe@perches.com> <1195523331-15303-28-git-send-email-joe@perches.com> <1195523331-15303-29-git-send-email-joe@perches.com> <1195523331-15303-30-git-send-email-joe@perches.com> <1195523331-15303-31-git-send-email-joe@perches.com> <1195523331-15303-32-git-send-email-joe@perches.com>
In-Reply-To: <1195523331-15303-32-git-send-email-joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2007 23:16:35.0483 (UTC) FILETIME=[6397BEB0:01C83082]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ixgbe/ixgbe_common.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ixgbe/ixgbe_common.c b/drivers/net/ixgbe/ixgbe_common.c
> index 512e3b2..b7e50bc 100644
> --- a/drivers/net/ixgbe/ixgbe_common.c
> +++ b/drivers/net/ixgbe/ixgbe_common.c
> @@ -950,7 +950,7 @@ s32 ixgbe_setup_fc(struct ixgbe_hw *hw, s32 packetbuf_num)
>  	u32 rmcs_reg;
>  
>  	if (packetbuf_num < 0 || packetbuf_num > 7)
> -		hw_dbg(hw, "Invalid packet buffer number [%d], expected range"
> +		hw_dbg(hw, "Invalid packet buffer number [%d], expected range "
>  		       "is 0-7\n", packetbuf_num);
>  
>  	frctl_reg = IXGBE_READ_REG(hw, IXGBE_FCTRL);

Jeff, please apply in case you didn't do so yet.

Acked-by: Auke Kok <auke-jan.h.kok@intel.com>

Auke
