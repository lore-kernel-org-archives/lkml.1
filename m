Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZIIRe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZIIRe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbZIIRe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:34:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:46552 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753855AbZIIRe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:34:57 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/JbP4PiSHJqKMwvk9g58GS2jVFmleoKrw4H4YODY
	MOc2BHhsCJ00Y4
Subject: Re: [tip:sched/core] sched: Keep kthreads at default priority
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <1252516001.22918.6.camel@laptop>
References: <1252486344.28645.18.camel@marge.simson.net>
	 <tip-61cbe54d9479ad98283b2dda686deae4c34b2d59@git.kernel.org>
	 <20090909172916.949DA526EC9@mailhub.coreip.homeip.net>
	 <1252516001.22918.6.camel@laptop>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 19:34:56 +0200
Message-Id: <1252517696.6220.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 19:06 +0200, Peter Zijlstra wrote:
> On Wed, 2009-09-09 at 09:55 -0700, Dmitry Torokhov wrote:
> > On Wed, Sep 09, 2009 at 03:37:34PM +0000, tip-bot for Mike Galbraith wrote:
> > > 
> > > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > > index eb8751a..5fe7099 100644
> > > --- a/kernel/kthread.c
> > > +++ b/kernel/kthread.c
> > > @@ -16,8 +16,6 @@
> > >  #include <linux/mutex.h>
> > >  #include <trace/events/sched.h>
> > >  
> > > -#define KTHREAD_NICE_LEVEL (-5)
> > > -
> > 
> > Why don't we just redefine it to 0? We may find out later that we'd
> > still prefer to have kernel threads have boost.
> 
> Seems sensible, also the traditional reasoning behind this nice level is
> that kernel threads do work on behalf of multiple tasks. Its a kind of
> prio ceiling thing.

True.  None of our current threads are heavy enough to matter much.

	-Mike

