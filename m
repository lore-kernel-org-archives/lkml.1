Return-Path: <linux-kernel-owner+w=401wt.eu-S1767892AbXEDLAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767892AbXEDLAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767896AbXEDLAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:00:18 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:48612 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767892AbXEDLAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:00:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pd6hF8BB08Vqso8UKlTOdaVR+npzBAfDX6v1Ei2Lz4S+F2gscRcO3NE3+GZrDdCWcwBLQPFFMW80IO1VRigolZe9X1jYSvvV0m93eexlRmAoOMHCnydabd/t0bOa59wUZ78/aXOJUhJNsknqKNaBbnZmE7iNJ/LRA6t8mAvI0kw=
Message-ID: <99e4df080705040400p66819117sec7f7d88d3794871@mail.gmail.com>
Date: Fri, 4 May 2007 19:00:15 +0800
From: "la deng" <ladeng.mimi@gmail.com>
To: "WANG Cong" <xiyou.wangcong@gmail.com>, "la deng" <ladeng.mimi@gmail.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: c 's OOP in VFS vs c++'s OOP
In-Reply-To: <20070504101129.GA5482@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <99e4df080705040132m41116db3y50c73c79528d6206@mail.gmail.com>
	 <20070504101129.GA5482@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, WANG Cong <xiyou.wangcong@gmail.com> wrote:
> On Fri, May 04, 2007 at 04:32:27PM +0800, la deng wrote:
> >reference to the c++'s father's interview
> >
> >http://www.artima.com/intv/abstreffi.html
> >
> >fortran and c++ can  achive good performance for they can abstract in
> >higher level and  their compiler can think in higher level to avoid
> >the cache miss (like in the array vs vector )or to achive the "no
> >code" Optimization
> >
>
> Well, it seems

 that you are a zealot of OOP. I admit OOP is really a good idea and a
good abstraction. And that's the reason why we borrow it in. Of
course, OOP in C is not true OOP. (Maybe we can call it pseudo-OOP.)
>
> >The vfs using c to OOP but c compiler can't have the high level
> >Intelligence as the c++ or fortran's compiler to help at the high
> >level Optimization
> >
>
> We just borrow the OOP ideas from OOP languages, like C++/Java/Python, but we can't use any of them. The reasons can be summarized as the following:
>
> 1. Those languages, like C++, hide many things behind you. But kernel needs to know those things.
> 2. Those languages can't be (well) mixed with assembly.
> 3. Speed is crucial for kernel, while those languages can't surpass C.
>
> >
> >one benchmark showed the c insert in the array will slow by speed of   1/17
>
> What benchmark? If your algorithm is well designed, C can't be more slowly.
>
> >
> >
> >Then ,what's the power of c OOP vs c++ with the compiler's
> >Intelligence in OOP?or maybe the c compiler have Outdated？
> >
>
> C compiler is _not_ out of date, of course. Why we choose OOP in C is explained above.
>
> In a word, we choose OOP because it's a good idea like you wanna show us, we prefer C because of it's low-levelness and speed.
>
> >any input will be appreciated.
>
> Regard!
>
> WANG Cong
>
>
well,I mean when use c as a higher level assembly maybe it a good
choose compare to assembly.

but,as below

http://www.research.att.com/~bs/esc99.html

when we use c to do the OOP ,for the c compiler has no the globe
Analysis .then the cache miss(for example : insert a array,c compiler
maybe  put the data into memory and then take it again for no globe
Analysis ) and the data not Optimi for in the register and c can't
control register like lisp or c++ with some compiler glob control and
Analysis,giveing c the penalty of 1/17 speed as normal

What's you think about it?

Thanks
