Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXHPKWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXHPKWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 06:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXHPKWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 06:22:12 -0400
Received: from stinky.trash.net ([213.144.137.162]:61318 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441AbXHPKWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 06:22:00 -0400
Message-ID: <46C42545.3000509@trash.net>
Date: Thu, 16 Aug 2007 12:21:57 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       netfilter-devel@lists.netfilter.org, coreteam@netfilter.org,
       linux-kernel@vger.kernel.org
Subject: Re: [netfilter-core] Re: drivers/infiniband/mlx/mad.c misplaced ;
References: <20070815235825.GB17004@redhat.com>	<1187224811.5906.55.camel@localhost>  <46C3B428.4000003@intel.com> <1187234225.5906.73.camel@localhost>
In-Reply-To: <1187234225.5906.73.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
> index 74f9b14..bec4279 100644
> --- a/net/netfilter/xt_u32.c
> +++ b/net/netfilter/xt_u32.c
> @@ -36,7 +36,7 @@ static bool u32_match_it(const struct xt_u32 *data,
>  		at  = 0;
>  		pos = ct->location[0].number;
>  
> -		if (skb->len < 4 || pos > skb->len - 4);
> +		if (skb->len < 4 || pos > skb->len - 4)
>  			return false;
>  

Thanks, I already sent the same patch upstream one or two days ago.

