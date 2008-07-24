Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYGXN0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYGXN0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYGXN0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:26:03 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:41208 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbYGXN0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:26:01 -0400
Date: Thu, 24 Jul 2008 17:25:21 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jerome Arbez-Gindre <jeromearbezgindre@gmail.com>
Cc: linux-kernel@vger.kernel.org, deweerdt@free.fr, akpm@linux-foundation.org
Subject: Re: [patch] Add a BlackBoard user to connector
Message-ID: <20080724132520.GB4126@2ka.mipt.ru>
References: <a1d7a2f20807240238r58b6e866u719806447476ac43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1d7a2f20807240238r58b6e866u719806447476ac43@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 11:38:45AM +0200, Jerome Arbez-Gindre (jeromearbezgindre@gmail.com) wrote:
> Add a BlackBoard user to connector. BlackBoard is part of the TSP
> GPL sampling framework (http://savannah.nongnu.org/p/tsp)
> 
> 
> Signed-off-by: Jerome Arbez-Gindre <jeromearbezgindre@gmail.com>

Ack.

Andrew, please apply.

Thanks everyone.

> diff --git a/include/linux/connector.h b/include/linux/connector.h
> index 96a89d3..d7ac97a 100644
> --- a/include/linux/connector.h
> +++ b/include/linux/connector.h
> @@ -38,8 +38,9 @@
>  #define CN_W1_VAL                      0x1
>  #define CN_IDX_V86D                    0x4
>  #define CN_VAL_V86D_UVESAFB            0x1
> +#define CN_IDX_BB                      0x5
> 
> -#define CN_NETLINK_USERS               5
> +#define CN_NETLINK_USERS               6
> 
>  /*
>  * Maximum connector's message size.

-- 
	Evgeniy Polyakov
