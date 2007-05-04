Return-Path: <linux-kernel-owner+w=401wt.eu-S1161498AbXEDS2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161498AbXEDS2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161506AbXEDS2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:28:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:2345 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161498AbXEDS2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=STXajxaW3bUd0/8PRgTxNVqXkHJ2667EKFcEl65tY8ZgdO5EGPxtszEQwVYAp2gcwAiJJxjGXzaVCvsLxngJJpkzmPyp2Y/5i0W3LOzaSn+m9zrSE8qJ6/cjpPr6pOy8zuy8zw0wNKL3zna1fvcpPKEQIVEAZRGiXEFsxAVNYrs=
Message-ID: <a781481a0705041128l75eb8e87l92cb55ebd21459d8@mail.gmail.com>
Date: Fri, 4 May 2007 23:58:38 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
Cc: "Richard Purdie" <richard@openedhand.com>,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       torvalds@osdl.org, "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <84144f020705020235k3d984ccbv83910f6a6aa48f41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1178096183.5860.25.camel@localhost.localdomain>
	 <84144f020705020235k3d984ccbv83910f6a6aa48f41@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard, Pekka,

On 5/2/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On 5/2/07, Richard Purdie <richard@openedhand.com> wrote:
> > I realise a maze of ifdefs still remain. I've already spent a lot of
> > time removing a ton of them and going much further might start to affect
> > diffability of the code - I hoping whats there is a good compromise.
>
> I really don't think this is suitable for inclusion in the kernel. Any
> reason why you don't just fork the code and clean it up properly? Sure
> it will take some more work to track the original but how hard can it
> be for ~1700 lines of code?

I'd have to agree with that. When something gets ported to the kernel
(from some userspace library, or from any other piece of software),
then it _must_ be ported completely and follow the usual kernel style.
In fact I bet you can knock off a cool couple of hundred lines of gunk
from the patch just by doing a proper port and getting rid of those
pointless typedefs, for example.

(On an unrelated note/rant, this was one of the reasons why I
absolutely hate those MODSIGN patches being maintained by Red
Hat/Fedora/etc that port the GNU MPI library to the kernel but don't
do so properly, so that it can be diffed with future GNU MP releases
for easy maintainability -- with the result that the patch ends up
containing arch-specific assembly for platforms that Linux doesn't
even run on! Good to see that at least you've taken the pains to avoid
that kind of brain damage, but a full port would be better)

Thanks,
Satyam
