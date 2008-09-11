Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYIKNsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYIKNsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYIKNrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:47:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:21560 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbYIKNrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=A1iIJ39SiQaiKXpn3TInfWpQ64HttehVmzumTXOu3mmmWY1MRS6RqSKGKJaXmqoE4g
         aQpY4vePjS7MorCpBdf5+Xdk00kCgRYFRP5H20QLwndc6V0e/HEf7ve2WC7eiNPntyZb
         LVci7sZDX0CxIosdpPOsXeloIvy1Dcp+Q4B3g=
Message-ID: <80b317760809110647w1659ceffia363cc55c295b631@mail.gmail.com>
Date: Thu, 11 Sep 2008 15:47:14 +0200
From: "Richard Genoud" <richard.genoud@gmail.com>
To: "Julia Lawall" <julia@diku.dk>
Subject: Re: [PATCH 4/5] net/atm/lec.c: Drop code after return
Cc: chas@cmf.nrl.navy.mil, vigneshbabu@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0809111433510.9593@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0809111433510.9593@pc-004.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/11 Julia Lawall <julia@diku.dk>:
> From: Julia Lawall <julia@diku.dk>
>
> The break after the return serves no purpose.
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>
>  net/atm/lec.c                 |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/net/atm/lec.c b/net/atm/lec.c
> index 5799fb5..8f701cd 100644
> --- a/net/atm/lec.c
> +++ b/net/atm/lec.c
> @@ -1931,7 +1931,6 @@ static struct atm_vcc *lec_arp_resolve(struct lec_priv *priv,
>                switch (priv->lane_version) {
>                case 1:
>                        return priv->mcast_vcc;
> -                       break;
>                case 2: /* LANE2 wants arp for multicast addresses */
>                        if (!compare_ether_addr(mac_to_find, bus_mac))
>                                return priv->mcast_vcc;
>
