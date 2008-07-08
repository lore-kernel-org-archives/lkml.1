Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYGHIXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYGHIXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYGHIW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:22:58 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:36294 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbYGHIW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:22:57 -0400
Date: Tue, 8 Jul 2008 16:22:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Darren Jenkins\"" <darrenrjenkins@gmail.com>
Cc: kernel Janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net,
       linux-crypto@vger.kernel.org, jmorris@intercode.com.au, jef@linuxbe.org
Subject: Re: [PATCH] crypto/tcrypt.c fix resource leak
Message-ID: <20080708082248.GA25297@gondor.apana.org.au>
References: <1215458654.8316.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1215458654.8316.16.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 05:24:14AM +1000, Darren Jenkins" wrote:
> G'day people,
> 
> Coverity CID: 2306 & 2307 RESOURCE_LEAK
> 
> In the second for loop in test_cipher(), data is allocated space with
> kzalloc() and is only ever freed in an error case.
> Looking at this loop, data is written to this memory but nothing seems
> to read from it. 
> So here is a patch removing the allocation, I think this is the right
> fix.
> 
> Only compile tested.
> 
> ﻿Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
