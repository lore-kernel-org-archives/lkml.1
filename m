Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZAXJc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZAXJc7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 04:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbZAXJcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 04:32:50 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:47990 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015AbZAXJct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 04:32:49 -0500
Date: Sat, 24 Jan 2009 20:32:45 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clarification of allowed context for crypto routines
Message-ID: <20090124093245.GA4889@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901240815.08903.arvidjaar@mail.ru>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> 
> On 24 января 2009 01:31:50 Herbert Xu wrote:
>>
>> 2) The highmem primitives we use are currently softirq only.  We
>> could make them work for hardirq as well, but because of 1) we
>> didn't.
> 
> Could you point to example of such primitive in code under crypto?

Grep for kmap under crypto.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
