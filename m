Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZD1JGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZD1JGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZD1JGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:06:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55530 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbZD1JGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:06:35 -0400
Date: Tue, 28 Apr 2009 11:10:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090428091034.GL27382@one.firstfloor.org>
References: <20090428010907.912554629@intel.com> <20090428014920.769723618@intel.com> <20090428065507.GA2024@elte.hu> <20090428074031.GK27382@one.firstfloor.org> <1240909484.1982.16.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240909484.1982.16.camel@penberg-laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, zero overhead is important for certain things (like
> CONFIG_SLUB_STATS, for example). However, putting slab allocator
> specific checks in fs/proc looks pretty fragile to me. It would be nice

Ok, perhaps that could be put into a inline into slab.h. Would
that address your concerns?

> Also, while you probably don't want to use tracepoints for this kind of
> instrumentation, you might want to look into reusing the ftrace
> reporting bits.

There's already perfectly fine code in tree for this, I don't see why it would
need another infrastructure that doesn't really fit anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
