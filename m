Return-Path: <linux-kernel-owner+w=401wt.eu-S1764226AbXLPDHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764226AbXLPDHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 22:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbXLPDHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 22:07:23 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2405 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753111AbXLPDHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 22:07:22 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: m.kozlowski@tuxland.pl (Mariusz Kozlowski)
Subject: Re: 2.6.24-rc5-mm1: cat /proc/net/packet -> oops
Cc: akpm@linux-foundation.org, jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, davem@davemloft.net, den@openvz.org,
       xemul@openvz.org
Organization: Core
In-Reply-To: <200712160118.58611.m.kozlowski@tuxland.pl>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1J3jqN-0000Jq-00@gondolin.me.apana.org.au>
Date: Sun, 16 Dec 2007 11:07:07 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
>
> git-ubi.patch
> GOOD
> #
> git-net.patch 
> BAD
> ipsec-fix-reversed-icmp6-policy-check.patch
> 
> but this seems to be far from precise :)

I suspect namespace borkage.  But just because you pin-pointed
my patch I'll try to track it down :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
