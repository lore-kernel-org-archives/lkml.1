Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYB2IdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYB2IdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 03:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYB2IdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 03:33:13 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbYB2IdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 03:33:12 -0500
Date: Fri, 29 Feb 2008 00:31:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       Max Krasnyanskiy <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-Id: <20080229003155.bbab795d.akpm@linux-foundation.org>
In-Reply-To: <20080228075010.GA28781@elte.hu>
References: <20080227222103.673194000@chello.nl>
	<20080228075010.GA28781@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 08:50:11 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > My vision on the direction we should take wrt cpu isolation.
> > 
> > Next on the list would be figuring out a nice solution to the 
> > workqueue flush issue.
> 
> nice work Peter, i find this "system sets" extension to cpusets a much 
> more elegant (and much more future-proof) solution than the proposed 
> spreadout of the limited hack of isolcpus/cpu_isolated_map. It 
> concentrates us on a single API and on a single mechanism to handle 
> isolation matters. (be that for clustering/supercomputing or real-time 
> purposes)
> 
> Thanks for insisting on using cpusets for this!
> 
> i've queued up your patches in sched-devel.git, and lets make sure this 
> has no side-effects on existing functionality. (it shouldnt)
> 

It of course lays waste to a series of cgroup patches from Paul Menage
which I already had queued.

So I shall drop git-sched again.

How often do I have to say this?  git-sched is not
git-everything-which-looks-shiny!  It is for the CPU scheduler.

If you had put this patchset into a private branch for private testing, or
even into a separate git-petes-stuff then I wouldn't have to collaterally
drop the entirety of git-sched because of this.

Sigh.

