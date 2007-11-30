Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbXK3Wzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbXK3Wzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbXK3Wzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:55:42 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2642 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbXK3Wzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:55:41 -0500
Date: Fri, 30 Nov 2007 17:55:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com
Subject: Re: [PATCH 1/2] mac80211: add power management support -v2
Message-ID: <20071130225525.GB31953@tuxdriver.com>
References: <200711170007.01676.mboton.lkml@gmail.com> <200711170113.58396.mboton.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200711170113.58396.mboton.lkml@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 01:13:58AM +0100, Miguel Botón wrote:

> This patch adds power management support in mac80211.
> 
> This allows us to enable power management through the "iwconfig <device> power <off/on>" command.
> The code is based on "mac80211-10.0.0" but it is a little bit modified.
> 
> Signed-off-by: Miguel Botón <mboton@gmail.com>
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 5fcc4c1..c82b6fa 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -452,6 +452,8 @@ struct ieee80211_conf {
>  	u8 antenna_max;
>  	u8 antenna_sel_tx;
>  	u8 antenna_sel_rx;
> +
> +	u8 power_management_enable;     /* flag to enable/disable power management */
>  };
>  
>  /**

I'm not overly happy with this.  What about folding this into the
flags variable?

John
-- 
John W. Linville
linville@tuxdriver.com
