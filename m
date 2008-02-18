Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbYBRJiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbYBRJiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYBRJiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:38:10 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:1073 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbYBRJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:38:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YzDvglDkQF0ZVoxXGh1Sa6QlDQc/TcfIx0LQFOpi8xvFIfYl4rE57Q4ij1s1cje3+Kd7302xLvMXGMSmd6zHmiDi3mWXDLTUABXPty9Dt0uOt4ST8qXuM+O3AIDc0yLa0SwRdFl86d5hJ6+0vKXVNsrfcXUw01xb4W2IlOHGyxA=
Message-ID: <4d8e3fd30802180138n794450fcg30b3e3b6c5c23e98@mail.gmail.com>
Date: Mon, 18 Feb 2008 13:08:07 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: Coding style fixes for arch/x86/kernel/cpu/centaur.c
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080218092944.GA26521@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080217233023.26764dc9@paolo-desktop>
	 <20080218025645.GB30201@elte.hu>
	 <4d8e3fd30802180048o39790aedwde2ef1cbb009363e@mail.gmail.com>
	 <20080218092944.GA26521@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/08, Ingo Molnar <mingo@elte.hu> wrote:

> * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
> > >  /*
> > > - *     Set up an actual MCR
> > > + * Set up an actual MCR
> > >   */
> >
> > This was not highlighted by checkpatch.pl, right? The same applies for
> > a few other "fix" you did on some comments.
>
> correct - it's not fixes, just bringing it in line with the common
> comment style we use. The file was using lots of inconsistent comment
> styles.

Ok, that's something i'll verify when i'll work on a new file.

> > [...]
> > >  {
> > > -       u32 mem = ramtop();
> > >         u32 root = power2(mem);
> > > +       u32 mem = ramtop();
> >
> > Can you please explain the rationale behind this change?
>
> it's a bug :) It got pointed out by Joe Perches and i fixed it. (the
> size check would have caught it too)

oh, i see now :-)

> > > -               E2MMX = 1<<19,
> > > -               EAMD3D = 1<<20,
> > > -       };
> >
> > I see why you did the cleanup but I think even this part was not
> > catched by checkpatch.pl
>
> yes, as i said:
>
> > > Some of them are real CodingStyle problems, some of them are just
> > > arbitrary taste details.
>
> checkpatch.pl is a helper tool which highlights some of the clear
> problem - but when we clean up files we try to make it appear consistent
> in all its details. My patch was a demonstration of what else can be
> fixed in a file until it's really clean looking in its entirety.


Fair enought, i just want to try to improve checkpatch.pl while using it :-)

ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
