Return-Path: <linux-kernel-owner+w=401wt.eu-S1751722AbXCMWvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbXCMWvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 18:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbXCMWvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 18:51:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:34786 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbXCMWvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 18:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O1txzxy57b95D68jb1OUwDnxJoO7Yllj31wdml6rGBOvqtXa9jw/Pp78/zv9F/Om6rTTFJ/VtpEejp9grH9cAEcHGHAeTyslfkN2D3ShJyExraQHMHfYDBnx80pFbj0AATj0xIgkSFqZIaC2YVRbyFwAJuqXcf14hoKeIySQuRU=
Message-ID: <29495f1d0703131551k5c06170bma138f8c1f1f9c84e@mail.gmail.com>
Date: Tue, 13 Mar 2007 15:51:43 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Linux 2.6.20.3
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       torvalds@osdl.org, stable@kernel.org, sparclinux@vger.kernel.org
In-Reply-To: <20070313.152054.31641425.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070313183353.GA7434@kroah.com>
	 <29495f1d0703131457i43883529p5da1502b68ff0948@mail.gmail.com>
	 <29495f1d0703131458j18f9aee1tcd9a2b2ff6ecdf41@mail.gmail.com>
	 <20070313.152054.31641425.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, David Miller <davem@davemloft.net> wrote:
> From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
> Date: Tue, 13 Mar 2007 14:58:24 -0700
>
> > On 3/13/07, Nish Aravamudan <nish.aravamudan@gmail.com> wrote:
> > > On 3/13/07, Greg KH <greg@kroah.com> wrote:
> > > > We (the -stable team) are announcing the release of the 2.6.20.3 kernel.
> > > > It contains a number of bugfixes and all 2.6.20 users are recommended to
> > > > upgrade.
> > > >
> > > > The diffstat and short summary of the fixes are below.
> > > >
> > > > I'll also be replying to this message with a copy of the patch between
> > > > 2.6.20.2 and 2.6.20.3.
> > >
> > > Compared to 2.6.20.1 (will try 2.6.20.2 as well), I now get:
> >
> > err, duh -- this is a Sun Ultra 60, debian testing install.
>
> Figure out if 2.6.20.2 does it too, then please try to git bisect
> it down further.

Yep, that's the plan, just wanted to make folks aware.

> I took a quick look and the two sparc64 commits between 2.6.20.1
> and 2.6.20.2 are benign, a fix for E450 interrupts and a kenvctrld
> fix which is for a driver for hardware your ultra60 doesn't have. :)
>
> There is a decent amount of raid and nfs fixes in here, do you
> use either?

Neither.

> Another commit that might be relevant is:
>
> commit 530b09160744a12450fdacb2b78779c9830a29c8
> Author: Aristeu Sergio Rozanski Filho <aristeu.sergio@gmail.com>
> Date:   Thu Mar 1 19:02:55 2007 -0500
>
>     tty_io: fix race in master pty close/slave pty close path
>
> Hmmm...
>
> Please let us know if you can narrow it down further.

Building 2.6.20.2 right now, will let you know.

Thanks,
Nish
