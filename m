Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbXLEGvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbXLEGvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 01:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbXLEGvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 01:51:40 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3839 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750954AbXLEGvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 01:51:39 -0500
Date: Wed, 5 Dec 2007 17:51:32 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: simon@fire.lp0.eu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sockets affected by IPsec always block (2.6.23)
Message-ID: <20071205065132.GA11476@gondor.apana.org.au>
References: <4755A21F.2020407@simon.arlott.org.uk> <20071205001230.GA11391@gondor.apana.org.au> <20071204.223023.262159049.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204.223023.262159049.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 10:30:23PM -0800, David Miller wrote:
> 
> We made an explicit decision not to do things this way.

Thanks for pointing this out.

> Non-blocking has a meaning dependant upon the xfrm_larval_drop sysctl
> setting, and this is across the board.  If xfrm_larval_drop is zero,
> non-blocking semantics do not extend to IPSEC route resolution,
> otherwise it does.
> 
> If he sets this sysctl to "1" as I detailed in my reply, he'll
> get the behavior he wants.

Does anybody actually need the 0 setting? What would we break if
the default became 1?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
