Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbYCKXMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbYCKXMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYCKXMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:12:18 -0400
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:53731
	"EHLO QMTA08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbYCKXMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:12:17 -0400
X-Authority-Analysis: v=1.0 c=1 a=w_3Tt_6PZGEA:10 a=VwQbUJbxAAAA:8
 a=DdFyJILD2Mcnk9e7cMYA:9 a=az6IGoXJtmdHbICsJ78A:7
 a=EWmNNMogD7N3s8HUsiflBXNTiEIA:4 a=si9q_4b84H0A:10 a=WuK_CZDBSqoA:10
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
From: Nicholas Miell <nmiell@comcast.net>
To: Cyrus Massoumi <cyrusm@gmx.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, "Molnar, Ingo" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47D6FAD0.1020608@gmx.net>
References: <200803111749.29143.nickpiggin@yahoo.com.au>
	 <1205269674.12854.16.camel@entropy>  <47D6FAD0.1020608@gmx.net>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 16:12:12 -0700
Message-Id: <1205277132.12854.19.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-11 at 22:34 +0100, Cyrus Massoumi wrote:
> Nicholas Miell wrote:
>
> > (Also, ignoring MySQL because it's a terrible piece of software at least
> > when regarding it's scalability is a bad idea. It's the M in LAMP, it
> > has a huge user base, and FreeBSD manages to outperform Linux with the
> > same unscalable piece of software.)
> 
> Did you actually see this? 
> http://www.kernel.org/pub/linux/kernel/people/npiggin/sysbench/
> 
> FreeBSD does not outperform Linux, it's actually a bit faster according 
> to Nick's tests.

I am aware of those results, but in the mail I was responding to, Nick
Piggin said the following:

> The problem with MySQL contention means that if the scheduler
> unluckily chooses to deschedule a lock holder, then you can get
> idle time building up on other cores and you can get context switch
> cascades as things all pile up onto this heavily contended lock. As
> such, it means MySQL is not an ideal candidate for looking at
> performance behaviour. I discounted the relatively worse scaling of
> MySQL with 2.6.25-rc (than 2.6.22) as such an effect.

which I interpreted to mean that MySQL performs worse on 2.6.23+ than on
2.6.22 but for some reason this doesn't matter.

-- 
Nicholas Miell <nmiell@comcast.net>

