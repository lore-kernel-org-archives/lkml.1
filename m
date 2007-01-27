Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbXA0ApR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbXA0ApR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXA0ApQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:45:16 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4339 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751816AbXA0ApO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:45:14 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: + oops-in-drivers-net-shaperc.patch added to -mm tree
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, deweerdt@free.fr,
       netdev@vger.kernel.org, frederik.deweerdt@gmail.com,
       shemminger@osdl.org
Organization: Core
In-Reply-To: <20070125.193128.39155864.davem@davemloft.net>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HAbgn-00039h-00@gondolin.me.apana.org.au>
Date: Sat, 27 Jan 2007 11:45:05 +1100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> 
> Shaper is actually OK.  None of these hardware header callbacks
> should be invoked if the device is down.  Yet, this is what is
> accidently being allowed in the AF_PACKET socket layer.

Hmm, what if the device goes down after the check?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
