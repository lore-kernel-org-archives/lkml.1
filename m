Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbZLGO5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbZLGO5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbZLGO5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:57:49 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54726 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbZLGO5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:57:49 -0500
Date: Mon, 07 Dec 2009 23:57:52 +0900 (JST)
Message-Id: <20091207.235752.91877032.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       paulus@samba.org, tzanussi@gmail.com, srostedt@redhat.com
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for
 analyzing lock statistics
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091207072752.GG10868@elte.hu>
References: <1260156884-8474-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<20091207044125.GB5262@nowhere>
	<20091207072752.GG10868@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for analyzing lock statistics
Date: Mon, 7 Dec 2009 08:27:52 +0100

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Dec 07, 2009 at 12:34:44PM +0900, Hitoshi Mitake wrote:
> > > This patch adds new subcommand "lock" to perf for analyzing lock usage statistics.
> > > Current perf lock is very primitive. This cannot provide the minimum functions.
> > > Of course I continue to working on this.
> > > But too big patch is not good thing for you, so I post this.
> > 
> > Oh great!
> > Yeah, the work can be done incrementally.
> >
> [...]
> >
> > 
> > Very nice and promising!
> > 
> > I can't wait to try it.
> 
> ok, to ease testing i've created a new (and not yet permanent) topic 
> tree for it to track this new perf feature: tip:perf/lock and pushed it 
> out.
> 
> Note: because it's not yet in a final form i have not merged it into 
> tip:master yet - when you are working on these bits you need to do this 
> manually via:
> 
>   git merge tip/perf/lock
> 
> Also, we might need to rebase this branch as it's WIP, so the commit IDs 
> are not permanent yet. But i thought it would be easier to do deltas on 
> this basis.

Thanks!

> 
> Hitoshi-san, the patches did not have a Signed-off-by line from you, can 
> i add them for you?

Yes of course. I didn't signed
because these were too experimental things for master branch.
But I can sign on these as experimental things on experimental branch.

> 
> Also, i agree that the performance aspect is probably the most pressing 
> issue. Note that 'perf bench sched messaging' is very locking intense so 
> a 10x slowdown is not entirely unexpected - we still ought to optimize 
> it all some more. 'perf lock' is an excellent testcase for this in any 
> case.

Yeah, as I described in my reply to Frederic,
separating lockdep and lock events for perf lock
might be solution for performance problem. I'll try it.

Thanks
	Hitoshi
