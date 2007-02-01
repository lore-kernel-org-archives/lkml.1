Return-Path: <linux-kernel-owner+w=401wt.eu-S1422757AbXBARjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422757AbXBARjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422760AbXBARjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:39:42 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:34586 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422757AbXBARjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:39:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gwShaV0v5WWiOGTZf8qmmkr7FBht93uvvXDRA8jQ7jOELVtOh2yjTUOn9ZtSrweau4OD6HCYUgCcZWrs7/7JcKuStTNQ6a/k+MRA/QAqPBsyErOxujOqsH7gUIfYgDvdw6NgZeteej2CQxL2fQXGaBOSaDUErq7mOerf4LMjR20=
Message-ID: <653402b90702010939t692e0852pc6750dbfae4b25f5@mail.gmail.com>
Date: Thu, 1 Feb 2007 18:39:41 +0100
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: crash on CONFIG_CFAG12864B=y in 2.6.20-rc3-mm1
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1170350433.9781.200.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1168188931.26086.255.camel@imap.mvista.com>
	 <653402b90702010549v17e72765uc718c1ae79419003@mail.gmail.com>
	 <653402b90702010716i7c0ddf71xe6fa7866323f52f4@mail.gmail.com>
	 <1170342991.9781.189.camel@imap.mvista.com>
	 <653402b90702010913g3d91b190ud4faa2bcce3251b@mail.gmail.com>
	 <1170350433.9781.200.camel@imap.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Daniel Walker <dwalker@mvista.com> wrote:
> On Thu, 2007-02-01 at 18:13 +0100, Miguel Ojeda wrote:
>
> > >
> > >
> >
> > Well, I use the word "module" for both cases: When I modprobe
> > cfag12864b, if ks0108 fails, it doesn't get linked. So I thought the
> > same happen for built-in drivers (in other words, I didn't think
> > cfag12864b would be linked if ks0108 failed).
> >
> > So I'm waiting until someone tell me what is the right way to avoid
> > drivers like cfag12864b been inited if their dependencies failed.
> >
> > Anyway, thanks for discovering the bug (I wouldn't have discovered it
> > as my motherboard has parallel port ;).
>
> I have a parallel port, but I don't have the cfag12864b or ks0108 .. I

In fact, you don't need the cfag12864b display, as the driver just
needs the parallel port for output (you can put some LEDs attached to
the parallel port to check the driver's operations and it will be
fine).

BTW, why ks0108 didn't find the 888 parallel port? Haven't you got such number?

> think the simplest way to fix it would be to add a flag to ks0108 that
> signals successful initialization , then force cfag12864b to check for
> that ..

Sure, that won't be a problem; however, maybe there is other better way (?).

>
> I found this by booting a make allyesconfig kernel ..
>
> Daniel
>
>

Miguel

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
