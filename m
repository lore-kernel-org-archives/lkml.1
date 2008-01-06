Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYAFHPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYAFHPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 02:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYAFHP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 02:15:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52169
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYAFHPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 02:15:25 -0500
Date: Sat, 05 Jan 2008 23:15:24 -0800 (PST)
Message-Id: <20080105.231524.204142940.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: viro@ZenIV.linux.org.uk, m.kozlowski@tuxland.pl,
       sparclinux@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sparc oops in ip_fast_csum
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1JBJHA-0000hy-00@gondolin.me.apana.org.au>
References: <20080105094400.GH27894@ZenIV.linux.org.uk>
	<E1JBJHA-0000hy-00@gondolin.me.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sun, 06 Jan 2008 11:22:04 +1100

> [IPV4] raw: Strengthen check on validity of iph->ihl 
> 
> We currently check that iph->ihl is bounded by the real length and that
> the real length is greater than the minimum IP header length.  However,
> we did not check the caes where iph->ihl is less than the minimum IP
> header length.
> 
> This breaks because some ip_fast_csum implementations assume that which
> is quite reasonable.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, I'll push this to -stable too, thanks Herbert.
