Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbYCLJEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbYCLJEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYCLJDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:03:54 -0400
Received: from mga05.intel.com ([192.55.52.89]:37687 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750899AbYCLJDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:03:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,486,1199692800"; 
   d="scan'208";a="532565342"
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Cyrus Massoumi <cyrusm@gmx.net>, Nick Piggin <nickpiggin@yahoo.com.au>,
       "Molnar, Ingo" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1205277132.12854.19.camel@entropy>
References: <200803111749.29143.nickpiggin@yahoo.com.au>
	 <1205269674.12854.16.camel@entropy>  <47D6FAD0.1020608@gmx.net>
	 <1205277132.12854.19.camel@entropy>
Content-Type: text/plain; charset=utf-8
Date: Wed, 12 Mar 2008 17:00:55 +0800
Message-Id: <1205312455.3215.32.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 16:12 -0700, Nicholas Miell wrote:
> On Tue, 2008-03-11 at 22:34 +0100, Cyrus Massoumi wrote:
> > Nicholas Miell wrote:
> >
> > > (Also, ignoring MySQL because it's a terrible piece of software at least
> > > when regarding it's scalability is a bad idea. It's the M in LAMP, it
> > > has a huge user base, and FreeBSD manages to outperform Linux with the
> > > same unscalable piece of software.)
> > 
> > Did you actually see this? 
> > http://www.kernel.org/pub/linux/kernel/people/npiggin/sysbench/
> > 
> > FreeBSD does not outperform Linux, it's actually a bit faster according 
> > to Nick's tests.
> 
> I am aware of those results, but in the mail I was responding to, Nick
> Piggin said the following:
> 
> > The problem with MySQL contention means that if the scheduler
> > unluckily chooses to deschedule a lock holder, then you can get
> > idle time building up on other cores and you can get context switch
> > cascades as things all pile up onto this heavily contended lock. As
> > such, it means MySQL is not an ideal candidate for looking at
> > performance behaviour. I discounted the relatively worse scaling of
> > MySQL with 2.6.25-rc (than 2.6.22) as such an effect.
> 
> which I interpreted to mean that MySQL performs worse on 2.6.23+ than on
> 2.6.22 but for some reason this doesn't matter.
That's because 2.6.23-rc lack the cache hot feature of scheduler. Ingo fixed
it in 2.6.24-rc.

-yanmin


