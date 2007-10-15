Return-Path: <linux-kernel-owner+w=401wt.eu-S1764688AbXJOM4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764688AbXJOM4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759511AbXJOM4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:56:16 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58768 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759062AbXJOM4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:56:15 -0400
Date: Mon, 15 Oct 2007 14:56:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: mb@bu3sch.de, st3@riseup.net, Larry.Finger@lwfinger.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [-mm Patch] drivers/net/wireless/b43/main.c: fix an
	uninitialized variable
Message-ID: <20071015125644.GB5417@stusta.de>
References: <20071014175142.GN4211@stusta.de> <20071015113445.GO2444@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071015113445.GO2444@hacking>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 07:34:45PM +0800, WANG Cong wrote:
> 
> Fix an uninitialized variable in drivers/net/wireless/b43/main.c::b43_start().
> 
> From: Adrian Bunk <bunk@kernel.org>

A technical remark regarding these two patches:

These are your patches, not mine.

You can note formally or informally that I reported/forwarded these 
issues, but I'm neither in a legal sense the author of these patches nor
am I in a technical sense responsible for their correctness [1], and a 
From: tag is therefore not appropriate.

> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
>  drivers/net/wireless/b43/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.23-mm1/drivers/net/wireless/b43/main.c
> ===================================================================
> --- linux-2.6.23-mm1.orig/drivers/net/wireless/b43/main.c
> +++ linux-2.6.23-mm1/drivers/net/wireless/b43/main.c
> @@ -3495,7 +3495,7 @@ static int b43_start(struct ieee80211_hw
>  	struct b43_wl *wl = hw_to_b43_wl(hw);
>  	struct b43_wldev *dev = wl->current_dev;
>  	int did_init = 0;
> -	int err;
> +	int err = 0;
>  
>  	mutex_lock(&wl->mutex);

cu
Adrian

[1] they might or might not be correct (I don't know)

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

