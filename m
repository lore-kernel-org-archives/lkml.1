Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZD1LhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZD1LhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZD1LhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:37:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:24754 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbZD1LhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:37:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,260,1239001200"; 
   d="scan'208";a="136743187"
Date: Tue, 28 Apr 2009 19:36:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?utf-8?B?RnLpppjpp7tpYw==?= Weisbecker <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090428113616.GA22439@localhost>
References: <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com> <20090428092918.GC21085@elte.hu> <20090428183237.EBDE.A69D9226@jp.fujitsu.com> <20090428093833.GE21085@elte.hu> <20090428095551.GB21168@localhost> <20090428110553.GD25347@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428110553.GD25347@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 07:05:53PM +0800, Ingo Molnar wrote:
> 
> * Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > > See my other mail i just sent: it would be a natural extension 
> > > of tracing to also dump all current object state when tracing is 
> > > turned on. That way no drop_caches is needed at all.
> > 
> > I can understand the merits here - I also did readahead 
> > tracing/accounting in _one_ piece of code. Very handy.
> > 
> > The readahead traces are now raw printks - converting to the 
> > ftrace framework would be a big win.
> > 
> > But. It's still not a fit-all solution. Imagine when full data 
> > _since_ booting is required, but the user cannot afford a reboot.
> 
> The above 'get object state' interface (which allows passive 
> sampling) - integrated into the tracing framework - would serve that 
> goal, agreed?

Agreed. That could in theory a good complement to dynamic tracings.

Then what will be the canonical form for all the 'get object state'
interfaces - "object.attr=value", or whatever? I'm afraid we will have
to sacrifice efficiency or human readability to have a normalized form.
Or to define two standard forms? One "key value" form and one "value1
value2 value3..." form?

Thanks,
Fengguang

