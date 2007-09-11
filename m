Return-Path: <linux-kernel-owner+w=401wt.eu-S933097AbXIKJBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbXIKJBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 05:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760079AbXIKJAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 05:00:55 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3353 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759271AbXIKJAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 05:00:54 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: mark@hindley.org.uk (Mark Hindley)
Subject: Re: [OOPS] 2.6.23-rc5 in tcp/net/nfsd
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       nfs@lists.sourceforge.net, neilb@suse.de
Organization: Core
In-Reply-To: <20070911083200.GA3409@hindley.org.uk>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IV1bR-0001CT-00@gondolin.me.apana.org.au>
Date: Tue, 11 Sep 2007 17:00:13 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hindley <mark@hindley.org.uk> wrote:
>
> Code: 01 00 00 03 75 0e 8b 42 18 8b 40 0c 8b 80 c4 00 00 00 eb 0a 8b 4c 24 08 8b 41 18 8b 40 28 0f c8 89 04 24 8b 44 24 08 b9 04 00 00 <00> ba 03 00 00 00 bf a6 ff ff
> EIP: [<c02625bf>] ip_fragment+0x7f/0x680 SS:ESP 0068:ccb48b3c

The EIP is off by one byte.  So either a hardware problem or a
really unlikely result of stack corruption.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
