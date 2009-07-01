Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbZGAK7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbZGAK7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZGAK6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:58:54 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:43999 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753476AbZGAK6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:58:54 -0400
Date: Wed, 1 Jul 2009 18:58:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com, oleg@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH] net: fix race in the receive/select
Message-ID: <20090701105852.GA925@gondor.apana.org.au>
References: <87eit3l7y6.fsf@basil.nowhere.org> <20090701033924.GA29762@gondor.apana.org.au> <20090701062732.GK6760@one.firstfloor.org> <20090701070332.GA31103@gondor.apana.org.au> <20090701072226.GN6760@one.firstfloor.org> <20090701083144.GA31863@gondor.apana.org.au> <20090701084430.GC4769@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701084430.GC4769@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 10:44:30AM +0200, Jiri Olsa wrote:
>
> no, only RHEL 4.. 
> 
> it is very hard to reproduce. I was succesfull once
> on RHEL4 after 8 days, never on upstream though.

It would be good to know whether this bug occurs on the upstream
kernel because as it stands, the patch is a no-op for the upstream
kernel on x86-64.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
