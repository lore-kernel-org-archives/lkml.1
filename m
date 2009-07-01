Return-Path: <linux-kernel-owner+w=401wt.eu-S1752993AbZGAHDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbZGAHDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZGAHDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:03:34 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:41351 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751046AbZGAHDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:03:33 -0400
Date: Wed, 1 Jul 2009 15:03:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com, oleg@redhat.com,
       eric.dumazet@gmail.com
Subject: Re: [PATCH] net: fix race in the receive/select
Message-ID: <20090701070332.GA31103@gondor.apana.org.au>
References: <87eit3l7y6.fsf@basil.nowhere.org> <20090701033924.GA29762@gondor.apana.org.au> <20090701062732.GK6760@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701062732.GK6760@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 08:27:32AM +0200, Andi Kleen wrote:
>
> mfence is not needed for normal C code (not using non temporal
> stores) in the Linux memory model on x86 and is a no-op. Only the compile
> time barrier matters.

In that case this bug needs to be digged deeper regardless of
this patch.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
