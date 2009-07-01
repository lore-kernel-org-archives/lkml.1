Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbZGADjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbZGADjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbZGADj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:39:26 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:60572 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755349AbZGADjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:39:25 -0400
Date: Wed, 1 Jul 2009 11:39:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com, oleg@redhat.com,
       eric.dumazet@gmail.com
Subject: Re: [PATCH] net: fix race in the receive/select
Message-ID: <20090701033924.GA29762@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eit3l7y6.fsf@basil.nowhere.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:
> 
> At least on x86 I can't see how it happens. mb() is only a compile
> time barrier and the compiler doesn't optimize over indirect callbacks
> like __pollwait() anyways.

mb() does more than just a compiler barrier, it also issues mfence.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
