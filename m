Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYKEDYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYKEDYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 22:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYKEDYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 22:24:23 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58162 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbYKEDYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 22:24:23 -0500
Date: Wed, 5 Nov 2008 08:54:40 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
	controller
Message-ID: <20081105032440.GA3298@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20081025060157.GA4614@in.ibm.com> <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com> <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com> <20081027044319.GA4386@in.ibm.com> <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com> <49057ADD.1050705@cn.fujitsu.com> <20081030171622.GA19872@linux.vnet.ibm.com> <20081031094041.194a32d9.kamezawa.hiroyu@jp.fujitsu.com> <20081104124937.GB4898@in.ibm.com> <20081104092040.781f9546.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104092040.781f9546.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 09:20:40AM -0800, Randy Dunlap wrote:
> On Tue, 4 Nov 2008 18:19:37 +0530 Bharata B Rao wrote:
> 
> > Add hierarchical accounting to cpu accounting controller and cpuacct
> > documentation.
> > 
> > Currently, while charging the task's cputime to its accounting group,
> > the accounting group hierarchy isn't updated. This patch charges the cputime
> > of a task to its accounting group and all its parent accounting groups.
> > 
> > Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > Reviewed-by: Paul Menage <menage@google.com>
> > ---
> >  Documentation/controllers/cpuacct.txt |   32 ++++++++++++++++++++++++++++++++
> >  kernel/sched.c                        |   10 ++++++++--
> >  2 files changed, 40 insertions(+), 2 deletions(-)
> > 
> > --- /dev/null
> > +++ b/Documentation/controllers/cpuacct.txt
> > @@ -0,0 +1,32 @@
> > +CPU Accounting Controller
> > +-------------------------
> > +
> > +The CPU accounting controller is used to group tasks using cgroups and
> > +account the CPU usage of these group of tasks.
> > +
> > +The CPU accounting controller supports multi-hierarchy groups. An accounting
> > +group accumulates the CPU usage of all of it's child groups and
> 
>                                              its  {it's means "it is"}
> 
> > +the tasks directly present in it's group.
> 
>                                  its

You are right, I was under the wrong impression that possessive case of
"it" is still "it's".

I will resend the patch with other corrections you mentioned only if
Paul/Ingo want this patch to go in.

Thanks for your comments.

Regards,
Bharata.
