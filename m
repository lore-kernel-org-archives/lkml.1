Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbZBDUqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbZBDUqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZBDUqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:46:46 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:48102 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZBDUqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:46:45 -0500
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
From: Jon Masters <jonathan@jonmasters.org>
To: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200902042134.32346.rusty@rustcorp.com.au>
References: <20090130123358.GA26216@redhat.com>
	 <20090203134110.GC6607@linux.vnet.ibm.com>
	 <m1ocxivlch.fsf@fess.ebiederm.org>
	 <200902042134.32346.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Wed, 04 Feb 2009 15:46:43 -0500
Message-Id: <1233780403.4166.39.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 21:34 +1030, Rusty Russell wrote:
> On Wednesday 04 February 2009 15:40:06 Eric W. Biederman wrote:
> > static struct kthread *to_kthread(struct task_struct *tsk)
> > {
> > 	void *stack = task_stack_page(tsk);
> > 	return (struct kthread *)(stack + kthread_offset);
> >         
> > }
> ...
> > It would remove the test and be simple and obviously correct.
> 
> Clever? Sure.  Neat? Yes.
> 
> But you are using a definition of obvious with which I was not previously
> familiar :)

I wonder if he knows precisely when Jon Corbet is reading his email and
gets these fantastic one-liners ready ahead of time, or if they flow
naturally by happenstance. I guess it's the latter.

Jon.


