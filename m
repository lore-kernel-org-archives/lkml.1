Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbZDBJxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbZDBJxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761442AbZDBJxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:53:01 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58294 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757263AbZDBJw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:52:59 -0400
Date: Thu, 2 Apr 2009 17:52:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: dada1@cosmosbay.com, mingo@elte.hu, htejun@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, joe@perches.com,
       rusty@rustcorp.com.au
Subject: Re: [PATCH] x86: percpu_to_op() misses memory and flags clobbers
Message-ID: <20090402095217.GA30759@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D3AD61.5090206@goop.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> There's probably not a lot of value in this.  The Intel and AMD 
> optimisation guides tend to deprecate inc/dec in favour of using 
> add/sub, because the former can cause pipeline stalls due to its partial 
> flags update.

Is this still the case on the latest Intel CPUs?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
