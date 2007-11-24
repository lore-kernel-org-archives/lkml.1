Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbXKXGiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbXKXGiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 01:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbXKXGio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 01:38:44 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3487 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbXKXGin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 01:38:43 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: agk@redhat.com (Alasdair G Kergon)
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
Cc: just.for.lkml@googlemail.com, mbroz@redhat.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <20071124040324.GM24157@agk.fab.redhat.com>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Ivoee-0006dq-00@gondolin.me.apana.org.au>
Date: Sat, 24 Nov 2007 14:38:16 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alasdair G Kergon <agk@redhat.com> wrote:
> Also io->pending may need better protection - atomic, but missing memory
> barriers?  (May be getting away without sometimes due to side-effects of
> other function calls, but needs doing properly.)

If it's using atomic_dec_and_test then that comes with an implicit
memory barrier.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
