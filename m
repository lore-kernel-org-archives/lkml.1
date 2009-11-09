Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZKID1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZKID1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZKID1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:27:10 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60094 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZKID1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:27:10 -0500
Date: Mon, 09 Nov 2009 12:27:12 +0900 (JST)
Message-Id: <20091109.122712.865412965745306501.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       a.p.zijlstra@chello.nl, efault@gmx.de, acme@redhat.com,
       fweisbec@gmail.com
Subject: Re: [PATCH v2 3/7] Adding general performance benchmarking
 subcommand to perf.
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091108113013.GM11372@elte.hu>
References: <20091103172926.GC11535@elte.hu>
	<20091104.194108.635980116686317754.mitake@dcl.info.waseda.ac.jp>
	<20091108113013.GM11372@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 3/7] Adding general performance benchmarking subcommand to perf.
Date: Sun, 8 Nov 2009 12:30:13 +0100

> > > 
> > > Shouldnt we output the unit of measurement, i.e. '4.575 usecs'? Also, we 
> > > should perhaps print something like:
> > > 
> > >   % perf bench sched pipe
> > > 
> > >   (executing 1000000 pipe operations between two tasks)
> > > 
> > >      4.575 usecs per op
> > >     218579 ops/sec   
> > > 
> > > ?
> > 
> > I have to admit that single float value output is too simple.
> > So I'll fix the default output.
> > 
> > But, I believe that simple form makes sense for
> > processing by scripts or graph tools like gnuplot.
> > I'll add the option (may be --simple) to switch
> > friendliness of outputs.
> 
> Btw., could you make it Git-ish, i.e.:
> 
>  --format=short
> 
> or:
> 
>  --format=simple
> 
> Eventually more format options might be added.

It's good idea.
I have to admit that reserving -s for simple output is not good idea.
I'll do this.
