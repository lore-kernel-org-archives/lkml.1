Return-Path: <linux-kernel-owner+w=401wt.eu-S1764519AbZAQQVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764519AbZAQQVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbZAQQV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:21:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:60764 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752680AbZAQQV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:21:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18i5iE1M/4iAkmuGCGuSdbaNRXapdA7aLXvcd/eT3
	kl22ZxXAZi7E2y
Subject: Re: [git pull] scheduler fixes
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Kevin Shanahan <kmshanah@ucwb.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090117160115.GA31601@elte.hu>
References: <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	 <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
	 <1232193617.14073.67.camel@laptop>
	 <1232194752.6273.5.camel@marge.simson.net>
	 <20090117044316.bda7d0bd.akpm@linux-foundation.org>
	 <1232198574.16303.8.camel@marge.simson.net>
	 <20090117160115.GA31601@elte.hu>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 17:21:21 +0100
Message-Id: <1232209281.5987.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 17:01 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Sat, 2009-01-17 at 04:43 -0800, Andrew Morton wrote:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=12465 just popped up - another
> > > scheduler regression.  It has been bisected.
> > 
> > Seems pretty clear.  I'd suggest reverting it.
> 
> We can revert it (and will revert it if no solution is found), but i'd 
> also like to understand why it happens, because that kind of regression 
> from this change is unexpected - we might be hiding some bug that could 
> pop up under less debuggable circumstances, so we need to understand it 
> while we have a chance.

Agree.  However, with the sched_mc stuff, mysql+oltp now does better
with NEWIDLE on than off as well, as does an nfs kbuild.

	-Mike

