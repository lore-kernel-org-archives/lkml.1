Return-Path: <linux-kernel-owner+w=401wt.eu-S1762887AbXHOIke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762887AbXHOIke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbXHOIkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:40:18 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3328 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755249AbXHOIkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:40:16 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ak@suse.de (Andi Kleen)
Subject: Re: [patch 1/2] i386: use asm() like the other atomic operations already do.
Cc: sebastian@breakpoint.cc, linux-kernel@vger.kernel.org, ak@suse.de
Organization: Core
In-Reply-To: <20070815002034.GW3406@bingen.suse.de>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1ILEQ8-0005H5-00@gondolin.me.apana.org.au>
Date: Wed, 15 Aug 2007 16:40:04 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> wrote:
>> My config with march=pentium-m and gcc (GCC) 4.1.2 (Gentoo 4.1.2):
>>   text    data     bss     dec     hex filename
>> 3434150  249176  176128 3859454  3ae3fe atomic_normal/vmlinux
>> 3435308  249176  176128 3860612  3ae884 atomic_inlineasm/vmlinux
> 
> What is the difference between atomic_normal and atomic_inlineasm? 

The inline asm stops certain optimisations from occuring.

I'm still unconvinced why we need this because nobody has
brought up any examples of kernel code that legitimately
need this.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
