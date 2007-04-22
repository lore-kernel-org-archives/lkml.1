Return-Path: <linux-kernel-owner+w=401wt.eu-S1161227AbXDVPso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161227AbXDVPso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 11:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161205AbXDVPsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 11:48:43 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:33647 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161195AbXDVPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 11:48:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ezOqh4PZiQHH4NDfOYEQxVJqikQVqcf06EtI3GIdfyJam5ZTJ93Ij2fzobgwThwLHf7K6s/5L1tk6qPnI8z3UKEKuI34v2M3xJ/rBkyDQ9Fvsajr87ysiUKfcxaI9ptP9FBz5++pYj3iluTO23IMyZGLeoDP7cJn3tKYlWT+Ulk=
Message-ID: <a781481a0704220848t16cc8ed2l3cb5ee52d9b405e1@mail.gmail.com>
Date: Sun, 22 Apr 2007 21:18:36 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Remove "obsolete" label from ISDN4Linux (v3)
Cc: "Tilman Schmidt" <tilman@imap.cc>, "David Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de, akpm@linux-foundation.org
In-Reply-To: <20070422161708.54253ab7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070115172912.GA3323@pingi.kke.suse.de>
	 <462A0CA7.2090908@imap.cc> <20070421215844.542d3aab@the-village.bc.nu>
	 <20070421.151052.78709111.davem@davemloft.net>
	 <462B54A0.9000203@imap.cc> <20070422135835.037e323c@the-village.bc.nu>
	 <462B712D.7070504@imap.cc> <20070422161708.54253ab7@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 4/22/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > No risk of deadlock. It'll progress to && BROKEN which will either cause
> > > sufficient pain for someone to get off their arse and fix it, for enough
> > > of a vendors users to get the vendor to do the work or for someone who
> > > cares to pay a third party to do the work.
> >
> > Do I sense some hidden agenda there?
>
> No I'm speaking from experience - if a subsystem maintainer is too
> busy/working on other projects and the subsystem stops working it
> produces a rapid and sudden supply of new maintainers, unless nobody
> cares in which case it can go in the bitbucket.

Sorry for butting in (I have absolutely no interest or stake in I4L,
just joining in the debate to clear my understanding of how things
have always worked or should work in kernel development):

I must be missing something here. Tilman's point is really quite
simple and fundamental (which you haven't answered as yet). Why, or
rather how, were the writers of newer APIs _allowed_ to push *their*
stuff into the kernel _without_ even bothering to convert the
*existing* users of the older APIs in the kernel? This goes against
the spirit of pretty much how anything is done in here ... one can't
really find fault with the original author of I4L for not using APIs
that didn't even exist when he wrote I4L. Or was I4L always obsolete
from the beginning itself when it was merged in?

> > The isdn4linux subsystem will not "progress" to BROKEN unless
> > somebody pushes it there.
>
> It has drivers using functions that will soon be deleted. That isn't so
> much as pushing more like getting fed up of pulling someone elses cart
> along.

It's not about "pushing someone else's cart". It's about not breaking
existing (and working) kernel subsystems that do have a userbase.
Saying that some code is messy and convoluted etc etc does *not*
justify the writers of newer APIs from ignoring to update an existing
and working kernel subsystem to their newer APIs. If we allow
something like this (or if this was allowed in the past), then we
could be setting a very unfortunate precedent.

I really don't have any specific knowledge of the I4L codebase, so
perhaps you and Dave do have better reasons to keep it marked as
obsolete (and *allow* it get broken by API changes in the future).

Satyam
