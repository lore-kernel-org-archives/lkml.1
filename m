Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbXGPGm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbXGPGm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 02:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXGPGmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 02:42:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:41683 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752496AbXGPGmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 02:42:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+xzhsmZ0Cx7qsD7nuRDuuVDT7RBVueXKeCvZ0Unk
	h/5f0cteJW6bVK
Subject: Re: [patch] CFS scheduler, -v19
From: Mike Galbraith <efault@gmx.de>
To: Markus <lists4me@web.de>
Cc: Ed Tomlinson <edt@aei.ca>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <200707152311.05286.lists4me@web.de>
References: <20070706173319.GA2356@elte.hu>
	 <200707151453.57725.lists4me@web.de>
	 <1184528791.6324.41.camel@Homer.simpson.net>
	 <200707152311.05286.lists4me@web.de>
Content-Type: text/plain
Date: Mon, 16 Jul 2007 08:42:45 +0200
Message-Id: <1184568165.6317.63.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 23:11 +0200, Markus wrote:
> > > [1] http://lkml.org/lkml/2007/07/14/60
> > 
> > Hm.  Tasks disappearing isn't you're typical process scheduler problem
> > by any means, nor is an idle box exhibiting mouse "lurchiness".  Is
> > there anything unusual in your logs?
> 
> I know that its not typical, but when my current kernel is stable and 
> shows the same problem with the cfs-patch applied like the 
> git-snapshot, I would say its a cfs issue.

Yes, from your description, and with the now presented additional
information that the git-snapshot exhibits the same symptoms, it sounds
like cfs _may_ be implicated in some way.  I can't imagine how at the
moment.  In your original report, there are other patches involved,
which are an unknown variables.  The git-snapshot contains very many
changes other than cfs as well.  I'd eliminate absolutely all unknowns
as the first step.

> But I can build a plain 2.6.22 without cfs and one with it and compare 
> dmesgs output, if that helps.

Yes.  It would definitely be worth while to test a virgin stable kernel,
and then add only cfs with identical config.  Dmesg output may not turn
up anything, but eliminating all other variables should either pin the
tail on the donkey (cfs?) or vindicate it, and that's what needs to be
nailed down solidly first.

	-Mike

