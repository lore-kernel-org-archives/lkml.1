Return-Path: <linux-kernel-owner+w=401wt.eu-S934214AbXHGAlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbXHGAlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 20:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933346AbXHGAla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 20:41:30 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2634 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933519AbXHGAl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 20:41:28 -0400
Date: Mon, 6 Aug 2007 20:11:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: acme@ghostprotocols.net, Jeff Garzik <jgarzik@pobox.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] drivers/net/wireless/wl3501_cs.c: remove redundant
	memset
Message-ID: <20070807001155.GA3285@tuxdriver.com>
References: <200708070050.23158.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708070050.23158.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please send wireless patches to linux-wireless@vger.kernel.org,
and CC me.

Thanks!

John

On Tue, Aug 07, 2007 at 12:50:22AM +0200, Mariusz Kozlowski wrote:
> Hello,
> 
> 	This memset() looks superfluous.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/net/wireless/wl3501_cs.c | 58885 -> 58858 (-27 bytes)
>  drivers/net/wireless/wl3501_cs.o | 200252 -> 200000 (-252 bytes)
> 
>  drivers/net/wireless/wl3501_cs.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- linux-2.6.23-rc1-mm2-a/drivers/net/wireless/wl3501_cs.c	2007-08-01 08:43:46.000000000 +0200
> +++ linux-2.6.23-rc1-mm2-b/drivers/net/wireless/wl3501_cs.c	2007-08-07 00:34:36.000000000 +0200
> @@ -1841,7 +1841,6 @@ static int wl3501_get_encode(struct net_
>  	tocopy = min_t(u8, len_keys, wrqu->encoding.length);
>  	tocopy = min_t(u8, tocopy, 100);
>  	wrqu->encoding.length = tocopy;
> -	memset(extra, 0, tocopy);
>  	memcpy(extra, keys, tocopy);
>  out:
>  	return rc;
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
John W. Linville
linville@tuxdriver.com
