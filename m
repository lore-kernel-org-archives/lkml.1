Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZEIKrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZEIKrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 06:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZEIKrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 06:47:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:22061 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZEIKrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 06:47:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,320,1239001200"; 
   d="scan'208";a="140999433"
Date: Sat, 9 May 2009 18:45:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [patch] tracing/mm: add page frame snapshot trace
Message-ID: <20090509104516.GC8120@localhost>
References: <20090508105320.316173813@intel.com> <20090508111031.020574236@intel.com> <20090508114742.GB17129@elte.hu> <20090508124433.GB15949@localhost> <20090509062758.GB21354@elte.hu> <20090509091325.GA7994@localhost> <20090509092431.GB13784@elte.hu> <20090509094316.GA5520@localhost> <20090509102254.GA15245@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509102254.GA15245@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 06:22:54PM +0800, Ingo Molnar wrote:
> 
> * Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > > How about changing it from 'trigger' to 'dump_range':
> > 
> > That's a better name!
> > 
> > >    echo "*" > /debug/tracing/objects/mm/pages/dump_range
> > > 
> > > being a shortcut for 'dump all'?
> > 
> > No I'm not complaining about -1. That's even better than "*",
> > because the latter can easily be expanded by shell ;)
> > 
> > > And:
> > > 
> > >    echo "1000 2000" > /debug/tracing/objects/mm/pages/dump_range
> > > 
> > > ?
> > 
> > Now it's much more intuitive!
> > 
> > > The '1000' is the offset where the dumping starts, and 2000 is the 
> > > size of the dump.
> > 
> > Ah the second parameter 2000 can easily be taken as "end"..
> 
> Ok ... i've changed the name to dump_range and added your fix for 
> mapcount as well. I pushed it all out to -tip.

Thanks.

> Would you be interested in having a look at that and tweaking the 
> dump_range API to any variant of your liking, and sending a patch 
> for that? Both "<start> <end>" and "<start> <size>" (or any other 
> variant) would be fine IMHO.

Sure. I can even volunteer the process/file page walk works :)

> The lseek hack is nice (and we can keep that) but an explicit range 
> API would be nice, we try to keep all of ftrace scriptable.

OK.

Thanks,
Fengguang
