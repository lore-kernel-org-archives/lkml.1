Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbYD0BTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbYD0BTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 21:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYD0BTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 21:19:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:33899 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752564AbYD0BTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 21:19:12 -0400
Date: Sun, 27 Apr 2008 09:19:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
       netdev@vger.kernel.org
Subject: Re: [Patch]net/xfrm/xfrm_state.c: replace timer with delayed_work
Message-ID: <20080427011906.GB662@gondor.apana.org.au>
References: <20080217.000049.88383747.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217.000049.88383747.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 12:00:49AM +0800, WANG Cong wrote:
> 
> Also suggested by Herbert Xu, using workqueue is better than timer
> for net/xfrm/xfrm_state.c, so replace them with delayed_work.
> 
> Note that, this patch is not fully tested, just compile and
> run as a whole on an Intel Core Duo matchine. So should be
> in -mm first.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Miller <davem@davemloft.net>

As with the xfrm policy patch, the spin lock here needs to disable
BH.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
