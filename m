Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbXJXPZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbXJXPZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbXJXPZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:25:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXJXPZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:25:30 -0400
Date: Wed, 24 Oct 2007 11:25:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix "format '%d' expects type 'int', but argument 7 has type 'long unsigned int'" warning
Message-ID: <20071024152516.GA6793@tuxdriver.com>
References: <200710241637.08224.mboton.lkml@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710241637.08224.mboton.lkml@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Third submission of a patch like this since day before yesterday...I promise, I have it.

Please send wireless patches to linux-wireless@vger.kernel.org, and CC me.

BTW, this patch appears to be linewrap-damaged...

Thanks,

John

On Wed, Oct 24, 2007 at 04:37:08PM +0200, Miguel Botón wrote:
> printf() expects an "integer" value but we give it a "long unsigned integer".
> 
> diff -ruN linux-2.6.24-rc1.orig/net/mac80211/ieee80211_sta.c 
> linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c
> --- linux-2.6.24-rc1.orig/net/mac80211/ieee80211_sta.c  2007-10-24 
> 16:06:49.000000000 +0200
> +++ linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c       2007-10-24 
> 16:12:05.000000000 +0200
> @@ -1182,7 +1182,7 @@
>  	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
> 
>  	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=0x%x "
> -	       "status=%d aid=%d)\n",
> +	       "status=%d aid=%ld)\n",
>  	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
>  	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));
>  
> 
> -- 
> 	Miguel Botón

-- 
John W. Linville
linville@redhat.com
