Return-Path: <linux-kernel-owner+w=401wt.eu-S1751485AbXBNIKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbXBNIKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXBNIKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:10:19 -0500
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:38118 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbXBNIKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:10:07 -0500
From: Con Kolivas <kernel@kolivas.org>
To: malc <av1474@comtv.ru>
Subject: Re: CPU load
Date: Wed, 14 Feb 2007 19:09:09 +1100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <loom.20070212T063225-663@post.gmane.org> <200702140908.44934.kernel@kolivas.org> <Pine.LNX.4.64.0702141023000.672@home.oyster.ru>
In-Reply-To: <Pine.LNX.4.64.0702141023000.672@home.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141909.09848.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 18:28, malc wrote:
> On Wed, 14 Feb 2007, Con Kolivas wrote:
> > On Wednesday 14 February 2007 09:01, malc wrote:
> >> On Mon, 12 Feb 2007, Pavel Machek wrote:
> >>> Hi!
>
> [..snip..]
>
> >>> I have (had?) code that 'exploits' this. I believe I could eat 90% of
> >>> cpu without being noticed.
> >>
> >> Slightly changed version of hog(around 3 lines in total changed) does
> >> that easily on 2.6.18.3 on PPC.
> >>
> >> http://www.boblycat.org/~malc/apc/load-hog-ppc.png
> >
> > I guess it's worth mentioning this is _only_ about displaying the cpu
> > usage to userspace, as the cpu scheduler knows the accounting of each
> > task in different ways. This behaviour can not be used to exploit the cpu
> > scheduler into a starvation situation. Using the discrete per process
> > accounting to accumulate the displayed values to userspace would fix this
> > problem, but would be expensive.
>
> Guess you are right, but, once again, the problem is not so much about
> fooling the system to do something or other, but confusing the user:

Yes and I certainly am not arguing against that.

>
> a. Everything is fine - the load is 0%, the fact that the system is
>     overheating and/or that some processes do not do as much as they
>     could is probably due to the bad hardware.
>
> b. The weird load pattern must be the result of bugs in my code.
>     (And then a whole lot of time/effort is poured into fixing the
>      problem which is simply not there)
>
> The current situation ought to be documented. Better yet some flag can
> be introduced somewhere in the system so that it exports realy values to
> /proc, not the estimations that are innacurate in some cases (like hog)

I wouldn't argue against any of those either. schedstats with userspace tools 
to understand the data will give better information I believe.

-- 
-ck
