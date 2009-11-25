Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbZKYJvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbZKYJvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514AbZKYJvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:51:48 -0500
Received: from host64.kissl.de ([213.239.241.64]:58431 "EHLO host64.kissl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758329AbZKYJvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:51:37 -0500
X-Greylist: delayed 1943 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2009 04:51:37 EST
Message-ID: <4B0CF685.6060208@lastsummer.de>
Date: Wed, 25 Nov 2009 10:19:01 +0100
From: Franco Fichtner <franco@lastsummer.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Roland Dreier <rolandd@cisco.com>,
       Yevgeny Petrilin <yevgenyp@mellanox.co.il>,
       Yang Hongyang <yanghy@cn.fujitsu.com>,
       Jack Morgenstein <jackm@dev.mellanox.co.il>,
       Eli Cohen <eli@mellanox.co.il>, netdev@vger.kernel.org
Subject: Re: [PATCH 10/38] don't wrap mlx4_remove_one in __devexit_p
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-9-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-10-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1259096853-18909-10-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
> diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
> index 291a505..a581860 100644
> --- a/drivers/net/mlx4/main.c
> +++ b/drivers/net/mlx4/main.c
> @@ -1293,7 +1293,7 @@ static struct pci_driver mlx4_driver = {
>  	.name		= DRV_NAME,
>  	.id_table	= mlx4_pci_table,
>  	.probe		= mlx4_init_one,
> -	.remove		= __devexit_p(mlx4_remove_one)
> +	.remove		= mlx4_remove_one
>   
You may want to add the trailing comma while you're at it...

>  };
>  
>  static int __init mlx4_verify_params(void)
>   

f
