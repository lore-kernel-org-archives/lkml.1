Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbXBOFim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbXBOFim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 00:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbXBOFim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 00:38:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:52078 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbXBOFil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 00:38:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lINIXG5zDn8tM5nQka2OodW5vTz9BJMgjD0AEBMcefvY3DTO2uRJ3dS/AGSH3/ftaumoB1IHj0TyC72DEZzvAbUvGGgbx8pgl16ol/E1bSo+VQnFPY2ieAlSCB3sSkQSdp1OqWryn1K1B6VjiFjQhd5aKsps3dp77j8GoR6Xrhs=
Message-ID: <9b3a62ab0702142138n1f97574ft4167e5464c2ef446@mail.gmail.com>
Date: Wed, 14 Feb 2007 21:38:39 -0800
From: "v j" <vj.linux@gmail.com>
To: "Lee Revell" <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: <75b66ecd0702142130x64824694ieee1869d0d70ab15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <75b66ecd0702142130x64824694ieee1869d0d70ab15@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No its not. It wasn't common knowledge 3 years ago when we chose Linux
as an embedded platform. If it indeed is common knowledge that
loadable modules in Linux have to be open-source then it is very
probable that we wouldn't have chosen Linux as the platform of choice.
If this indeed is the case and is common knowledge, then I predict
that Linux will soon drop in popularity as the OS of choice in
embedded systems.

On 2/14/07, Lee Revell <rlrevell@joe-job.com> wrote:
> Um... it's been common knowledge for years that the legal status of
> non-GPL kernel modules is an open issue.  Specifically, whether a
> device driver written for the Linux kernel is a derived work of the
> kernel.  Sounds like you didn't do your homework 3 years ago.
>
> Why did you assume that linking a non-GPL module into the GPL Linux
> kernel was legal?  You have read the GPL right?
>
> Lee
>
> On 2/15/07, v j <vj.linux@gmail.com> wrote:
> > This is in reference to the following thread:
> >
> > http://lkml.org/lkml/2006/12/14/63
> >
> > I am not sure if this is ever addressed in LKML, but linux is _very_
> > popular in the embedded space. We (an embedded vendor) chose Linux 3
> > years back because of its lack of royalty model, robustness and
> > availability of infinite number of open-source tools.
> >
> > We recently decided to move to Linux 2.6 for our next product, mainly
> > because Linux has worked so well for us in the past, and we would like
> > to move up to keep up with the latest and greatest.
> >
> > However in moving to  2.6, we noticed a number of alarming things.
> > Porting drivers over from devfs to udev, though easy raised a number
> > of alarming issues. Driver's no longer could dynamically allocate
> > their MAJOR/MINOR numbers. Doing so would mean they would have to use
> > sysfs. However it seems that sysfs (and the class_ interface) is only
> > available to GPL modules. This is very concerning. The drivers which
> > we have written over the last three years are suddenly under threat.
> > We don't mind statically assigning MAJOR/MINOR numbers to our drivers.
> > We can do this and modify our user space applications too.
> >
> > However we have a worrying trend here. If at some point it becomes
> > illegal to load our modules into the linux kernel, then it is
> > unacceptable to us. We would have been better off choosing VxWorks or
> > OSE 3 years ago when we made an OS choice. The fact that Linux is
> > becoming more and more closed is very very alarming.
> >
> > vj.
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
