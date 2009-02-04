Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbZBDMCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbZBDMCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZBDMCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:02:10 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:51487 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837AbZBDMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:02:09 -0500
Date: Wed, 4 Feb 2009 23:01:23 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: davem@davemloft.net, zbr@ioremap.net, jarkao2@gmail.com, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090204120123.GA22116@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3skmubktj.fsf@ursa.amorsen.dk>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Amorsen <benny+usenet@amorsen.dk> wrote:
>
> Would it be possible to add a counter somewhere for this, or is that
> too expensive?

Yes a counter would be useful and is reasonable.  But you can
probably deduce it by just looking at slabinfo.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
