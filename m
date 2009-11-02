Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZKBN1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZKBN1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZKBN1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:27:35 -0500
Received: from ozlabs.org ([203.10.76.45]:51678 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZKBN1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:27:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC] Adding hackbench.c to tools/
Date: Mon, 2 Nov 2009 23:57:36 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>
References: <20091101.131027.680961629714047921.mitake@dcl.info.waseda.ac.jp> <20091102104124.GA5193@elte.hu>
In-Reply-To: <20091102104124.GA5193@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911022357.36541.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 09:11:24 pm Ingo Molnar wrote:
> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > Hi Ingo,
> > 
> > It seems that hackbench is the de-fact standard benchmarking program 
> > for scheduler of Linux. But when I ask google where hackbench.c is, 
> > some answers are replied. Like these, (in order of google result)
> > 
> > http://devresources.linux-foundation.org/craiger/hackbench/ (this page 
> > containts link to hackbench.c) 
> > http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
> > 
> > And it seems that second one is newer.
> > 
> > I think this situation is very confusable. So I wrote this patch to 
> > add hackbench to tools/ of kernel tree. This may help hackbench users 
> > like me.
> 
> I think we can do something nicer: would you be interested in adding it 
> as a 'perf bench hackbench' sub-command of tools/perf/?
> 
> We already have the tools to measure scheduling behavior under 'perf 
> sched', so having a 'perf bench' array of common tests would be nice to 
> have.
> 
> ( I've Cc:-ed Rusty, the original author of hackbench.c. Rusty, the file 
>   has no explicit GPLv2 compatible license - is it fine to be put
>   into GPLv2 code? )

Yep, like all my code it's standard v2 "or later".

Sounds like a good plan, thanks!
Rusty.
