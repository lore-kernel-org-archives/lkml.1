Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbZGAIpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbZGAIpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZGAIoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:44:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35022 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZGAIoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:44:54 -0400
Date: Wed, 1 Jul 2009 10:44:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com, oleg@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH] net: fix race in the receive/select
Message-ID: <20090701084430.GC4769@jolsa.lab.eng.brq.redhat.com>
References: <87eit3l7y6.fsf@basil.nowhere.org> <20090701033924.GA29762@gondor.apana.org.au> <20090701062732.GK6760@one.firstfloor.org> <20090701070332.GA31103@gondor.apana.org.au> <20090701072226.GN6760@one.firstfloor.org> <20090701083144.GA31863@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701083144.GA31863@gondor.apana.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 04:31:44PM +0800, Herbert Xu wrote:
> On Wed, Jul 01, 2009 at 09:22:26AM +0200, Andi Kleen wrote:
> >
> > Agreed.
> > 
> > I suspect the reordering of the wake queue tests might makes a difference, but
> > in this case to ensure they are always tested in the proper order by
> > the compiler would need more smp_rmb()s
> 
> I just looked up the original bug report and it's against RHEL4
> which is a 2.6.9 kernel.  Jiri, have we reproduced this on a more
> recent kernel?

no, only RHEL 4.. 

it is very hard to reproduce. I was succesfull once
on RHEL4 after 8 days, never on upstream though.

jirka

> 
> Thanks,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
