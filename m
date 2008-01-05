Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYAECfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYAECfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 21:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbYAECfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 21:35:30 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2834 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754624AbYAECf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 21:35:29 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: arjan@linux.intel.com (Arjan van de Ven)
Subject: Re: [patch 1/3] move WARN_ON() out of line
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org
Organization: Core
In-Reply-To: <477D4E50.4020004@linux.intel.com>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1JAysR-0000Hn-00@gondolin.me.apana.org.au>
Date: Sat, 05 Jan 2008 13:35:12 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@linux.intel.com> wrote:
>
>> While we're here, I'll mention that dump_stack probably ought to take a
>> severity level argument.
> 
> 125 files changed, 202 insertions(+), 199 deletions(-)
> just to get the api change done.
> I can hear akpm cringe from here...

You don't have to change all of them at once.  Just create a new function
that does take a level and make the old dump_stack and WARN_ON call that
then slowly convert everything else across if so desired.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
