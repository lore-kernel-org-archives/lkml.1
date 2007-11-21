Return-Path: <linux-kernel-owner+w=401wt.eu-S1762851AbXKUQTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762851AbXKUQTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbXKUQTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:19:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:65227 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909AbXKUQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:19:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:newsgroups:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=pM5FJjkTok7RQz5CFRdZnEhcu+n+ETp7KMVcQ2mKp3EinEXjpiq7JWe6LKxPwNhaUpQ+/3x1CRZznmajrgdNaOBl9X0uYcu1H4nA/wEVpCoagnYQjo5mcROxg/1Xdz1LXs1CVCGKjpVGUDGe2lcwODYjVkzTV4dJ1dLNK4Nsvm8=
Message-ID: <47445A79.7020902@gmail.com>
Date: Wed, 21 Nov 2007 21:19:05 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.11~pre071022-0etch1+lenny1) Mnenhy/0.7.5.666
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Nix <nix@esperi.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com,
       goodmenkernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
References: <E1IuMnZ-0003o3-00@gondolin.me.apana.org.au>	<4742831F.9040408@zytor.com> <877ikc1v3a.fsf@hades.wkstn.nix> <47442FA9.6020600@gmail.com>
In-Reply-To: <47442FA9.6020600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Nix wrote:
>> Possible hits (I'm not sure what the folder would do with this: the
>> extra level of brackets in the way might affect things but I don't think
>> so):
>>
>> ./libtheora/libtheora/lib/enc/pp.c:      TmpMod = 32 + QValue - 
>> 2*(abs(Src[j+Pitch]-Src[j]));
>> ./libtheora/libtheora/lib/enc/pp.c:      TmpMod = 32 + QValue - 
>> 2*(abs(Src[j+1]-Src[j]));
> 
> This did emit a warning, I have already reported it: 
> https://trac.xiph.org/ticket/1260

And on IRC, they explained that it is a piece of code that never gets called. So 
not a hit.

-- 
Alexander E. Patrakov
