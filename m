Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYABK0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYABK0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 05:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbYABK0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 05:26:13 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3456 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754771AbYABK0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 05:26:12 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: tytso@mit.edu (Theodore Tso)
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Cc: 7eggert@gmx.de, viro@zeniv.linux.org.uk, davem@davemloft.net,
       jengelh@computergmbh.de, devzero@web.de, linux-kernel@vger.kernel.org,
       bunk@kernel.org, netdev@vger.kernel.org
Organization: Core
In-Reply-To: <20080101050154.GG11776@mit.edu>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1JA0mT-0008U2-00@gondolin.me.apana.org.au>
Date: Wed, 02 Jan 2008 21:25:01 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> wrote:
>
> The question is whether the size of the Unix domain sockets support is
> worth the complexity of yet another config option that we expose to
> the user.  For the embedded world, OK, maybe they want to save 14k of
> non-swappable memory.  But for the non-embedded world, given the 117k
> mandatory memory usage of sysfs, or the 124k memory usage of the core
> networking stack, never mind the 3 megabytes of memory used by objects
> in the kernel subdirectory, it's not clear that it's worth worrying
> over 14k of memory, especially when many Unix programs assume
> that Unix Domain Sockets are present.

That would make sense if we were proposing to get rid of the CONFIG_UNIX
question altogether for !CONFIG_EMBEDDED.  However, the proposal here is
merely to eliminate the modular option but the CONFIG_UNIX prompt itself
will remain even without CONFIG_EMBEDDED.

This I think is quite pointless.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
