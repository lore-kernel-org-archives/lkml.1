Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZDGHFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZDGHFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZDGHFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:05:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:14874 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbZDGHFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:05:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,336,1235980800"; 
   d="scan'208";a="128660884"
Date: Tue, 7 Apr 2009 15:05:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avan Anishchuk <matimatik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] ramfs: fix double freeing s_fs_info on failed mount
Message-ID: <20090407070507.GA500@localhost>
References: <20090405193944.GA12691@elte.hu> <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain> <alpine.LFD.2.00.0904062045530.4010@localhost.localdomain> <alpine.LFD.2.00.0904062108550.4010@localhost.localdomain> <alpine.LFD.2.00.0904062142110.4010@localhost.localdomain> <20090407052801.GA4235@elte.hu> <20090407055502.GA22881@localhost> <20090407060309.GA21788@elte.hu> <20090407061650.GA31745@localhost> <20090407065308.GA19470@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407065308.GA19470@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 02:53:08PM +0800, Ingo Molnar wrote:
> 
> * Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > 
> > If ramfs mount fails, s_fs_info will be freed twice in 
> > ramfs_fill_super() and ramfs_kill_sb(), leading to kernel oops.
> > 
> > Consolidate and beautify the code. Make sure s_fs_info and s_root 
> > are in known good states.
> > 
> > Acked-by: Wu Fengguang <fengguang.wu@intel.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Nit: the commit is missing a Reported-by :)
> 
> Linus might not insist on seeing his name mentioned yet another time 
> in a commit, but it's generally good practice to always add bug 
> report info and names.
> 
> Note that in this case the really hard work was there: Linus had to 
> spend at least 2 hours on tracking down and bisecting this bug. (and 
> Linus probably did this super-fast compared to the average tester - 
> most other bug reporters spend a day or more on bisection, limited 
> by lack of practice and by the slowness of kernel builds on ordinary 
> hardware.)
> 
> So the real human effort was spent there, not in my 5 minutes on 
> fixing the bug that Linus served on a plate - while the commit only 
> credits me. That's not fair :)

Good point! Thank you very much for mentoring me on this whole process!

> See the tip:out-of-tree local commit i made and sent out.

Yes I've seen that, very comprehensive changelog and solid&pretty code!

Best regards,
Fengguang Wu

