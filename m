Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbXDKKt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbXDKKt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXDKKt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:49:58 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3159 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752185AbXDKKt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:49:57 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: peter.p.waskiewicz.jr@intel.com (Waskiewicz Jr, Peter P)
Subject: Re: [PATCH 2/2] NET: Multiqueue network device support.
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, cramerj@intel.com, auke-jan.h.kok@intel.com,
       christopher.leech@intel.com
Organization: Core
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC329029E3EE5@orsmsx414.amr.corp.intel.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HbaOV-0004rc-00@gondolin.me.apana.org.au>
Date: Wed, 11 Apr 2007 20:49:43 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Waskiewicz Jr, Peter P <peter.p.waskiewicz.jr@intel.com> wrote:
> 
> True, but the assignment for "dev" above also casts this void * to
> struct net_device *:
> 
>        dev = (struct net_device *)
>                (((long)p + NETDEV_ALIGN_CONST) & ~NETDEV_ALIGN_CONST);
>        dev->padded = (char *)dev - (char *)p;
> 
> Shall I remove my cast?

This is totally different as it's casting a "long", not a "void *".

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
