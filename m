Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYLGH5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYLGH5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 02:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYLGH4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 02:56:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59399
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbYLGH4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 02:56:54 -0500
Date: Sat, 06 Dec 2008 23:56:55 -0800 (PST)
Message-Id: <20081206.235655.61233030.davem@davemloft.net>
To: nick@nick-andrew.net
Cc: den@openvz.org, xemul@openvz.org, yoshfuji@linux-ipv6.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix incorrect use of loose in wext.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081205030809.32393.55419.stgit@marcab.local.tull.net>
References: <20081205030809.32393.55419.stgit@marcab.local.tull.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:08:09 +1100

> Fix incorrect use of loose in wext.c
> 
> It should be 'lose', not 'loose'.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>

Applied to net-next-2.6, thanks Nick.

BTW, your original posting of this patch didn't make it to the mailing
lists because there were people's names on the CC: list which had a
"." character in them, and in such cases these names must be fully
surrounded by double quotes, otherwise it is an SMTP syntax error.

Please be mindful of this in the future.

> ---
> 
>  net/wireless/wext.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/net/wireless/wext.c b/net/wireless/wext.c
> index d98ffb7..e49a2d1 100644
> --- a/net/wireless/wext.c
> +++ b/net/wireless/wext.c
> @@ -64,7 +64,7 @@
>   *	o Remove spy_offset from struct iw_handler_def
>   *	o Start deprecating dev->get_wireless_stats, output a warning
>   *	o If IW_QUAL_DBM is set, show dBm values in /proc/net/wireless
> - *	o Don't loose INVALID/DBM flags when clearing UPDATED flags (iwstats)
> + *	o Don't lose INVALID/DBM flags when clearing UPDATED flags (iwstats)
>   *
>   * v8 - 17.02.06 - Jean II
>   *	o RtNetlink requests support (SET/GET)
> 
> 
