Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbXEVJUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbXEVJUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbXEVJTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:19:53 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:34856 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbXEVJTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NRQo29KFczEHgsoVC4zOpkMPiIsuJC7+kOU2ARHAFhiV1hmkLvFJ/RY3W+dbG113SKesNVfFv2lX/YHOjE8lWqv9H0bbQa/mvM9MMve4ww03ywjOkWGkF3zxf5+HE1H/32h3+u0vz6oSWwUokHRh/qy0Wj6g61LPplCnh6iER7U=
Message-ID: <4cefeab80705220219qeb00e09u47e992e884152b5b@mail.gmail.com>
Date: Tue, 22 May 2007 14:49:51 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Richard Purdie" <richard@openedhand.com>
Subject: Re: [RFC] LZO1X de/compression support
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1179488817.5876.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
	 <1179488817.5876.14.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/18/07, Richard Purdie <richard@openedhand.com> wrote:
> > This patch, as of yet, only gives 'non-safe' version of decompressor.
> > The 'safe' version  will be included soon.
>
> How are you planning to add that back?
>

Please see newer patch posted.

> The LZO author had some concerns about this code. The major issue he
> highlighted was that it was 64-bit unsafe. Have you addressed that
> problem?
I found certain parts which were 64-bit unsafe - corrected them. Now,
I couldn't see any more of such instances and posted as RFC :)

>  Has it been tested on 64bit?
No. I am still looking for some 64-bit machine to test on (also some
Big-endian machine).

>
> I'm worried that in converting this code the way you have, you've
> possibly introduced potential security holes. You've removed all bounds
> checking and are going to have to add that back to create the "safe"
> version of the decompression function. Until I mentioned it, you seemed
> unaware of the potential problem and the comments above suggest you
> don't understand this code as fully as I'd like with regard to
> overflows.

I just did the 'logical' porting work. I don't understand the
algorithm itself since I could not find any document that describes
the same.

>
> The version I submitted has at least been subject to userspace scrutiny
> over a period of time and is basically unchanged with regard to
> security. It is much uglier though.
>
> Richard

Yes. But it will be even better if we can verify/correct this
cleaned-up version - shouldn't be that hard for just ~500 LOC :-)


Thanks for your comments.

- Nitin
