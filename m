Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbXDQNlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbXDQNlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXDQNlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:41:06 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1251 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754332AbXDQNlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:41:04 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: francis.moro@gmail.com (Francis Moreau)
Subject: Re: [CRYPTO] is it really optimized ?
Cc: herbert@gondor.apana.org.au, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Organization: Core
In-Reply-To: <38b2ab8a0704170536x15920b15xedfd518cad50cee@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HdnvW-0005Ti-00@gondolin.me.apana.org.au>
Date: Tue, 17 Apr 2007 23:40:58 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau <francis.moro@gmail.com> wrote:
>
>> > normal version:
>> > test 4 (128 bit key, 8192 byte blocks): 1 operation in 67991 cycles (8192
>> > bytes)
>> >
>> > optimized version:
>> > test 4 (128 bit key, 8192 byte blocks): 1 operation in 51783 cycles (8192
>> > bytes)
>> >
>> > So the gain is 16000 cycles which seems to worth the change, isn't it ?
>>
>> Sounds like it would.  It would help of course if you posted the patch :)
>>
> 
> OK, I tried to cook up something very simple. Since I don't know this
> code, please be indulgent when reading the following patch ;)

Actually, I was referring to your AES module :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
