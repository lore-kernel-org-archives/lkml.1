Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZD1TgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZD1TgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbZD1Tfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:35:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42787 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbZD1Tfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:35:51 -0400
Date: Tue, 28 Apr 2009 21:22:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       tglx@linutronix.de, x86@kernel.org
Subject: Re: mmotm 2009-02-17-12-33 uploaded
Message-ID: <20090428192219.GA3398@redhat.com>
References: <200902172050.n1HKorvc028933@imap1.linux-foundation.org> <499BD65B.2080307@gmail.com> <20090218015356.4454f758.akpm@linux-foundation.org> <200902182245.27525.rusty@rustcorp.com.au> <20090218145037.GA24240@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218145037.GA24240@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty, Andrew,

On 02/18, Oleg Nesterov wrote:
>
> On 02/18, Rusty Russell wrote:
> >
> > On Wednesday 18 February 2009 20:23:56 Andrew Morton wrote:
> > > Someone else has been mucking with kthread.c in linux-next, and a
> > > couple of days ago that mucking got dropped from linux-next.  Perhaps
> > > this churn broke Oleg's patch.
>
> "[merged] kthread-dont-looking-for-a-task-in-create_kthread-2.patch"
> has "create->result = current;" in kthread(), then this line was
> lost somehow,
>
> > Oleg and I had an accidentally-offlist chat about these patches.
> >
> > Last we decided, a more ambitious approach was desired.  Patches RSN.
>
> Yes, but can't we do this on top of current patches?
>
> We are going to change the API a bit, so that kthread_create() bumps
> a reference to task_struct. I think it would be nice to separate the
> API changes from the implementation changes.

So, what happened with

	kthreads-simplify-the-startup-synchronization.patch
	http://marc.info/?l=linux-mm-commits&m=123335224710768

	kthreads-rework-kthread_stop.patch
	http://marc.info/?l=linux-mm-commits&m=123335227910835

patches? Can't find them in any tree.

Oleg.

