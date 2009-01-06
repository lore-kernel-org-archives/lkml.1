Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZAFHMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZAFHMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZAFHM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:12:29 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:33399 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZAFHM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:12:28 -0500
Date: Tue, 6 Jan 2009 12:40:18 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [BUG] 2.6.28-git LOCKDEP: Possible recursive rq->lock
Message-ID: <20090106071018.GC4574@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090104174450.GB4301@dirshya.in.ibm.com> <1231092523.29980.4.camel@twins> <20090105040635.GF4301@dirshya.in.ibm.com> <20090105130638.GB6014@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090105130638.GB6014@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2009-01-05 14:06:38]:

> 
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-01-04 19:08:43]:
> > 
> > > On Sun, 2009-01-04 at 23:14 +0530, Vaidyanathan Srinivasan wrote:
> > > > Hi Ingo,
> > > > 
> > > > Kernbench runs on latest Linux git tree stalled with the following
> > > > lockdep warning.
> > > > 
> > > > Lockdep warning and lockup on Jan 3 Linus git tree
> > > > commit 7d3b56ba37a95f1f370f50258ed3954c304c524b
> > > > 
> > > > kernbench run with two threads stalled.  sched_mc was zero.
> > > > x86_64 system with 8 logical CPUs in dual socket quad core
> > > > configuration.
> > > > 
> > > > I will post more information as I debug this warning/bug.  
> > > 
> > > Its ca109491f612aab5c8152207631c0444f63da97f, I've some ideas on how to
> > > fix this, just haven't gotten around to actually doing anything --
> > > seeing how it was holidays and such..
> > 
> > Hi Peter,
> > 
> > I can definitely test your fix when you have them.  I have an
> > autotest job that hits this bug.
> 
> could you check latest tip/master, it has Peter's and Thomas's hrtimer 
> fixes.

Hi Ingo,

I have started a test run with the today's sched-tip.  I will report
results.

--Vaidy

