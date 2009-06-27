Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbZF0Ljt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbZF0Ljt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZF0Ljj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:39:39 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58405 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216AbZF0Ljj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:39:39 -0400
Date: Sat, 27 Jun 2009 19:39:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org
Subject: Re: [bisected][Oops] 2.6.31-rc1: tun
Message-ID: <20090627113937.GA22796@gondor.apana.org.au>
References: <20090627125354.12623679@mosly.slynet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090627125354.12623679@mosly.slynet.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 12:53:54PM +0300, Sergei Trofimovich wrote:
>
> It was rather straightforward to bisect[1]: bad state is nonworking (sometimes Oopsing
> as you can see in previous email) openvpn.
> 
> Reverting commit d55d87fdff8252d0e2f7c28c2d443aee17e9d70f against 
> v2.6.31-rc1-115-g442ce8a or against v2.6.31-rc1 stabilizes kernel and makes openvpn
> work again.

Should be fixed already with the patch that I forwarded you in
the previous email.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
