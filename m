Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZKDKdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZKDKdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 05:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZKDKdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 05:33:15 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59538 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbZKDKdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 05:33:14 -0500
Date: Wed, 04 Nov 2009 19:33:12 +0900 (JST)
Message-Id: <20091104.193312.976610524779424707.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       a.p.zijlstra@chello.nl, efault@gmx.de, acme@redhat.com,
       fweisbec@gmail.com
Subject: Re: [RFC][PATCH 7/7] Adding general performance benchmarking
 subsystem to perf.
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091103172407.GA11535@elte.hu>
References: <20091103074648.GG19928@elte.hu>
	<20091103.195335.229420428319821713.mitake@dcl.info.waseda.ac.jp>
	<20091103172407.GA11535@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 7/7] Adding general performance benchmarking subsystem to perf.
Date: Tue, 3 Nov 2009 18:24:07 +0100

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > > There will be a handful of more details i'm sure but once there's a 
> > > good base we can commit it - would you / will you be interested in 
> > > extending it further and adding more benchmark modules as well?
> > > 
> > > There's quite a few useful small benchmarks that people are using to 
> > > measure the kernel. Having a good collection of them in one place, 
> > > with standardized options and standardized output would be very 
> > > useful.
> > 
> > Yes, of course! Unified benchmarking utilities will be big help for 
> > Linux users including me.
> > 
> > e.g. I think that copybench (http://code.google.com/p/copybench/) will 
> > be good benchmark for I/O, memory and file system. I'll work on this 
> > after that the patch series I'll send later is merged.
> 
> copybench is listed as 'new BSD license'. Might need the pinging of its 
> author whether he considers it GPLv2 compatible.
> 

Yes. I'll contact the author when I try unifying copybench to perf actually.

> > Do you know any other good candidates to include?
> 
> Frederic suggested dbench - although that's quite large as it includes a 
> complete trace of a benchmark run.
> 
> We might want to do similar measurements to lmbench.
> 
> One nice thing would be to have a 'system call benchmark' set - one that 
> measures _all_ system calls, and could thus be used to find regressions 
> on a 'broad' basis. Syscall usage could be gleaned from the LTP project.
> 

These are good candidates.
Especially system call benchmark is nice idea.
I'll try these after completion of base part.
