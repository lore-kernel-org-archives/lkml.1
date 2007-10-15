Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbXJOPEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbXJOPEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbXJOPEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:04:24 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60808 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754341AbXJOPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:04:23 -0400
Message-ID: <4713815A.3020300@lwfinger.net>
Date: Mon, 15 Oct 2007 10:03:54 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: Adrian Bunk <bunk@kernel.org>, mb@bu3sch.de,
       John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [-mm Patch] drivers/net/wireless/b43legacy/main.c: initialize
 the	correct return value
References: <20071014175142.GN4211@stusta.de> <20071015115936.GP2444@hacking>
In-Reply-To: <20071015115936.GP2444@hacking>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> Initialize "err" in drivers/net/wireless/b43legacy/main.c::b43legacy_start()
> in case of returning an uninitialized value.
> 
> From: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
>  drivers/net/wireless/b43/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.23-mm1/drivers/net/wireless/b43legacy/main.c
> ===================================================================
> --- linux-2.6.23-mm1.orig/drivers/net/wireless/b43legacy/main.c
> +++ linux-2.6.23-mm1/drivers/net/wireless/b43legacy/main.c
> @@ -3306,7 +3306,7 @@ static int b43legacy_start(struct ieee80
>  	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
>  	struct b43legacy_wldev *dev = wl->current_dev;
>  	int did_init = 0;
> -	int err;
> +	int err = 0;
>  
>  	mutex_lock(&wl->mutex);

I sent the equivalent patch to John Linville yesterday.

Larry

