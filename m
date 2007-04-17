Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbXDQOlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbXDQOlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbXDQOlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:41:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:63413 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbXDQOlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:41:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dV61BrbuUd2v0VtB8/kWrqILqLH5D5eOI2W3cDeAbVZ6tLFeCdVSxYwF9PETOC/3bMkXCGg1Z9Tg6tBJX8NrW3PXzhEq5Dk8P5c5g74TSu4XBy8cNc9RcSa3p7gzqv07+k2JMtDcT2Zn75idaw9rp/RsmW2omUe+hM2fYi44HtM=
Message-ID: <38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
Date: Tue, 17 Apr 2007 16:41:00 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
In-Reply-To: <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	 <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Francis Moreau <francis.moro@gmail.com> wrote:
> > On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >>
> >> Actually, I was referring to your AES module :)
> >
> > Well I don't if I can do that unfortunately.
>
> What's the problem?
>

Always the same problem. Some stupid people here think that they have
designed the most wonderful AES hardware module. If I give you the
code of the driver I'll show you a lot of "confidential" stuff.

> > Actually there's nothing really interesting in this code, only key or
> > acc loadings and that's it.
> >
> > What do you want to see exactly ?
>
> Well if your code's faster than what we have in the kernel then we
> should use yours instead.
>

Again, my code is faster only because I skip the key loading in
"cia_encrypt" method. Actually the gain is bigger in decryption mode
than in encryption one because I also generate the decryption key for
each block.

You see there's absolutely no clever trick here...
-- 
Francis
