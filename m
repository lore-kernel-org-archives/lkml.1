Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbXG1QaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbXG1QaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbXG1Q36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:29:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:19085 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXG1Q35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iHSzbC9mq3FIUlCD37UVq3oTGxtg0l1qEhRMO2Y9Yu8HG9NCo4mV29qBKEf7mXXvf0oiRbsSAwJMI1tt296LC1kuqzDlj6atO/1EvDeILLa1xJ2xqZ1FhXsSm/Q3sfXF2CvN45MKSUOxFzgj5ixWxZEyqRZ9nKdG0F+Ixiu3Rxs=
Message-ID: <2c0942db0707280929s56cc4588obb4abf78d766af66@mail.gmail.com>
Date: Sat, 28 Jul 2007 09:29:55 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans for 2.6.23]
Cc: "Rene Herman" <rene.herman@gmail.com>, david@lang.hm,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Mike Galbraith" <efault@gmx.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Frank Kingswood" <frank@kingswood-consulting.co.uk>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Jesper Juhl" <jesper.juhl@gmail.com>, "ck list" <ck@vds.kolivas.org>,
       "Paul Jackson" <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070728122139.3c7f4290@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	 <20070727030040.0ea97ff7.akpm@linux-foundation.org>
	 <1185531918.8799.17.camel@Homer.simpson.net>
	 <200707271345.55187.dhazelton@enter.net> <46AA3680.4010508@gmail.com>
	 <Pine.LNX.4.64.0707271239300.26221@asgard.lang.hm>
	 <46AAEDEB.7040003@gmail.com>
	 <Pine.LNX.4.64.0707280138370.32476@asgard.lang.hm>
	 <46AB166A.2000300@gmail.com>
	 <20070728122139.3c7f4290@the-village.bc.nu>
X-Google-Sender-Auth: 1f7aae0da60fe426
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Actual physical disk ops are precious resource and anything that mostly
> reduces the number will be a win - not to stay swap prefetch is the right
> answer but accidentally or otherwise there are good reasons it may happen
> to help.
>
> Bigger more linear chunks of writeout/readin is much more important I
> suspect than swap prefetching.

<nod>. The larger the chunks are that we swap out, the less it
actually hurts to swap, which might make all this a moot point. Not
all I/O is created equal...

Ray
