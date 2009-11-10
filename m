Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZKJOnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZKJOnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZKJOnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:43:05 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:63392 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbZKJOnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:43:05 -0500
Date: Tue, 10 Nov 2009 23:43:06 +0900 (JST)
Message-Id: <20091110.234306.265850902.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
       fweisbec@gmail.com
Subject: Re: [PATCH 0/3] perf bench: Clean and add document for perf-bench
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091110131738.GA31158@elte.hu>
References: <1257853855-28934-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<20091110131738.GA31158@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3] perf bench: Clean and add document for perf-bench
Date: Tue, 10 Nov 2009 14:17:38 +0100

> Applied, thanks!
> 
> Btw., a small detail i noticed when running the pipe benchmark:
> 
> earth4:~/tip/tools/perf> ./perf bench sched pipe
> (executing 1000000 pipe operations between two tasks)
> 
> 	Total time:5.076 sec
> 		5.076232 usecs/op
> 		196996 ops/sec
> 
> when i typed 'perf bench sched pipe' nothing happened for several 
> seconds. The command did not finish and no output was printed.
> 
> This might surprise users - it's always good to print a single line that 
> we are processing a benchmark. Maybe this could be printed from the 
> generic subcommand, something like:
> 
>   running sched/pipe benchmark ...
> 
> What do you think?

Yeah, I have to admit that. Current style, keeping user wait
and print everything suddenly after finish, is not good.
I'll fix it.

And I also want to fix 

> 	Total time:5.076 sec
> 		5.076232 usecs/op
> 		196996 ops/sec

this style. This is too bad.
So I'll imitate style of perf-stat for making this format better.

   Hitoshi
