Return-Path: <linux-kernel-owner+w=401wt.eu-S1763517AbZEHM7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763517AbZEHM7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760421AbZEHM6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:58:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:43036 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759022AbZEHM6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:58:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,317,1239001200"; 
   d="scan'208";a="140690971"
Date: Fri, 8 May 2009 20:58:21 +0800
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
Subject: ftrace: concurrent accesses possible?
Message-ID: <20090508125821.GC15949@localhost>
References: <20090508105320.316173813@intel.com> <20090508111031.020574236@intel.com> <20090508114742.GB17129@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508114742.GB17129@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 08, 2009 at 07:47:42PM +0800, Ingo Molnar wrote:
> 
> So this should be done in cooperation with instrumentation folks, 
> while improving _all_ of Linux instrumentation in general. Or, if 
> you dont have the time/interest to work with us on that, it should 
> not be done at all. Not having the resources/interest to do 
> something properly is not a license to introduce further 
> instrumentation crap into Linux.

I have a dummy question on /debug/trace: is it possible to
- use 2+ tracers concurrently?
- run a system script that makes use of a tracer,
  without disturbing the sysadmin's tracer activities?
- access 1 tracer concurrently from many threads,
  with different filter etc. options?

If not currently, will private mounts be a viable solution?

Thanks,
Fengguang
