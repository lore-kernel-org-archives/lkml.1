Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZGCPa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZGCPa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbZGCPaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:30:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:56476 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754747AbZGCPaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:30:09 -0400
Date: Fri, 3 Jul 2009 23:29:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: mingo@elte.hu, jolsa@redhat.com, a.p.zijlstra@chello.nl,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       jarkao2@gmail.com, oleg@redhat.com, davidel@xmailserver.org,
       eric.dumazet@gmail.com, Paul.McKenney@us.ibm.com
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
Message-ID: <20090703152951.GA28837@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703140401.GA10256@Krystal>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> Why don't we create a read_lock without acquire semantic instead (e.g.
> read_lock_nomb(), or something with a better name like __read_lock()) ?
> On architectures where memory barriers are needed to provide the acquire
> semantic, it would be faster to do :
> 
> __read_lock();
> smp_mb();
> 
> than :
> 
> read_lock(); <- e.g. lwsync + isync or something like that
> smp_mb(); <- full sync.

Hmm, why do we even care when read_lock should just die?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
