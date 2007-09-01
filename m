Return-Path: <linux-kernel-owner+w=401wt.eu-S932956AbXIAWws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956AbXIAWws (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXIAWwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:52:41 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:57719 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbXIAWwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Dcma9rWUOgNxrOdxMwahQm+izqcj9qQxFOQrK0NBVY9yVqx9my5wiGh7WvMrdxKY5xPxVNKw7YjNPyzxSg4CVM7yAM6ESYbMEypZCgG9bxYIAx1ljfOJQScyR1CPc6gTLE9TmemquhcJkwCK0ZQidMI2kA8awLaUTy8pxQVyzTY=
Message-ID: <8bd0f97a0709011552u687bcdc7i3a9154b24523796d@mail.gmail.com>
Date: Sat, 1 Sep 2007 18:52:39 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, mbligh@mbligh.org
In-Reply-To: <200709010214.11128.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
	 <200709010214.11128.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Fri 31 Aug 2007 17:22, Mike Frysinger pondered:
> > is there any sort of standard for testing and integration into
> > mainline ?  in the Blackfin world, we've been developing little
> > external kernel modules and adding them to our own testsuite, but
> > often times these things are not Blackfin specific.  case in point,
> > we're integrating a string testsuite to make sure all of the fun str*
> > and mem* functions are sane and operate as they expected, but rather
> > than having just Blackfin benefit here, i'd like to see this pushed
> > upstream ...
>
> I know there have been some discussions at past OLS about some testing that
> Martin was working on.
>
> http://www.linuxsymposium.org/2006/view_abstract.php?content_key=13
>
> But I think this was more functional tests, less unit tests that what you are
> talking/asking about.
>
> http://test.kernel.org/functional/index.html
>
> Also - If I remember - most of the existing tests were for a self hosted
> environment - and might not be well suited to embedded (like Blackfin) which
> requires cross compile, and pretty thin runtime environment (uClibc +
> busybox's msh as shell).

i flipped through the autotest code a bit but i dont think this can do
what i'm looking for.  it appears to be a mix of LTP provides and what
we have for our Blackfin test infrastructure -- iow, all userspace
stuff and no real way of exercising kernel internals.
-mike
