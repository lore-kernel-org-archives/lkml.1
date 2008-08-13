Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYHMBOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYHMBOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYHMBOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:14:43 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:40485 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752243AbYHMBOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:14:42 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: pavel@suse.cz (Pavel Machek)
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Cc: herbert@gondor.apana.org.au, drepper@gmail.com,
       austin_zhang@linux.intel.com, bunk@kernel.org, dwmw2@infradead.org,
       davem@davemloft.net, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Organization: Core
In-Reply-To: <20080811161015.GA5240@ucw.cz>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1KT4wK-0007mN-00@gondolin.me.apana.org.au>
Date: Wed, 13 Aug 2008 11:14:16 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@suse.cz> wrote:
>
> I thought we support intel x86 cpus in both 32 and 64bit modes...?

Yes we do, but the original patch had ugly ifdefs that did the
same thing.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
