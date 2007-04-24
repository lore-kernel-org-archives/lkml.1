Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbXDXCfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbXDXCfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbXDXCfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:35:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:5729 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbXDXCfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iln22vK0lGdFHaZAudL0IdvLksFCrs+BZGWh0j1KHOzUKKKdbOEB2RrHFyaZUSRC+cwfmNyqw+UHxvCB7+Y0THvVNmO+js5Is9xU5I8Y96QDK01cOgMSZ3fgQiNwas2hYUPlDekrMSNVMaojLHA01uhPJzJS2PmlVP5qo9u5MYA=
Message-ID: <a781481a0704231935o5d878692p2311b834f5c6d47e@mail.gmail.com>
Date: Tue, 24 Apr 2007 08:05:18 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Matt Ranon" <mranon@javadevices.com>
Subject: Re: [ANNOUNCE][PATCH] Kcli - Kernel command line interface.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "linux maillist" <linux-kernel@vger.kernel.org>
In-Reply-To: <617125.34935.qm@web88104.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <617125.34935.qm@web88104.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 4/24/07, Matt Ranon <mranon@javadevices.com> wrote:
> > The obvious question is: what's _wrong_ with doing all this in some
> > cut-down userspace environment like busybox?  Why is this stuff better?
> >
> > Obviously some embedded developers have considered that option and
> > have rejected it.  But we do need to be told, at length, why that
> > decision was made.
>
> There is nothing _wrong_ with doing it all in a cut-down userspace. It
> is a matter of personal preference, culture, and the application. That
> is what makes Linux so great, it is all about choice.
>
> We are developing devices that don't have a user space, and we don't
> see the point in including one just for debug purposes. We will not be
> offended if Kcli is not included into the kernel mainline, nor if Kcli compels
> people to call us stupid (as it already has) just because we are different
> and some people don't understand us. We are firm believers that the
> world, including the Linux kernel world,  would be a nasty place if there
> was only _one_ way to do any given task. Additionally, we  are almost
> certain that there will be others who think like we do, so we are reaching
> out to them. We also feel compelled to give _something_ back to the
> community that has given so much to us, and, for now, this is all we have.

I'm afraid you might've misunderstood the (rather caustic, sometimes)
general nature of comments on lkml :-) But I guess you only have
everything to gain if you use features that have been developed (and
are being *maintained* in the current kernel) that already do the kind
of stuff you want done.

You might have your reasons for being so anxious to avoid any
userspace at all, but quoting famous words, continuing to maintain
Kcli out-of-tree could soon turn out to be an act for
self-flagellation for you :-)
