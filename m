Return-Path: <linux-kernel-owner+w=401wt.eu-S934341AbYEBMCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341AbYEBMCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759985AbYEBMCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:02:15 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:44321 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751452AbYEBMCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:02:14 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: pupilla@hotmail.com (Marco Berizzi)
Subject: Re: 2.6.25 crash: EIP: [<c02e2f14>] xfrm_output_resume+0x64/0x100 ss:esp 0068:c03a1e5c
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Organization: Core
In-Reply-To: <BAY103-DAV12E9E0E5107A5FCEF3F473B2D90@phx.gbl>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Jrtxr-0004in-00@gondolin.me.apana.org.au>
Date: Fri, 02 May 2008 20:02:11 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Berizzi <pupilla@hotmail.com> wrote:
> Just few minutes ago, another 2.6.25 crash
> with this message:
> 
> EIP: [<c028000a>] netif_rx+0x6a/0xd0 SS:ESP 0068:c039f868
> 
> http://80.204.235.230/4.jpg

OK, the xfrm_output_resume trail revealed nothing.  Combined
with this crash however, it would appear that you've got a problem
with live skbs being freed.  Unfortunately such problems are
difficult to track down.

Perhaps you could enable SLAB debugging to see if we can get
closer to the culprit? Alternatively you could try a git bisection.

Unless we have a way of reproducing this there isn't a lot more
that we can do I'm afraid.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
