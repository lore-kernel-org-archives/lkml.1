Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbXJ1Kpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbXJ1Kpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 06:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbXJ1Kpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 06:45:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50057 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbXJ1Kpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 06:45:46 -0400
Message-ID: <4724684F.3000106@garzik.org>
Date: Sun, 28 Oct 2007 06:45:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: Johannes Berg <johannes@sipsolutions.net>, Joe Jezak <josejx@gentoo.org>,
       Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix printk() format string
References: <472473D2.8040102@freemail.hu>
In-Reply-To: <472473D2.8040102@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Get rid of the following compiler warning message:
> 
> net/mac80211/ieee80211_sta.c: In function 'ieee80211_rx_mgmt_assoc_resp':
> net/mac80211/ieee80211_sta.c:1187: warning: format '%d' expects type 'int', but argument 7 has type 'long unsigned int'
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> --- linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c.orig	2007-10-24 05:50:57.000000000 +0200
> +++ linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c	2007-10-28 11:20:23.000000000 +0100
> @@ -1182,7 +1182,7 @@ static void ieee80211_rx_mgmt_assoc_resp
>  	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
> 
>  	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=0x%x "
> -	       "status=%d aid=%d)\n",
> +	       "status=%d aid=%lu)\n",
>  	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
>  	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));

Fix already went upstream...


