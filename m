Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZKLUyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZKLUyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZKLUyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:54:40 -0500
Received: from www.tglx.de ([62.245.132.106]:38006 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZKLUyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:54:40 -0500
Date: Thu, 12 Nov 2009 21:53:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on
 resume
In-Reply-To: <4AFC5F2E.9040709@kernel.org>
Message-ID: <alpine.LFD.2.00.0911122152080.24119@localhost.localdomain>
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <20091111171703.GA28506@redhat.com>
 <alpine.LFD.2.00.0911121821370.24119@localhost.localdomain> <4AFC5F2E.9040709@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009, Tejun Heo wrote:
> 11/13/2009 02:33 AM, Thomas Gleixner wrote:
> > Subject: workqueue: Add debugobjects support
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Thu, 12 Nov 2009 16:25:34 +0100
> > 
> > Add debugobject support to track the life time of work_structs.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> This looks great.  I'm about to create a wq tree for concurrency
> managed workqueue patches.  Do you mind if I route this patch through
> there?

Not at all. That patch is barely tested and when you are anyway
fooling around with the workqueue code it's the best place to go.

Thanks,

	tglx
