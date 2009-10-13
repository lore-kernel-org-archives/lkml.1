Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbZJMK13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbZJMK13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759345AbZJMK12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:27:28 -0400
Received: from host179-6-static.238-77-b.business.telecomitalia.it ([77.238.6.179]:39861
	"EHLO mail.navynet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbZJMK11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:27:27 -0400
Message-ID: <4AD455E4.2070105@navynet.it>
Date: Tue, 13 Oct 2009 12:26:44 +0200
From: Massimo Cetra <mcetra@navynet.it>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Massimo Cetra <ctrixk@navynet.it>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Bug #14378] Problems with net/core/skbuff.c
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>	<r-4Wjt4coy.A.CwC.Wal0KB@chimera> <20091012.034224.64980795.davem@davemloft.net> <4AD44435.3050703@navynet.it> <4AD45447.7030705@gmail.com>
In-Reply-To: <4AD45447.7030705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-auth-from: mcetra@navynet.it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet ha scritto:
> Could you please following patch ?
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8d00976..54bf091 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -454,7 +454,7 @@ static unsigned int free_old_xmit_skbs(struct virtnet_info *vi)
>  		vi->dev->stats.tx_bytes += skb->len;
>  		vi->dev->stats.tx_packets++;
>  		tot_sgs += skb_vnet_hdr(skb)->num_sg;
> -		kfree_skb(skb);
> +		dev_kfree_skb_any(skb);
>  	}
>  	return tot_sgs;
>  }
>
>
>   
Thank you very much.

Compiling.
It' will be in production in a few minutes.
I'll let you know if the problem arises again.
give me a couple of days because this problem is randomly triggered.
Sometimes it happens multiple times a day, sometimes none.

Max


