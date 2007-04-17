Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbXDQNmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbXDQNmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbXDQNmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:42:08 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1268 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754328AbXDQNmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:42:07 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: johnpol@2ka.mipt.ru (Evgeniy Polyakov)
Subject: Re: [CRYPTO] is it really optimized ?
Cc: francis.moro@gmail.com, herbert@gondor.apana.org.au,
       helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Organization: Core
In-Reply-To: <20070417130431.GA8685@2ka.mipt.ru>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HdnwX-0005U1-00@gondolin.me.apana.org.au>
Date: Tue, 17 Apr 2007 23:42:01 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
>
>> OK, I tried to cook up something very simple. Since I don't know this
>> code, please be indulgent when reading the following patch ;)
> 
> Which means that after one has loaded ecryptfs module it can not use
> ipsec and dm-crypt if there is only one crypto algo registered...

Yep.  We don't need such a flag anyway.  All we need is a way to tweak
the priority and Bob's your uncle.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
