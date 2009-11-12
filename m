Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZKLUvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZKLUvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbZKLUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:51:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43779 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbZKLUvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:51:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd)
Date: Thu, 12 Nov 2009 21:53:12 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-tst; KDE/4.3.1; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>
References: <200911091250.31626.rjw@sisk.pl> <20091111171703.GA28506@redhat.com> <alpine.LFD.2.00.0911121821370.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911121821370.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911122153.12419.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 November 2009, Thomas Gleixner wrote:
> On Wed, 11 Nov 2009, Oleg Nesterov wrote:
> > Well, yes. Because any buggy user can easily kill the system, and we
> > constantly have the bugs like this one.
> > 
> > I think we should teach workqueue.c to use debugobjects.c at least.
> 
> Here you go. Would be interesting to know whether it catches the
> problem at hand.

How would I tell if it did?

Rafael
