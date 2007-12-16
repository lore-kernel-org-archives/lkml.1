Return-Path: <linux-kernel-owner+w=401wt.eu-S1762413AbXLPDKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762413AbXLPDKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 22:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbXLPDKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 22:10:25 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2436 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753899AbXLPDKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 22:10:24 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: akpm@linux-foundation.org (Andrew Morton)
Subject: Re: 2.6.24-rc5-mm1 -- inconsistent {in-softirq-W} -> {softirq-on-R} usage.
Cc: miles.lane@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl
Organization: Core
In-Reply-To: <20071215031341.66dc0d05.akpm@linux-foundation.org>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1J3jtL-0000Kc-00@gondolin.me.apana.org.au>
Date: Sun, 16 Dec 2007 11:10:11 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
>
> My suspicion is that you've hit bad breakage in networking and lockdep just
> isn't sufficiently robust to handle what it's being given.
> 
> Can you suggest a way in which others can reproduce this?

I can reproduce this now.  I suspect it's to do with the namespace
work.  I'll let you know when I have digged further.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
